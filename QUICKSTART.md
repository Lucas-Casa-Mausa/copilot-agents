# 🚀 Quick Start Guide

## Para Começar em 30 Segundos

### 1. Clone ou Fork este Repo

```bash
# Opção A: Fork no GitHub (recomendado)
# 1. Clique em "Fork" no GitHub
# 2. Clone seu fork:
git clone https://github.com/SEU-USUARIO/copilot-agents.git
cd copilot-agents

# Opção B: Clone direto
git clone https://github.com/SEU-USUARIO/copilot-agents.git ~/copilot-agents
```

### 2. Instale em um Projeto

```bash
# Navegue até seu projeto
cd /caminho/do/seu/projeto

# Execute o script de setup
bash ~/copilot-agents/setup-agents.sh

# Ou use o one-liner
curl -sSL https://raw.githubusercontent.com/SEU-USUARIO/copilot-agents/main/setup-agents.sh | bash
```

### 3. Use no VSCode

1. Abra o VSCode no projeto
2. `Ctrl+Shift+I` (ou `Cmd+Shift+I` no Mac)
3. Clique no dropdown de agentes
4. Selecione "Code Reviewer Agent"
5. Digite: "Revise este código: [cole código]"

---

## 📋 Checklist de Setup Inicial

Após clonar o repositório:

- [ ] Substitua `SEU-USUARIO` nos arquivos:
  - [ ] `README.md` (3 ocorrências)
  - [ ] `setup-agents.sh` (1 ocorrência)
  - [ ] `QUICKSTART.md` (este arquivo)
- [ ] Atualize `LICENSE` com seu nome
- [ ] Customize o `code-reviewer.agent.md` se quiser
- [ ] Faça commit e push das mudanças
- [ ] Teste em um projeto real

---

## 🎯 Primeiro Teste

Teste rápido para verificar se está funcionando:

```bash
# 1. Crie um projeto de teste
mkdir test-copilot-agents
cd test-copilot-agents
git init

# 2. Instale o agente
bash ~/copilot-agents/setup-agents.sh

# 3. Crie arquivo com código problemático
cat > test.js << 'EOF'
function getData(id) {
  const data = db.query("SELECT * FROM users WHERE id = " + id);
  return data;
}
EOF

# 4. Abra no VSCode
code .

# 5. No Copilot Chat, peça para revisar test.js
```

O agente deve identificar:
- 🔴 SQL Injection
- 🟠 Operação síncrona
- 🟡 SELECT *
- 🟡 Falta error handling

---

## 🔧 Troubleshooting

### Agente não aparece no dropdown

1. Verifique se os arquivos estão em `.github/agents/`
2. Recarregue o VSCode (`Ctrl+Shift+P` → "Reload Window")
3. Certifique-se que o arquivo tem extensão `.agent.md`

### Script dá erro de permissão

```bash
chmod +x setup-agents.sh
```

### URL do raw.githubusercontent não funciona

Verifique se o repositório é público. Se for privado, use o método de clone + symlink.

---

## 📱 Comandos Úteis

```bash
# Atualizar todos os agentes em um projeto
cd seu-projeto
bash ~/copilot-agents/setup-agents.sh

# Ver quais agentes estão instalados
ls -la .github/agents/

# Remover agentes
rm -rf .github/agents

# Adicionar novo agente ao repo
cd ~/copilot-agents
cp novo-agente.agent.md .github/agents/
git add .github/agents/novo-agente.agent.md
git commit -m "feat: adiciona novo agente"
git push
```

---

## 💡 Próximos Passos

Agora que já configurou:

1. ⭐ **Dê uma estrela** neste repo se for útil
2. 📝 **Crie agentes personalizados** para suas necessidades
3. 🔄 **Compartilhe** com sua equipe
4. 🤝 **Contribua** com novos agentes úteis

---

**Dúvidas?** Abra uma [issue](https://github.com/SEU-USUARIO/copilot-agents/issues) ou [discussion](https://github.com/SEU-USUARIO/copilot-agents/discussions)