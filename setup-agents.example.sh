#!/usr/bin/env bash

set -euo pipefail

# Example setup script for GitHub Copilot custom agents
# - supports non-interactive mode via --yes or env var AUTOMATE=true
# - customizable repository owner/name/branch via env vars
# - safer downloads (curl --fail) and cleanup of partial files
# - simple agent list that can be extended

REPO_USER_DEFAULT="SEU-USUARIO"
REPO_NAME_DEFAULT="copilot-agents"
REPO_BRANCH_DEFAULT="main"

# Configurable via environment or CLI flags
REPO_USER="${REPO_USER:-$REPO_USER_DEFAULT}"
REPO_NAME="${REPO_NAME:-$REPO_NAME_DEFAULT}"
REPO_BRANCH="${REPO_BRANCH:-$REPO_BRANCH_DEFAULT}"
REPO_URL="https://raw.githubusercontent.com/${REPO_USER}/${REPO_NAME}/${REPO_BRANCH}"
AGENTS_DIR=".github/agents"

AUTOMATE=${AUTOMATE:-false}
FORCE=${FORCE:-false}

usage() {
    cat <<EOF
Usage: $(basename "$0") [options]

Options:
  --agent NAME      Download a single agent by name (filename without .agent.md)
  --all             Download all known agents
  --yes             Run non-interactively (confirm prompts)
  --user USER       GitHub user/org for repo (overrides REPO_USER env)
  --repo NAME       Repo name (overrides REPO_NAME env)
  --branch BRANCH   Branch (overrides REPO_BRANCH env)
  -h, --help        Show this help

Environment variables:
  AUTOMATE=true     Same as --yes
  REPO_USER, REPO_NAME, REPO_BRANCH

Example:
  AUTOMATE=true REPO_USER=me ./setup-agents.example.sh --all
EOF
}

# Basic colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo_header() {
    echo -e "${BLUE}==> $*${NC}"
}

# Check bash version for associative arrays
if (( BASH_VERSINFO[0] < 4 )); then
    echo -e "${YELLOW}⚠️  Bash < 4 detected. This example script may use features not available in older bash.${NC}"
fi

# Example agents map: extend as you create more agents
declare -A AGENTS=(
    [code-reviewer]="Revisor de código rigoroso e educativo"
    [deep-code-learning-agent]="Analisa padrões de código com aprendizado profundo e sugere melhorias"
    [performance-analysis]="Analisa performance e identifica gargalos; sugere otimizações"
    [pragmatic-documentation-agent]="Gera e melhora documentação prática e exemplos de uso"
    [architeture-pragmatic-agent]="Agente de arquitetura pragmática focado em avaliar decisões técnicas, trade-offs reais e risco futuro"
    [security-code-agent]="Auditor de segurança que identifica vulnerabilidades e sugere correções"
)

mkdir -p "$AGENTS_DIR"

download_agent() {
    local name="$1"
    local file
    if [[ "$name" == *.md ]]; then
        file="$name"
    else
        file="${name}.agent.md"
    fi
    local url="${REPO_URL}/.github/agents/${file}"
    local dest="${AGENTS_DIR}/${file}"

    echo "Downloading ${file} from ${url}"
    if curl --fail -sS -o "$dest" "$url"; then
        echo -e "${GREEN}Downloaded: ${dest}${NC}"
        return 0
    else
        echo -e "${RED}Failed to download ${file}${NC}"
        rm -f "$dest"
        return 1
    fi
}

confirm() {
    if [[ "$AUTOMATE" == "true" || "$FORCE" == "true" ]]; then
        return 0
    fi
    read -p "$1 (y/n): " -n 1 -r
    echo
    [[ $REPLY =~ ^[Yy]$ ]]
}

INSTALL_MODE=""
AGENT_TO_INSTALL=""

while [[ $# -gt 0 ]]; do
    case "$1" in
        --agent)
            AGENT_TO_INSTALL="$2"
            shift 2
            ;;
        --all)
            INSTALL_MODE="all"
            shift
            ;;
        --yes)
            AUTOMATE=true
            shift
            ;;
        --user)
            REPO_USER="$2"
            shift 2
            ;;
        --repo)
            REPO_NAME="$2"
            shift 2
            ;;
        --branch)
            REPO_BRANCH="$2"
            shift 2
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        *)
            echo "Unknown arg: $1"
            usage
            exit 1
            ;;
    esac
done

REPO_URL="https://raw.githubusercontent.com/${REPO_USER}/${REPO_NAME}/${REPO_BRANCH}"

echo_header "Repo: ${REPO_USER}/${REPO_NAME}@${REPO_BRANCH}"

if [[ -n "$AGENT_TO_INSTALL" ]]; then
    echo_header "Installing single agent: $AGENT_TO_INSTALL"
    if [[ -z "${AGENTS[$AGENT_TO_INSTALL]:-}" ]]; then
        echo -e "${YELLOW}Warning: agent '$AGENT_TO_INSTALL' is not in the local list. Will attempt download anyway.${NC}"
    fi
    download_agent "$AGENT_TO_INSTALL"
    exit $?
fi

if [[ "$INSTALL_MODE" == "all" ]]; then
    echo_header "Installing all known agents"
    for k in "${!AGENTS[@]}"; do
        echo "- $k : ${AGENTS[$k]}"
    done
    if confirm "Proceed to download all agents?"; then
        if [ ${#AGENTS[@]} -gt 1 ]; then
            for k in "${!AGENTS[@]}"; do
                download_agent "$k" || echo "Failed: $k"
            done
        else
            # try remote listing
            api_url="https://api.github.com/repos/${REPO_USER}/${REPO_NAME}/contents/.github/agents?ref=${REPO_BRANCH}"
            echo "Fetching agent list from ${api_url}"
            files=$(curl -sS --fail "$api_url" || true)
            if [[ -z "$files" ]]; then
                echo -e "${YELLOW}Warning: could not fetch remote agent list.${NC}"
            else
                mapfile -t remote_files < <(printf "%s" "$files" | grep '"name"' | sed -E 's/.*"name": "([^"]+)".*/\1/' | grep '\.md$' || true)
                if [ ${#remote_files[@]} -eq 0 ]; then
                    echo -e "${YELLOW}No agent files found in remote directory.${NC}"
                else
                    for f in "${remote_files[@]}"; do
                        download_agent "$f" || echo "Failed: $f"
                    done
                fi
            fi
        fi
    else
        echo "Aborted by user"
        exit 1
    fi
    exit 0
fi

echo_header "Interactive agent installer"
echo "Available agents:"

fetch_remote_agent_list() {
    api_url="https://api.github.com/repos/${REPO_USER}/${REPO_NAME}/contents/.github/agents?ref=${REPO_BRANCH}"
    files=$(curl -sS --fail "$api_url" || true)
    if [[ -z "$files" ]]; then
        return 1
    fi
    mapfile -t remote_files < <(printf "%s" "$files" | grep '"name"' | sed -E 's/.*"name": "([^\"]+)".*/\1/' | grep '\.md$' || true)
    if [ ${#remote_files[@]} -eq 0 ]; then
        return 1
    fi
    return 0
}

idx=1
agent_files=()
agent_names=()

if fetch_remote_agent_list; then
    for f in "${remote_files[@]}"; do
        display_name="${f%.agent.md}"
        display_name="${display_name%.md}"
        echo "  ${idx}. ${display_name} - ${AGENTS[$display_name]:-}"
        agent_files+=("$f")
        agent_names+=("$display_name")
        ((idx++))
    done
else
    mapfile -t keys < <(printf "%s\n" "${!AGENTS[@]}" | sort)
    for k in "${keys[@]}"; do
        echo "  ${idx}. ${k} - ${AGENTS[$k]}"
        agent_files+=("${k}.agent.md")
        agent_names+=("$k")
        ((idx++))
    done
fi

echo "  0. Cancel"

read -p "Choose an option (0-$((idx-1))): " choice
if [[ "$choice" == "0" ]]; then
    echo "Cancelled"
    exit 0
fi
if ! [[ "$choice" =~ ^[0-9]+$ ]]; then
    echo "Invalid choice"
    exit 1
fi
sel_index=$((choice-1))
sel_file="${agent_files[$sel_index]:-}"
if [[ -z "$sel_file" ]]; then
    echo "Invalid selection"
    exit 1
fi

download_agent "$sel_file"

echo_header "Done"

exit 0
