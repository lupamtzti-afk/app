# Spec: Controle de Parcelas — Redesign Mobile App

**Data:** 2026-06-27  
**Arquivo alvo:** `c:\Users\lfaustino\Downloads\controle-parcelas.jsx`  
**Preview:** Vite em `http://localhost:5199` (`scratchpad/preview-app/src/App.jsx`)

---

## 1. Objetivo

Transformar a interface atual (layout desktop simples, tema verde) em uma interface estilo app mobile com navegação em abas, tema roxo (#7C3AED), tipografia Poppins e layout responsivo full-width. Toda a lógica existente (CRUD de cartões e compras, persistência via `window.storage`, Chart.js, relatório) é preservada sem alteração.

---

## 2. Paleta e Tipografia

| Token      | Valor       |
|------------|-------------|
| `primary`  | `#7C3AED`   |
| `primaryDark` | `#5B21B6` |
| `bg`       | `#F0EEF8`   |
| `surface`  | `#FFFFFF`   |
| `ink`      | `#1A1233`   |
| `muted`    | `#8B83B0`   |
| `green`    | `#10B981`   |
| `red`      | `#EF4444`   |

**Fonte:** Poppins (Google Fonts)  
- Corpo/labels: `Poppins 400`  
- Subtítulos/números: `Poppins 500/600`  
- Títulos de seção e `<h1>`: `Poppins 700` (Bold)

Substituir referências a Space Grotesk, Inter e Space Mono.

---

## 3. Layout Geral

- `max-width: 680px`, `margin: 0 auto`
- Fundo `#F0EEF8` no `<body>` e root
- `padding-bottom: 80px` no conteúdo principal (espaço para bottom nav)
- Sem "phone shell" (sem borda, sem sombra externa simulando celular)
- Responsivo: em telas acima de 680px, o conteúdo centra com margem lateral

---

## 4. Navegação (Bottom Nav)

Barra fixa no rodapé, altura 64px, fundo branco, sombra superior sutil.

```
[ 🏠 Início ]  [ 💳 Cartões ]  [ ⊕ FAB ]  [ 🛒 Compras ]  [ 📊 Relatório ]
```

- **FAB (⊕):** botão circular 56px, `background: #7C3AED`, elevado 28px acima da barra, abre diretamente o modal de nova compra
- Aba ativa: ícone + label em `#7C3AED`, demais em `#8B83B0`
- Estado: `activeTab` ∈ `'home' | 'cards' | 'expenses' | 'report'`

---

## 5. Aba: Início (HomeView)

**Header roxo com gradiente** (`#7C3AED → #5B21B6`), texto branco:
- Título "Controle de Parcelas" em Poppins 700
- Subtítulo mês atual (ex: "Junho 2026")

**Card de resumo** (fundo `surface`, sombra sutil, border-radius 16px):
- Valor grande: total mensal comprometido (Poppins 700, 28px)
- Duas métricas menores em linha: "A pagar no total" e "Compras ativas"

**Card de gráfico** (donut Chart.js):
- Fatias por cartão, proporcional ao valor mensal de cada um
- Cores vindas de `CARD_COLORS`
- Legenda abaixo: `● NomeCartão — R$ xxx — xx%`
- Se não há cartões/compras: estado vazio centralizado

**Card de recentes:**
- Título "Compras recentes"
- Até 5 compras ativas mais recentes (ordenadas por data desc)
- Cada item: nome da compra, nome do cartão (chip colorido), parcelas pagas/total, valor mensal

---

## 6. Aba: Cartões (CardsView)

**Header simples:** título "Meus Cartões" + botão "+ Novo Cartão" (ghost, roxo)

**Lista de cards visuais** (um por cartão cadastrado):
- Card com barra de cor lateral (ou fundo gradient) na cor do cartão
- Nome do cartão (Poppins 600), valor mensal comprometido
- Linha de progresso: compras pagas vs. ativas
- Botão "×" (delete) — mantém lógica atual com `window.confirm`
- Estado vazio com CTA "Cadastrar cartão"

---

## 7. Aba: Compras (ExpensesView)

**Header simples:** título "Parcelas Ativas"

**Chips de filtro por cartão** (scroll horizontal):
- "Todos" + um chip por cartão (reutiliza lógica de `filterCard`)

**Toggle:** Todos / Ativos / Quitados

**Lista de despesas** (reutiliza componente `ExpenseRow` existente, ajustado ao tema roxo)

---

## 8. Aba: Relatório (ReportView)

Conteúdo atual do `ReportModal` movido para view full-page (sem modal):
- Filtros: Cartão + Mês + Status (chips ou selects)
- Resumo dinâmico com 5 métricas
- Tabela com scroll horizontal em mobile
- Botão "Imprimir / PDF" (`window.print()`)

---

## 9. Modais Mantidos

- **Nova/editar compra** (`ExpenseModal`) — abre via FAB ou edição na lista
- **Novo cartão** (`CardModal`) — abre via botão em CardsView
- Ambos mantêm `type="button"` em todos os botões internos
- Backdrop: fecha apenas quando `e.target === e.currentTarget`

---

## 10. Constantes Alteradas

```js
const C = {
  bg: "#F0EEF8",
  surface: "#FFFFFF",
  surfaceAlt: "#FAF8FF",
  ink: "#1A1233",
  inkSoft: "#3D2B6E",
  muted: "#8B83B0",
  line: "#E4DFFA",
  primary: "#7C3AED",
  primaryDark: "#5B21B6",
  accent: "#10B981",
  accentSoft: "#D1FAE5",
  green: "#10B981",
  red: "#EF4444",
};

const FONTS = {
  display: "'Poppins', system-ui, sans-serif",
  body: "'Poppins', system-ui, sans-serif",
  mono: "'Poppins', system-ui, sans-serif",
};
```

Google Fonts URL: `Poppins:wght@400;500;600;700`

---

## 11. Estado da Aplicação

Novos estados adicionados no `App`:
```js
const [activeTab, setActiveTab] = useState('home');
```

Removido: `showReport` (substituído por `activeTab === 'report'`)  
Mantidos: `cards`, `expenses`, `loaded`, `filterCard`, `showCardForm`, `expenseModal`

---

## 12. Estrutura de Componentes (pós-redesign)

```
App
├── BottomNav (activeTab, onTabChange, onFAB)
├── HomeView (cards, expenses, enrich, totals, cardTotals, cardById)
├── CardsView (cards, cardTotals, onAdd, onDelete)
├── ExpensesView (visible, cards, filterCard, setFilterCard, onEdit, onDelete, setPaid)
├── ReportView (expenses, cards, enrich, cardById)
├── ExpenseModal (cards, onSave, onClose, initial?)
├── CardModal (onSave, onClose)
└── [helpers] Stat, Empty, brl, uid, store
```

---

## 12b. Funcionalidade: Escanear Nota (📷)

**Botão "📷 Escanear nota"** aparece no topo do formulário de Nova/Editar Compra.

**Fluxo:**
1. Clique → abre `<input type="file" accept="image/*" capture="environment">` (câmera no celular, galeria no desktop)
2. Imagem lida como base64 via `FileReader`
3. Se não há chave API salva: abre `ApiKeyModal` para configurar (salva em `window.storage` sob `"cp_anthropic_key"`)
4. POST para `https://api.anthropic.com/v1/messages` (model: `claude-haiku-4-5-20251001`) com a imagem
5. Claude extrai: `supplier`, `total` (número BRL), `date` (ISO), `installments`
6. Campos do formulário pré-preenchidos; usuário revisa, escolhe cartão e salva normalmente

**Componentes adicionados:**
- `ApiKeyModal` — modal simples para coletar e salvar a chave Anthropic
- `ScanButton` — encapsula toda a lógica de scan (file input, FileReader, fetch, pre-fill callback)

**Estilo do botão:**
```js
scanBtn: {
  background: C.surfaceAlt,
  border: `2px dashed ${C.line}`,
  color: C.primary,
  fontWeight: 600,
  width: "100%",
  padding: "12px",
  borderRadius: 12,
}
```

---

## 13. O que NÃO muda

- Toda lógica de CRUD (`addCard`, `deleteCard`, `saveExpense`, `deleteExpense`, `setPaid`)
- Persistência via `window.storage` (store.get / store.set)
- Funções derivadas (`enrich`, `visible`, `totals`, `cardTotals`, `cardById`)
- `CARD_COLORS`, `MONTHS_PT`, `brl`, `uid`
- Chart.js para o donut (mesma lógica, nova view)
- Campos do formulário de compra (nome, cartão, total, parcelas, data)
- Campos do formulário de cartão (nome, cor)
