# 🤖 GitHub Copilot Custom Agents

Coleção de agentes customizados para GitHub Copilot que funcionam em qualquer projeto.

## 📦 Agentes Disponíveis

### 🔍 Code Reviewer
**Arquivo:** `code-reviewer.agent.md`

Revisor de código rigoroso e educativo que:
- ✅ Identifica problemas de segurança, performance e qualidade
- ✅ Explica **por que** cada problema existe
- ✅ Fornece código corrigido com explicações
- ✅ Funciona em qualquer linguagem
- ✅ Prioriza por severidade (Crítico → Alto → Médio → Baixo)

**Categorias de análise:**
- 🔐 Segurança (SQL injection, XSS, secrets)
- ⚡ Performance (N+1, loops, memory leaks)
- 🎯 Qualidade (DRY, SOLID, code smells)
- 📚 Boas práticas da linguagem
- 🧪 Testabilidade
- 🏗️ Arquitetura

---

## 🚀 Instalação Rápida

### Método 1: Script Automático (Recomendado)

```bash
# No diretório do seu projeto
curl -sSL https://raw.githubusercontent.com/SEU-USUARIO/copilot-agents/main/setup-agents.sh | bash
```

Ou baixe e execute:

```bash
curl -O https://raw.githubusercontent.com/SEU-USUARIO/copilot-agents/main/setup-agents.sh
chmod +x setup-agents.sh
./setup-agents.sh
```

### Método 2: Git Submodule

```bash
# Adiciona como submodule
git submodule add https://github.com/SEU-USUARIO/copilot-agents.git .github

# Atualiza quando necessário
git submodule update --remote
```

### Método 3: Manual

```bash
# Cria diretório
mkdir -p .github/agents

# Baixa agente específico
curl -o .github/agents/code-reviewer.agent.md \
  https://raw.githubusercontent.com/SEU-USUARIO/copilot-agents/main/.github/agents/code-reviewer.agent.md
```

### Método 4: Symlink (Para uso local)

```bash
# Clone o repo uma vez
git clone https://github.com/SEU-USUARIO/copilot-agents.git ~/copilot-agents

# Em cada projeto
ln -s ~/copilot-agents/.github .github
```

---

## 💻 Como Usar

1. **Instale os agentes** no seu projeto (escolha um método acima)

2. **Abra o VSCode** no projeto

3. **Abra o Copilot Chat**:
   - Windows/Linux: `Ctrl + Shift + I`
   - Mac: `Cmd + Shift + I`

4. **Selecione o agente**:
   - Clique no dropdown (ícone de robô/seletor)
   - Escolha seu agente customizado
   - **Nota:** Agentes customizados são selecionados via dropdown, não digitando `@`

5. **Use normalmente**:
   ```
   Revise este código:
   [cole seu código ou mencione arquivo]
   ```

---

## 📝 Exemplos de Uso

### Code Reviewer

**Revisar arquivo específico:**
```
Revise o arquivo src/controllers/userController.js
```

**Revisar código inline:**
```
Revise este código:

function getData(id) {
  return db.query("SELECT * FROM users WHERE id = " + id);
}
```

**Revisar com foco específico:**
```
Revise este código focando em segurança e performance
```

**Comparar abordagens:**
```
Qual abordagem é melhor e por quê?

Opção A: [código]
Opção B: [código]
```

---

## 🛠️ Customização

### Modificar Agente Existente

1. Edite o arquivo `.agent.md` do agente
2. Ajuste as instruções no corpo do Markdown
3. Recarregue o VSCode ou reinicie o Copilot

### Criar Novo Agente

Crie um arquivo `.github/agents/meu-agente.agent.md`:

```markdown
---
description: Breve descrição do agente
tools: ['fetch', 'search', 'githubRepo']
model: Claude Sonnet 4.5
---

# Instruções do Seu Agente

Você é um especialista em...

## Regras
- Regra 1
- Regra 2

## Formato de Saída
...
```

**Ferramentas disponíveis:**
- `fetch` - Buscar conteúdo de URLs
- `search` - Pesquisar no código/docs
- `githubRepo` - Acessar informações do repositório

**Modelos disponíveis:**
- `Claude Sonnet 4.5` - Melhor para análises complexas
- `Claude Sonnet 3.5` - Versão anterior
- `GPT-4o` - OpenAI mais avançado
- `GPT-4o mini` - Mais rápido e leve

---

## 🎯 Agentes Especializados (Ideias)

Você pode criar agentes específicos para:

- **Test Generator**: Gera testes unitários seguindo padrões do projeto
- **Documentation Writer**: Cria documentação consistente
- **API Designer**: Revisa/cria APIs REST/GraphQL
- **Database Optimizer**: Analisa queries SQL e sugere otimizações
- **Accessibility Checker**: Verifica conformidade WCAG
- **Security Auditor**: Foco exclusivo em vulnerabilidades
- **Refactoring Guide**: Sugere refatorações seguras
- **Performance Analyzer**: Deep dive em bottlenecks

---

## 🔄 Atualização

Para atualizar os agentes:

**Usando script:**
```bash
./setup-agents.sh
```

**Usando submodule:**
```bash
git submodule update --remote
```

**Manualmente:**
```bash
# Re-execute o comando curl para o agente específico
curl -o .github/agents/code-reviewer.agent.md \
  https://raw.githubusercontent.com/SEU-USUARIO/copilot-agents/main/.github/agents/code-reviewer.agent.md
```

---

## 🤝 Contribuindo

Quer adicionar um novo agente ou melhorar um existente?

1. Fork este repositório
2. Crie um branch para sua feature (`git checkout -b feat/novo-agente`)
3. Adicione seu agente em `.github/agents/`
4. Atualize este README com documentação
5. Commit suas mudanças (`git commit -m 'feat: adiciona agente X'`)
6. Push para o branch (`git push origin feat/novo-agente`)
7. Abra um Pull Request

---

## 📚 Recursos

- [Documentação oficial de Custom Agents](https://docs.github.com/en/copilot/using-github-copilot/using-extensions-to-integrate-external-tools-with-copilot-chat)
- [GitHub Copilot na IDE](https://code.visualstudio.com/docs/copilot/overview)
- [Melhores práticas de Code Review](https://google.github.io/eng-practices/review/)

---

## 📄 Licença

MIT License - sinta-se livre para usar, modificar e distribuir.

---

## 🐛 Issues & Suporte

Encontrou um bug ou tem uma sugestão?
- Abra uma [issue](https://github.com/SEU-USUARIO/copilot-agents/issues)
- Para dúvidas rápidas, use as [Discussions](https://github.com/SEU-USUARIO/copilot-agents/discussions)

---

<div align="center">

**Feito com ☕ e muita revisão de código**

⭐ Se este repo te ajudou, deixe uma estrela!

</div>