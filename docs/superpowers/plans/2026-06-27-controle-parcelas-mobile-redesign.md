# Controle de Parcelas — Mobile App Redesign Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Redesign controle-parcelas.jsx into a purple-themed mobile app interface with bottom navigation, Poppins font, and four view tabs (Início, Cartões, Compras, Relatório).

**Architecture:** Single JSX file. Replace the entire visual layer (C constants, FONTS, CSS, `s` styles, layout) while keeping all business logic (store, enrich, CRUD handlers, useMemo derivations) untouched. Add `BottomNav` + four View components. `ReportModal` becomes `ReportView` (full page, no Modal wrapper). SVG donut chart — no new npm dependencies.

**Tech Stack:** React 18, SVG donut chart, inline styles + one `<style>` tag, Google Fonts (Poppins), `window.storage` persistence.

## Global Constraints

- Production file: `c:\Users\lfaustino\Downloads\controle-parcelas.jsx`
- Preview file: `<scratchpad>/preview-app/src/App.jsx` (keep in sync — copy after each task)
- Scratchpad path: `C:\Users\LFAUST~1\AppData\Local\Temp\claude\c--Users-lfaustino-Gestao-de-pagamentos-Gestao-de-Pagamentos\f5d417d4-4de6-4a18-861f-7750c82c7e41\scratchpad\preview-app\src\App.jsx`
- Preview server: Vite at `http://localhost:5199` — verify visually after each task
- No new npm dependencies — SVG donut, no Chart.js
- Font: Poppins 400/500/600/700 via Google Fonts
- Primary purple: `#7C3AED`, dark: `#5B21B6`, bg: `#F0EEF8`
- Layout: `max-width: 680px`, centered, `padding-bottom: 80px` for bottom nav clearance
- All modal buttons must keep `type="button"` — do not remove
- All logic in `store`, `enrich`, `addCard`, `deleteCard`, `saveExpense`, `deleteExpense`, `setPaid`, `cardById`, `visible`, `totals`, `cardTotals` must remain byte-for-byte identical
- Desktop + mobile: full-width responsive, single column

---

### Task 1: Replace Color & Font Constants

**Files:**
- Modify: `c:\Users\lfaustino\Downloads\controle-parcelas.jsx` lines 7–33, 86–88

**Interfaces:**
- Produces: Updated `C`, `FONTS` constants and Poppins Google Fonts URL used by all subsequent tasks

- [ ] **Step 1: Replace the `C` constant (lines 7–20)**

Find:
```js
const C = {
  bg: "#EEF0EC",
  surface: "#FFFFFF",
  surfaceAlt: "#F6F8F4",
  ink: "#16231D",
  inkSoft: "#3A463F",
  muted: "#6E7B73",
  line: "#DCE2DA",
  primary: "#0F6E5A",
  primaryDark: "#0A4D3F",
  accent: "#E2603F",
  accentSoft: "#FBEAE4",
  green: "#0F6E5A",
};
```
Replace with:
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
```

- [ ] **Step 2: Replace the `FONTS` constant (lines 29–33)**

Find:
```js
const FONTS = {
  display: "'Space Grotesk', system-ui, sans-serif",
  body: "'Inter', system-ui, sans-serif",
  mono: "'Space Mono', 'SFMono-Regular', monospace",
};
```
Replace with:
```js
const FONTS = {
  display: "'Poppins', system-ui, sans-serif",
  body: "'Poppins', system-ui, sans-serif",
  mono: "'Poppins', system-ui, sans-serif",
};
```

- [ ] **Step 3: Replace the Google Fonts URL in the font injection `useEffect` (lines 86–88)**

Find:
```js
    link.href =
      "https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@400;500;600;700&family=Inter:wght@400;500;600&family=Space+Mono:wght@400;700&display=swap";
```
Replace with:
```js
    link.href =
      "https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap";
```

- [ ] **Step 4: Copy file to preview and verify**

Run in PowerShell:
```powershell
Copy-Item "c:\Users\lfaustino\Downloads\controle-parcelas.jsx" "C:\Users\LFAUST~1\AppData\Local\Temp\claude\c--Users-lfaustino-Gestao-de-pagamentos-Gestao-de-Pagamentos\f5d417d4-4de6-4a18-861f-7750c82c7e41\scratchpad\preview-app\src\App.jsx" -Force
```

Open `http://localhost:5199` — the app should now show a purple primary color and Poppins font (reload if needed).

- [ ] **Step 5: Commit**

```bash
git -C "c:/Users/lfaustino/Gestao de pagamentos/Gestao_de_Pagamentos" add -A
git -C "c:/Users/lfaustino/Gestao de pagamentos/Gestao_de_Pagamentos" commit -m "refactor: replace colors and fonts with purple theme + Poppins"
```

---

### Task 2: Add `activeTab` State + `BottomNav` Component + Wire App Render

**Files:**
- Modify: `c:\Users\lfaustino\Downloads\controle-parcelas.jsx`

**Interfaces:**
- Produces: `activeTab` state in `App`; `BottomNav` component; App renders a shell with bottom nav and content area; `showReport` state removed

- [ ] **Step 1: Add `activeTab` state and remove `showReport` state**

In `App`, find:
```js
  const [showReport, setShowReport] = useState(false);
```
Replace with:
```js
  const [activeTab, setActiveTab] = useState("home");
```

- [ ] **Step 2: Replace the entire App `return` (lines 191–337) with the new tab shell**

Find the entire block starting with `return (` and ending with the closing `);` of the App component. Replace with:

```jsx
  return (
    <div style={s.root} className="cp-root">
      <style>{css}</style>

      {activeTab === "home" && (
        <HomeView
          cards={cards}
          expenses={expenses}
          enrich={enrich}
          totals={totals}
          cardTotals={cardTotals}
          cardById={cardById}
        />
      )}
      {activeTab === "cards" && (
        <CardsView
          cards={cards}
          cardTotals={cardTotals}
          onAdd={() => setShowCardForm(true)}
          onDelete={deleteCard}
        />
      )}
      {activeTab === "expenses" && (
        <ExpensesView
          expenses={expenses}
          cards={cards}
          enrich={enrich}
          cardById={cardById}
          filterCard={filterCard}
          setFilterCard={setFilterCard}
          onEdit={(e) => setExpenseModal(e)}
          onDelete={deleteExpense}
          setPaid={setPaid}
        />
      )}
      {activeTab === "report" && (
        <ReportView
          expenses={expenses}
          cards={cards}
          cardById={cardById}
          enrich={enrich}
        />
      )}

      <BottomNav
        active={activeTab}
        onChange={setActiveTab}
        onFAB={() => cards.length ? setExpenseModal({}) : setShowCardForm(true)}
      />

      {showCardForm && (
        <CardForm onSave={addCard} onClose={() => setShowCardForm(false)} />
      )}
      {expenseModal && (
        <ExpenseForm
          initial={expenseModal}
          cards={cards}
          defaultCard={filterCard !== "all" ? filterCard : cards[0]?.id}
          onSave={saveExpense}
          onClose={() => setExpenseModal(null)}
        />
      )}
    </div>
  );
```

- [ ] **Step 3: Add `BottomNav` component after the closing `}` of `App`**

Insert this block before the `/* --------------------------- subcomponents */` comment:

```jsx
function BottomNav({ active, onChange, onFAB }) {
  const items = [
    { id: "home", label: "Início", icon: "🏠" },
    { id: "cards", label: "Cartões", icon: "💳" },
    { id: "expenses", label: "Compras", icon: "🛒" },
    { id: "report", label: "Relatório", icon: "📊" },
  ];
  const left = items.slice(0, 2);
  const right = items.slice(2);

  return (
    <nav style={s.bottomNav}>
      <div style={s.bottomNavInner}>
        {left.map((item) => (
          <button
            type="button"
            key={item.id}
            style={{ ...s.navBtn, ...(active === item.id ? s.navBtnActive : {}) }}
            onClick={() => onChange(item.id)}
          >
            <span style={s.navIcon}>{item.icon}</span>
            <span style={s.navLabel}>{item.label}</span>
          </button>
        ))}

        <div style={s.fabWrap}>
          <button type="button" style={s.fab} onClick={onFAB} title="Nova compra">
            <span style={{ fontSize: 28, lineHeight: 1, color: "#fff", marginTop: -2 }}>+</span>
          </button>
        </div>

        {right.map((item) => (
          <button
            type="button"
            key={item.id}
            style={{ ...s.navBtn, ...(active === item.id ? s.navBtnActive : {}) }}
            onClick={() => onChange(item.id)}
          >
            <span style={s.navIcon}>{item.icon}</span>
            <span style={s.navLabel}>{item.label}</span>
          </button>
        ))}
      </div>
    </nav>
  );
}
```

- [ ] **Step 4: Add bottom nav styles to the `s` object**

In the `s` object (at the bottom of the file), add these entries before the closing `};`:

```js
  bottomNav: {
    position: "fixed",
    bottom: 0,
    left: 0,
    right: 0,
    background: C.surface,
    borderTop: `1px solid ${C.line}`,
    boxShadow: "0 -4px 20px rgba(124,58,237,0.08)",
    zIndex: 100,
    height: 64,
  },
  bottomNavInner: {
    display: "flex",
    alignItems: "center",
    justifyContent: "space-around",
    maxWidth: 680,
    margin: "0 auto",
    height: "100%",
    padding: "0 8px",
  },
  navBtn: {
    flex: 1,
    display: "flex",
    flexDirection: "column",
    alignItems: "center",
    gap: 2,
    border: "none",
    background: "transparent",
    cursor: "pointer",
    padding: "6px 4px",
    borderRadius: 12,
    color: C.muted,
    minWidth: 0,
  },
  navBtnActive: { color: C.primary },
  navIcon: { fontSize: 18, lineHeight: 1 },
  navLabel: { fontSize: 10, fontWeight: 600, fontFamily: FONTS.body, letterSpacing: 0.2 },
  fabWrap: {
    flex: "0 0 auto",
    display: "flex",
    justifyContent: "center",
    alignItems: "center",
    width: 64,
    marginTop: -28,
  },
  fab: {
    width: 56,
    height: 56,
    borderRadius: "50%",
    background: `linear-gradient(135deg, ${C.primary}, ${C.primaryDark})`,
    border: "none",
    boxShadow: "0 4px 16px rgba(124,58,237,0.45)",
    cursor: "pointer",
    display: "flex",
    alignItems: "center",
    justifyContent: "center",
  },
```

- [ ] **Step 5: Update the `s.root` style to remove the old max-width and add padding-bottom**

Find in `s`:
```js
  root: {
    fontFamily: FONTS.body,
    background: C.bg,
    color: C.ink,
    minHeight: "100vh",
    padding: "28px clamp(16px, 4vw, 48px) 60px",
    maxWidth: 1040,
    margin: "0 auto",
  },
```
Replace with:
```js
  root: {
    fontFamily: FONTS.body,
    background: C.bg,
    color: C.ink,
    minHeight: "100vh",
    maxWidth: 680,
    margin: "0 auto",
    paddingBottom: 80,
  },
```

- [ ] **Step 6: Copy to preview and verify**

```powershell
Copy-Item "c:\Users\lfaustino\Downloads\controle-parcelas.jsx" "C:\Users\LFAUST~1\AppData\Local\Temp\claude\c--Users-lfaustino-Gestao-de-pagamentos-Gestao-de-Pagamentos\f5d417d4-4de6-4a18-861f-7750c82c7e41\scratchpad\preview-app\src\App.jsx" -Force
```

Expected: bottom navigation bar appears, FAB button visible in center, tapping nav items switches tabs (content areas will be empty until next tasks).

---

### Task 3: Add `HomeView` Component

**Files:**
- Modify: `c:\Users\lfaustino\Downloads\controle-parcelas.jsx`

**Interfaces:**
- Consumes: `cards`, `expenses`, `enrich`, `totals` (`{monthly, remaining, activeCount}`), `cardTotals` (`{[cardId]: number}`), `cardById`
- Produces: `HomeView` component with purple gradient header, summary card, SVG donut chart, recent expenses card

- [ ] **Step 1: Add `DonutChart` component**

Insert after the `BottomNav` component:

```jsx
function DonutChart({ segments, centerLabel }) {
  const r = 54;
  const cx = 80;
  const cy = 80;
  const strokeW = 20;
  const circumference = 2 * Math.PI * r;
  const total = segments.reduce((s, x) => s + x.value, 0);

  if (!total) {
    return (
      <svg viewBox="0 0 160 160" width={160} height={160}>
        <circle cx={cx} cy={cy} r={r} fill="none" stroke={C.line} strokeWidth={strokeW} />
        <text x="80" y="76" textAnchor="middle" fontSize="10" fill={C.muted} fontFamily={FONTS.body}>SEM</text>
        <text x="80" y="92" textAnchor="middle" fontSize="10" fill={C.muted} fontFamily={FONTS.body}>COMPRAS</text>
      </svg>
    );
  }

  let cumulative = 0;
  const slices = segments.map((seg) => {
    const fraction = seg.value / total;
    const dash = fraction * circumference;
    const offset = -cumulative;
    cumulative += dash;
    return { ...seg, dash, offset };
  });

  return (
    <svg viewBox="0 0 160 160" width={160} height={160}>
      <circle cx={cx} cy={cy} r={r} fill="none" stroke={C.line} strokeWidth={strokeW} />
      <g transform="rotate(-90 80 80)">
        {slices.map((slice, i) => (
          <circle
            key={i}
            cx={cx}
            cy={cy}
            r={r}
            fill="none"
            stroke={slice.color}
            strokeWidth={strokeW}
            strokeDasharray={`${slice.dash} ${circumference - slice.dash}`}
            strokeDashoffset={slice.offset}
          />
        ))}
      </g>
      <text x="80" y="76" textAnchor="middle" fontSize="10" fill={C.muted} fontFamily={FONTS.body} fontWeight="500">MENSAL</text>
      <text x="80" y="95" textAnchor="middle" fontSize="14" fontWeight="700" fill={C.ink} fontFamily={FONTS.body}>
        {centerLabel}
      </text>
    </svg>
  );
}
```

- [ ] **Step 2: Add `HomeView` component**

Insert after `DonutChart`:

```jsx
function HomeView({ cards, expenses, enrich, totals, cardTotals, cardById }) {
  const now = new Date();
  const monthName = ["Janeiro","Fevereiro","Março","Abril","Maio","Junho",
    "Julho","Agosto","Setembro","Outubro","Novembro","Dezembro"][now.getMonth()];
  const year = now.getFullYear();

  const donutSegments = cards
    .filter((c) => cardTotals[c.id] > 0)
    .map((c) => ({ label: c.name, value: cardTotals[c.id], color: c.color }));

  const recentExpenses = expenses
    .map(enrich)
    .filter((e) => !e.done)
    .sort((a, b) => (b.date || "").localeCompare(a.date || ""))
    .slice(0, 5);

  return (
    <div>
      {/* purple gradient header */}
      <div style={s.homeHeader}>
        <div style={s.homeHeaderKicker}>controle de parcelas</div>
        <h1 style={s.homeHeaderTitle}>Controle de Parcelas</h1>
        <div style={s.homeHeaderSub}>{monthName} {year}</div>
      </div>

      <div style={s.homeBody}>
        {/* summary card */}
        <div style={s.homeCard}>
          <div style={s.homeBigValue}>{brl(totals.monthly)}</div>
          <div style={s.homeBigLabel}>compromisso mensal</div>
          <div style={s.homeStatRow}>
            <div style={s.homeStat}>
              <span style={s.homeStatVal}>{brl(totals.remaining)}</span>
              <span style={s.homeStatLbl}>a pagar no total</span>
            </div>
            <div style={s.homeStatDiv} />
            <div style={s.homeStat}>
              <span style={s.homeStatVal}>{totals.activeCount}</span>
              <span style={s.homeStatLbl}>compras ativas</span>
            </div>
          </div>
        </div>

        {/* chart card */}
        {cards.length > 0 && (
          <div style={s.homeCard}>
            <div style={s.homeCardTitle}>Por cartão</div>
            <div style={s.chartArea}>
              <DonutChart segments={donutSegments} centerLabel={brl(totals.monthly)} />
              <div style={s.chartLegend}>
                {cards.map((c) => {
                  const val = cardTotals[c.id] || 0;
                  const pct = totals.monthly > 0 ? Math.round((val / totals.monthly) * 100) : 0;
                  return (
                    <div key={c.id} style={s.legendRow}>
                      <span style={{ ...s.legendDot, background: c.color }} />
                      <span style={s.legendName}>{c.name}</span>
                      <span style={s.legendAmt}>{brl(val)}</span>
                      <span style={s.legendPct}>{pct}%</span>
                    </div>
                  );
                })}
              </div>
            </div>
          </div>
        )}

        {/* recents card */}
        {recentExpenses.length > 0 && (
          <div style={s.homeCard}>
            <div style={s.homeCardTitle}>Compras recentes</div>
            <div style={{ display: "flex", flexDirection: "column", gap: 10 }}>
              {recentExpenses.map((e) => {
                const card = cardById[e.cardId];
                return (
                  <div key={e.id} style={s.recentRow}>
                    <span style={{ ...s.recentDot, background: card?.color || C.muted }} />
                    <div style={s.recentInfo}>
                      <span style={s.recentName}>{e.supplier}</span>
                      <span style={s.recentMeta}>
                        {card?.name || "sem cartão"} · {e.paidInstallments}/{e.totalInstallments} parcelas
                      </span>
                    </div>
                    <span style={s.recentAmt}>{brl(e.monthly)}/mês</span>
                  </div>
                );
              })}
            </div>
          </div>
        )}

        {cards.length === 0 && (
          <div style={s.homeCard}>
            <p style={{ color: C.muted, textAlign: "center", margin: 0, lineHeight: 1.6 }}>
              Cadastre um cartão e lance suas compras para ver o resumo aqui.
            </p>
          </div>
        )}
      </div>
    </div>
  );
}
```

- [ ] **Step 3: Add HomeView styles to the `s` object**

```js
  homeHeader: {
    background: `linear-gradient(135deg, ${C.primary} 0%, ${C.primaryDark} 100%)`,
    padding: "36px 20px 28px",
    color: "#fff",
  },
  homeHeaderKicker: {
    fontSize: 10,
    fontWeight: 600,
    letterSpacing: 2.5,
    textTransform: "uppercase",
    opacity: 0.75,
    marginBottom: 8,
  },
  homeHeaderTitle: {
    fontFamily: FONTS.display,
    fontSize: 26,
    fontWeight: 700,
    margin: 0,
    marginBottom: 4,
    letterSpacing: "-0.02em",
  },
  homeHeaderSub: { fontSize: 14, opacity: 0.8, fontWeight: 500 },
  homeBody: { padding: "16px 16px 0", display: "flex", flexDirection: "column", gap: 14 },
  homeCard: {
    background: C.surface,
    borderRadius: 18,
    padding: "18px 18px",
    boxShadow: "0 2px 12px rgba(124,58,237,0.07)",
  },
  homeCardTitle: {
    fontFamily: FONTS.display,
    fontSize: 14,
    fontWeight: 700,
    color: C.inkSoft,
    marginBottom: 14,
  },
  homeBigValue: {
    fontFamily: FONTS.display,
    fontSize: 34,
    fontWeight: 700,
    color: C.primary,
    letterSpacing: "-0.02em",
    marginBottom: 4,
  },
  homeBigLabel: { fontSize: 12, color: C.muted, fontWeight: 500, marginBottom: 16 },
  homeStatRow: { display: "flex", alignItems: "center", gap: 16 },
  homeStat: { flex: 1, display: "flex", flexDirection: "column", gap: 2 },
  homeStatDiv: { width: 1, height: 32, background: C.line },
  homeStatVal: { fontSize: 16, fontWeight: 700, color: C.ink },
  homeStatLbl: { fontSize: 11, color: C.muted, fontWeight: 500 },
  chartArea: { display: "flex", alignItems: "center", gap: 16, flexWrap: "wrap" },
  chartLegend: { flex: 1, minWidth: 140, display: "flex", flexDirection: "column", gap: 10 },
  legendRow: { display: "flex", alignItems: "center", gap: 8 },
  legendDot: { width: 10, height: 10, borderRadius: "50%", flex: "0 0 auto" },
  legendName: { flex: 1, fontSize: 13, fontWeight: 600, color: C.ink },
  legendAmt: { fontSize: 12, fontWeight: 700, color: C.inkSoft },
  legendPct: { fontSize: 11, color: C.muted, minWidth: 32, textAlign: "right" },
  recentRow: { display: "flex", alignItems: "center", gap: 12 },
  recentDot: { width: 10, height: 10, borderRadius: "50%", flex: "0 0 auto" },
  recentInfo: { flex: 1, minWidth: 0 },
  recentName: { display: "block", fontSize: 14, fontWeight: 600, color: C.ink, whiteSpace: "nowrap", overflow: "hidden", textOverflow: "ellipsis" },
  recentMeta: { display: "block", fontSize: 11, color: C.muted, fontWeight: 500 },
  recentAmt: { fontSize: 13, fontWeight: 700, color: C.primary, whiteSpace: "nowrap" },
```

- [ ] **Step 4: Copy to preview and verify**

```powershell
Copy-Item "c:\Users\lfaustino\Downloads\controle-parcelas.jsx" "C:\Users\LFAUST~1\AppData\Local\Temp\claude\c--Users-lfaustino-Gestao-de-pagamentos-Gestao-de-Pagamentos\f5d417d4-4de6-4a18-861f-7750c82c7e41\scratchpad\preview-app\src\App.jsx" -Force
```

Expected in browser (Início tab): Purple gradient header, white summary card with big monthly value, donut chart (if cards exist), recent expenses list.

---

### Task 4: Add `CardsView` Component

**Files:**
- Modify: `c:\Users\lfaustino\Downloads\controle-parcelas.jsx`

**Interfaces:**
- Consumes: `cards`, `cardTotals`, `onAdd`, `onDelete`
- Produces: `CardsView` with visual card list and add/delete

- [ ] **Step 1: Add `CardsView` component after `HomeView`**

```jsx
function CardsView({ cards, cardTotals, onAdd, onDelete }) {
  return (
    <div>
      <div style={s.viewHeader}>
        <h1 style={s.viewTitle}>Meus Cartões</h1>
        <button type="button" style={s.headerGhostBtn} onClick={onAdd}>
          + Novo
        </button>
      </div>
      <div style={s.viewBody}>
        {cards.length === 0 ? (
          <Empty
            text="Nenhum cartão ainda. Cadastre o primeiro para começar."
            cta="Cadastrar cartão"
            onClick={onAdd}
          />
        ) : (
          <div style={{ display: "flex", flexDirection: "column", gap: 12 }}>
            {cards.map((card) => {
              const monthly = cardTotals[card.id] || 0;
              return (
                <div key={card.id} style={s.cardVisual}>
                  <div style={{ ...s.cardVisualStripe, background: card.color }} />
                  <div style={s.cardVisualBody}>
                    <div style={s.cardVisualTop}>
                      <div>
                        <div style={s.cardVisualName}>{card.name}</div>
                        {card.digits && (
                          <div style={s.cardVisualDigits}>•••• {card.digits}</div>
                        )}
                      </div>
                      <button
                        type="button"
                        style={s.cardDeleteBtn}
                        onClick={() => onDelete(card.id)}
                        title="Excluir cartão"
                      >
                        ×
                      </button>
                    </div>
                    <div style={s.cardVisualAmt}>
                      <span style={{ ...s.cardVisualMonthly, color: card.color }}>{brl(monthly)}</span>
                      <span style={s.cardVisualMonthlyLabel}>/mês</span>
                    </div>
                  </div>
                </div>
              );
            })}
          </div>
        )}
      </div>
    </div>
  );
}
```

- [ ] **Step 2: Add CardsView styles to the `s` object**

```js
  viewHeader: {
    display: "flex",
    alignItems: "center",
    justifyContent: "space-between",
    padding: "24px 20px 12px",
  },
  viewTitle: {
    fontFamily: FONTS.display,
    fontSize: 22,
    fontWeight: 700,
    margin: 0,
    color: C.ink,
    letterSpacing: "-0.01em",
  },
  viewBody: { padding: "8px 16px 0" },
  headerGhostBtn: {
    background: "transparent",
    color: C.primary,
    border: `1.5px solid ${C.primary}`,
    borderRadius: 20,
    padding: "7px 16px",
    fontSize: 13,
    fontWeight: 700,
    cursor: "pointer",
    fontFamily: FONTS.body,
  },
  cardVisual: {
    background: C.surface,
    borderRadius: 16,
    overflow: "hidden",
    display: "flex",
    boxShadow: "0 2px 12px rgba(124,58,237,0.07)",
  },
  cardVisualStripe: { width: 6, flex: "0 0 auto" },
  cardVisualBody: { flex: 1, padding: "16px 16px" },
  cardVisualTop: { display: "flex", justifyContent: "space-between", alignItems: "flex-start", marginBottom: 12 },
  cardVisualName: { fontFamily: FONTS.display, fontSize: 17, fontWeight: 700, color: C.ink },
  cardVisualDigits: { fontSize: 12, color: C.muted, fontWeight: 500, marginTop: 2 },
  cardDeleteBtn: {
    width: 28, height: 28, borderRadius: "50%",
    border: `1px solid ${C.line}`, background: C.surface,
    color: C.muted, cursor: "pointer", fontSize: 16, lineHeight: 1,
  },
  cardVisualAmt: { display: "flex", alignItems: "baseline", gap: 3 },
  cardVisualMonthly: { fontFamily: FONTS.display, fontSize: 22, fontWeight: 700 },
  cardVisualMonthlyLabel: { fontSize: 12, color: C.muted, fontWeight: 500 },
```

- [ ] **Step 3: Copy to preview and verify**

```powershell
Copy-Item "c:\Users\lfaustino\Downloads\controle-parcelas.jsx" "C:\Users\LFAUST~1\AppData\Local\Temp\claude\c--Users-lfaustino-Gestao-de-pagamentos-Gestao-de-Pagamentos\f5d417d4-4de6-4a18-861f-7750c82c7e41\scratchpad\preview-app\src\App.jsx" -Force
```

Expected in Cartões tab: List of visual cards with colored left stripe, name, digits, monthly value, and delete ×.

---

### Task 5: Add `ExpensesView` Component

**Files:**
- Modify: `c:\Users\lfaustino\Downloads\controle-parcelas.jsx`

**Interfaces:**
- Consumes: `expenses`, `cards`, `enrich`, `cardById`, `filterCard`, `setFilterCard`, `onEdit`, `onDelete`, `setPaid`
- Produces: `ExpensesView` with card filter chips, status toggle, and expense list

- [ ] **Step 1: Add `ExpensesView` component after `CardsView`**

```jsx
function ExpensesView({ expenses, cards, enrich, cardById, filterCard, setFilterCard, onEdit, onDelete, setPaid }) {
  const [statusFilter, setStatusFilter] = useState("active");

  const visible = useMemo(() => {
    let list = expenses.map(enrich);
    if (filterCard !== "all") list = list.filter((e) => e.cardId === filterCard);
    if (statusFilter === "active") list = list.filter((e) => !e.done);
    if (statusFilter === "done") list = list.filter((e) => e.done);
    return list.sort((a, b) => {
      if (a.done !== b.done) return a.done ? 1 : -1;
      return (b.date || "").localeCompare(a.date || "");
    });
  }, [expenses, filterCard, statusFilter, enrich]);

  return (
    <div>
      <div style={s.viewHeader}>
        <h1 style={s.viewTitle}>Compras</h1>
      </div>
      <div style={s.viewBody}>
        {/* card filter chips */}
        {cards.length > 0 && (
          <div style={s.filterChipsRow}>
            <button
              type="button"
              style={{ ...s.filterChip, ...(filterCard === "all" ? s.filterChipActive : {}) }}
              onClick={() => setFilterCard("all")}
            >
              Todos
            </button>
            {cards.map((c) => (
              <button
                type="button"
                key={c.id}
                style={{
                  ...s.filterChip,
                  ...(filterCard === c.id ? { background: c.color, color: "#fff", borderColor: c.color } : {}),
                }}
                onClick={() => setFilterCard(filterCard === c.id ? "all" : c.id)}
              >
                <span style={{ ...s.filterChipDot, background: filterCard === c.id ? "rgba(255,255,255,.7)" : c.color }} />
                {c.name}
              </button>
            ))}
          </div>
        )}

        {/* status toggle */}
        <div style={s.statusToggle}>
          {[["active","Ativos"],["all","Todos"],["done","Quitados"]].map(([v, l]) => (
            <button
              type="button"
              key={v}
              style={{ ...s.statusBtn, ...(statusFilter === v ? s.statusBtnOn : {}) }}
              onClick={() => setStatusFilter(v)}
            >
              {l}
            </button>
          ))}
        </div>

        {/* list */}
        {visible.length === 0 ? (
          <Empty
            text={expenses.length === 0 ? "Lance uma compra parcelada para começar." : "Nenhuma compra para este filtro."}
            cta={null}
            onClick={null}
          />
        ) : (
          <div style={s.list}>
            {visible.map((e) => (
              <ExpenseRow
                key={e.id}
                e={e}
                card={cardById[e.cardId]}
                onPay={() => setPaid(e.id, e.paidInstallments + 1)}
                onUnpay={() => setPaid(e.id, e.paidInstallments - 1)}
                onEdit={() => onEdit(e)}
                onDelete={() => onDelete(e.id)}
              />
            ))}
          </div>
        )}
      </div>
    </div>
  );
}
```

- [ ] **Step 2: Add ExpensesView styles to the `s` object**

```js
  filterChipsRow: {
    display: "flex",
    gap: 8,
    overflowX: "auto",
    paddingBottom: 4,
    marginBottom: 12,
  },
  filterChip: {
    flex: "0 0 auto",
    display: "flex",
    alignItems: "center",
    gap: 6,
    border: `1.5px solid ${C.line}`,
    borderRadius: 20,
    padding: "7px 14px",
    fontSize: 13,
    fontWeight: 600,
    background: C.surface,
    color: C.inkSoft,
    cursor: "pointer",
    fontFamily: FONTS.body,
    whiteSpace: "nowrap",
  },
  filterChipActive: { background: C.primary, color: "#fff", borderColor: C.primary },
  filterChipDot: { width: 8, height: 8, borderRadius: "50%", flex: "0 0 auto" },
  statusToggle: {
    display: "flex",
    background: C.surfaceAlt,
    borderRadius: 12,
    padding: 3,
    marginBottom: 14,
    gap: 2,
  },
  statusBtn: {
    flex: 1,
    border: "none",
    background: "transparent",
    borderRadius: 10,
    padding: "8px 6px",
    fontSize: 13,
    fontWeight: 600,
    color: C.muted,
    cursor: "pointer",
    fontFamily: FONTS.body,
  },
  statusBtnOn: { background: C.surface, color: C.ink, boxShadow: "0 1px 4px rgba(0,0,0,.08)" },
```

- [ ] **Step 3: Copy to preview and verify**

```powershell
Copy-Item "c:\Users\lfaustino\Downloads\controle-parcelas.jsx" "C:\Users\LFAUST~1\AppData\Local\Temp\claude\c--Users-lfaustino-Gestao-de-pagamentos-Gestao-de-Pagamentos\f5d417d4-4de6-4a18-861f-7750c82c7e41\scratchpad\preview-app\src\App.jsx" -Force
```

Expected in Compras tab: filter chips scrollable horizontally, Ativos/Todos/Quitados toggle, expense rows below.

---

### Task 6: Add `ReportView` Component (replaces `ReportModal`)

**Files:**
- Modify: `c:\Users\lfaustino\Downloads\controle-parcelas.jsx`

**Interfaces:**
- Consumes: `expenses`, `cards`, `cardById`, `enrich`
- Produces: `ReportView` full-page component with identical logic to the removed `ReportModal`

- [ ] **Step 1: Add `ReportView` after `ExpensesView`**

```jsx
function ReportView({ expenses, cards, cardById, enrich }) {
  const [selCards, setSelCards] = useState([]);
  const [selMonths, setSelMonths] = useState([]);
  const [selStatus, setSelStatus] = useState("all");

  const availableMonths = useMemo(() => {
    const set = new Set(expenses.map((e) => e.date?.slice(0, 7)).filter(Boolean));
    return Array.from(set).sort().reverse();
  }, [expenses]);

  const filtered = useMemo(() => {
    let list = expenses.map(enrich);
    if (selCards.length) list = list.filter((e) => selCards.includes(e.cardId));
    if (selMonths.length) list = list.filter((e) => selMonths.some((m) => e.date?.startsWith(m)));
    if (selStatus === "active") list = list.filter((e) => !e.done);
    if (selStatus === "done") list = list.filter((e) => e.done);
    return list.sort((a, b) => (b.date || "").localeCompare(a.date || ""));
  }, [expenses, selCards, selMonths, selStatus, enrich]);

  const summary = useMemo(() => ({
    total: filtered.reduce((s, e) => s + e.total, 0),
    monthly: filtered.filter((e) => !e.done).reduce((s, e) => s + e.monthly, 0),
    remaining: filtered.filter((e) => !e.done).reduce((s, e) => s + e.remaining, 0),
    activeCount: filtered.filter((e) => !e.done).length,
  }), [filtered]);

  const fmtMonth = (ym) => {
    const [y, m] = ym.split("-");
    return `${MONTHS_PT[+m - 1]}/${y.slice(2)}`;
  };

  const toggleCard = (id) =>
    setSelCards((p) => (p.includes(id) ? p.filter((c) => c !== id) : [...p, id]));
  const toggleMonth = (m) =>
    setSelMonths((p) => (p.includes(m) ? p.filter((x) => x !== m) : [...p, m]));

  return (
    <div>
      <div style={s.viewHeader}>
        <h1 style={s.viewTitle}>Relatório</h1>
        <button type="button" style={s.headerGhostBtn} onClick={() => window.print()}>
          ⬇ PDF
        </button>
      </div>
      <div style={s.viewBody}>

        {/* Filtro Cartão */}
        <div style={s.repSection}>
          <div style={s.repSectionLabel}>Cartão</div>
          <div style={s.filterChipsRow}>
            {cards.map((c) => {
              const on = selCards.includes(c.id);
              return (
                <button
                  type="button"
                  key={c.id}
                  style={{
                    ...s.filterChip,
                    ...(on ? { background: c.color, color: "#fff", borderColor: c.color } : {}),
                  }}
                  onClick={() => toggleCard(c.id)}
                >
                  <span style={{ ...s.filterChipDot, background: on ? "rgba(255,255,255,.7)" : c.color }} />
                  {c.name}
                </button>
              );
            })}
            {selCards.length > 0 && (
              <button type="button" style={s.repClear} onClick={() => setSelCards([])}>
                × limpar
              </button>
            )}
          </div>
        </div>

        {/* Filtro Mês */}
        {availableMonths.length > 0 && (
          <div style={s.repSection}>
            <div style={s.repSectionLabel}>Mês de compra</div>
            <div style={s.filterChipsRow}>
              {availableMonths.map((m) => {
                const on = selMonths.includes(m);
                return (
                  <button
                    type="button"
                    key={m}
                    style={{ ...s.filterChip, ...(on ? { background: C.primary, color: "#fff", borderColor: C.primary } : {}) }}
                    onClick={() => toggleMonth(m)}
                  >
                    {fmtMonth(m)}
                  </button>
                );
              })}
              {selMonths.length > 0 && (
                <button type="button" style={s.repClear} onClick={() => setSelMonths([])}>
                  × limpar
                </button>
              )}
            </div>
          </div>
        )}

        {/* Filtro Status */}
        <div style={{ ...s.statusToggle, marginBottom: 16 }}>
          {[["all","Todos"],["active","Ativos"],["done","Quitados"]].map(([v, l]) => (
            <button
              type="button"
              key={v}
              style={{ ...s.statusBtn, ...(selStatus === v ? s.statusBtnOn : {}) }}
              onClick={() => setSelStatus(v)}
            >
              {l}
            </button>
          ))}
        </div>

        {/* Resumo */}
        <div style={s.repSummary}>
          {[
            ["compras", filtered.length, C.ink, false],
            ["ativas", summary.activeCount, C.primary, false],
            ["total gasto", summary.total, C.ink, true],
            ["parc./mês", summary.monthly, C.primary, true],
            ["a pagar", summary.remaining, C.green, true],
          ].map(([lbl, val, color, isBrl], i, arr) => (
            <React.Fragment key={lbl}>
              <div style={s.repSumCell}>
                <span style={s.repSumLabel}>{lbl}</span>
                <span style={{ ...s.repSumVal, color }}>
                  {isBrl ? brl(val) : val}
                </span>
              </div>
              {i < arr.length - 1 && <div style={s.homeStatDiv} />}
            </React.Fragment>
          ))}
        </div>

        {/* Tabela */}
        {filtered.length === 0 ? (
          <p style={{ color: C.muted, textAlign: "center", padding: "16px 0", margin: 0, fontSize: 14 }}>
            Nenhuma compra para os filtros selecionados.
          </p>
        ) : (
          <div style={s.repTableWrap}>
            <table style={s.repTable}>
              <thead>
                <tr>
                  {["Fornecedor","Cartão","Data","Total","Parc./mês","Pagas","A pagar","Status"].map((h) => (
                    <th key={h} style={s.repTh}>{h}</th>
                  ))}
                </tr>
              </thead>
              <tbody>
                {filtered.map((e) => {
                  const card = cardById[e.cardId];
                  return (
                    <tr key={e.id} style={{ opacity: e.done ? 0.65 : 1 }}>
                      <td style={s.repTd}>{e.supplier}</td>
                      <td style={s.repTd}>
                        <span style={{ display: "flex", alignItems: "center", gap: 6 }}>
                          <span style={{ ...s.filterChipDot, background: card?.color || C.muted }} />
                          {card?.name || "—"}
                        </span>
                      </td>
                      <td style={{ ...s.repTd, ...s.repMono }}>{formatDate(e.date)}</td>
                      <td style={{ ...s.repTd, ...s.repMono, textAlign: "right" }}>{brl(e.total)}</td>
                      <td style={{ ...s.repTd, ...s.repMono, textAlign: "right" }}>{brl(e.monthly)}</td>
                      <td style={{ ...s.repTd, ...s.repMono, textAlign: "center" }}>
                        {e.paidInstallments}/{e.totalInstallments}
                      </td>
                      <td style={{ ...s.repTd, ...s.repMono, textAlign: "right", color: e.done ? C.muted : C.primary }}>
                        {e.done ? "—" : brl(e.remaining)}
                      </td>
                      <td style={s.repTd}>
                        <span style={{
                          ...s.doneTag,
                          color: e.done ? C.green : C.primary,
                          background: e.done ? "#D1FAE5" : "#EDE9FE",
                          border: `1px solid ${e.done ? "#A7F3D0" : "#C4B5FD"}`,
                        }}>
                          {e.done ? "quitado" : "ativo"}
                        </span>
                      </td>
                    </tr>
                  );
                })}
              </tbody>
            </table>
          </div>
        )}
      </div>
    </div>
  );
}
```

- [ ] **Step 2: Remove `ReportModal` function**

Delete the entire `ReportModal` function (lines 752–949 in the original file). It is fully replaced by `ReportView`.

- [ ] **Step 3: Add ReportView styles to the `s` object**

```js
  repSection: { marginBottom: 14 },
  repSectionLabel: { fontSize: 11, fontWeight: 700, color: C.muted, textTransform: "uppercase", letterSpacing: 1, marginBottom: 8 },
  repSummary: {
    display: "flex",
    flexWrap: "wrap",
    alignItems: "center",
    gap: 10,
    background: C.surface,
    borderRadius: 14,
    padding: "14px 16px",
    marginBottom: 14,
    boxShadow: "0 2px 8px rgba(124,58,237,0.06)",
  },
  repSumCell: { flex: 1, minWidth: 80, display: "flex", flexDirection: "column", gap: 3 },
  repSumLabel: { fontSize: 10, fontWeight: 600, color: C.muted, textTransform: "uppercase", letterSpacing: 0.8 },
  repSumVal: { fontSize: 15, fontWeight: 700, fontFamily: FONTS.display },
  repTableWrap: { overflowX: "auto", borderRadius: 12, border: `1px solid ${C.line}`, marginBottom: 16 },
  repTable: { width: "100%", borderCollapse: "collapse", fontSize: 13 },
  repTh: {
    fontFamily: FONTS.body, fontSize: 10, fontWeight: 700, letterSpacing: 1,
    textTransform: "uppercase", color: C.muted,
    padding: "10px 12px", background: C.surfaceAlt,
    borderBottom: `1px solid ${C.line}`, textAlign: "left", whiteSpace: "nowrap",
  },
  repTd: { padding: "10px 12px", borderBottom: `1px solid ${C.line}`, color: C.ink, verticalAlign: "middle" },
  repMono: { fontSize: 12 },
  repClear: {
    border: "none", background: "transparent",
    color: C.muted, fontSize: 12, cursor: "pointer",
    fontFamily: FONTS.body, padding: "4px 6px", flex: "0 0 auto",
  },
```

- [ ] **Step 4: Copy to preview and verify**

```powershell
Copy-Item "c:\Users\lfaustino\Downloads\controle-parcelas.jsx" "C:\Users\LFAUST~1\AppData\Local\Temp\claude\c--Users-lfaustino-Gestao-de-pagamentos-Gestao-de-Pagamentos\f5d417d4-4de6-4a18-861f-7750c82c7e41\scratchpad\preview-app\src\App.jsx" -Force
```

Expected in Relatório tab: filter chips for cards and months, status toggle, summary strip, scrollable table. Print button in header.

---

### Task 7: Update Remaining Styles — `ExpenseRow`, Modals, `primaryBtn`, `ghostBtn`, `css`

**Files:**
- Modify: `c:\Users\lfaustino\Downloads\controle-parcelas.jsx`

**Interfaces:**
- Produces: Purple-themed expense rows, modals, buttons, and global CSS

- [ ] **Step 1: Update `primaryBtn` style in `s`**

Find:
```js
  primaryBtn: {
    background: C.ink,
    color: "#fff",
    border: "none",
    borderRadius: 11,
    padding: "11px 18px",
    fontSize: 14,
    fontWeight: 600,
    cursor: "pointer",
    fontFamily: FONTS.body,
  },
```
Replace with:
```js
  primaryBtn: {
    background: C.primary,
    color: "#fff",
    border: "none",
    borderRadius: 11,
    padding: "11px 18px",
    fontSize: 14,
    fontWeight: 600,
    cursor: "pointer",
    fontFamily: FONTS.body,
  },
```

- [ ] **Step 2: Update `ghostBtn` style in `s`**

Find:
```js
  ghostBtn: {
    background: "transparent",
    color: C.inkSoft,
    border: `1px solid ${C.line}`,
    borderRadius: 11,
    padding: "10px 16px",
    fontSize: 13,
    fontWeight: 600,
    cursor: "pointer",
    fontFamily: FONTS.body,
  },
```
Replace with:
```js
  ghostBtn: {
    background: "transparent",
    color: C.primary,
    border: `1.5px solid ${C.primary}`,
    borderRadius: 11,
    padding: "10px 16px",
    fontSize: 13,
    fontWeight: 600,
    cursor: "pointer",
    fontFamily: FONTS.body,
  },
```

- [ ] **Step 3: Update `payBtn` style in `s`**

Find:
```js
  payBtn: {
    background: C.primary,
```
This already uses `C.primary` — no change needed. ✓

- [ ] **Step 4: Update `doneTag` style in `s`**

Find:
```js
  doneTag: {
    fontFamily: FONTS.mono,
    fontSize: 10,
    textTransform: "uppercase",
    letterSpacing: 1,
    background: C.surfaceAlt,
    color: C.primary,
    border: `1px solid ${C.line}`,
    borderRadius: 20,
    padding: "2px 8px",
  },
```
Replace with:
```js
  doneTag: {
    fontFamily: FONTS.body,
    fontSize: 10,
    fontWeight: 700,
    textTransform: "uppercase",
    letterSpacing: 0.8,
    background: "#EDE9FE",
    color: C.primary,
    border: `1px solid #C4B5FD`,
    borderRadius: 20,
    padding: "2px 8px",
  },
```

- [ ] **Step 5: Update `overlay` background tint in `s`**

Find:
```js
    background: "rgba(22,35,29,0.45)",
```
Replace with:
```js
    background: "rgba(26,18,51,0.5)",
```

- [ ] **Step 6: Update the `css` string (lines 973–993)**

Find:
```js
const css = `
  * { box-sizing: border-box; }
  .cp-root input, .cp-root select, .cp-root button { font-family: inherit; }
  input:focus, select:focus { border-color: ${C.primary} !important; }
  button { transition: transform .08s ease, opacity .15s ease, background .15s ease; }
  button:active:not(:disabled) { transform: translateY(1px); }
  @media (max-width: 640px) {
    .cp-header { flex-direction: column; align-items: flex-start; gap: 14px; }
    .cp-strip { grid-template-columns: 1fr !important; }
    .cp-row { flex-direction: column; }
    .cp-rowside { width: 100%; align-items: stretch !important; border-left: none !important; border-top: 1px solid ${C.line}; padding: 14px 0 0 0 !important; margin-top: 14px; }
  }
  @media (prefers-reduced-motion: reduce) { * { transition: none !important; } }
  @media print {
    body > *:not(.cp-root) { display: none !important; }
    .cp-root > *:not([data-print]) { display: none !important; }
    [data-print] { display: block !important; }
    [data-print] button { display: none !important; }
    [data-print-hide] { display: none !important; }
  }
`;
```
Replace with:
```js
const css = `
  * { box-sizing: border-box; }
  body { background: ${C.bg}; }
  .cp-root input, .cp-root select, .cp-root button { font-family: inherit; }
  input:focus, select:focus { border-color: ${C.primary} !important; outline: none; }
  button { transition: transform .08s ease, opacity .15s ease, background .15s ease; }
  button:active:not(:disabled) { transform: translateY(1px); }
  ::-webkit-scrollbar { height: 4px; width: 4px; }
  ::-webkit-scrollbar-track { background: transparent; }
  ::-webkit-scrollbar-thumb { background: ${C.line}; border-radius: 4px; }
  @media (max-width: 480px) {
    .cp-row { flex-direction: column; }
    .cp-rowside { width: 100%; align-items: stretch !important; border-left: none !important; border-top: 1px solid ${C.line}; padding: 14px 0 0 0 !important; margin-top: 14px; }
  }
  @media (prefers-reduced-motion: reduce) { * { transition: none !important; } }
  @media print {
    .cp-root nav { display: none !important; }
  }
`;
```

- [ ] **Step 7: Remove old unused styles from `s` that no longer exist in the layout**

Remove these keys from the `s` object (they referenced old layout elements):
- `header`, `kicker`, `title`, `headerNumbers`, `bigStat`, `bigStatLabel`, `bigStatValue`
- `strip`, `statCell`, `statLabel`, `statValue`
- `section`, `sectionHead`, `h2`
- `cardRow`, `chip`, `chipDot`, `chipName`, `chipSub`, `chipMoney`, `chipX`
- `footer`

> Note: `list`, `row`, `rowMain`, `rowTop`, `rowDot`, `supplier`, `doneTag`, `rowMeta`, `metaCard`, `metaSep`, `pips`, `pip`, `barWrap`, `barTrack`, `barFill`, `progressText`, `progressMuted`, `remainingChip`, `rowSide`, `rowTotal`, `totalLabel`, `totalValue`, `rowBtns`, `payBtn`, `iconBtn` are all still used by `ExpenseRow` — keep them.

- [ ] **Step 8: Copy to preview and verify full app**

```powershell
Copy-Item "c:\Users\lfaustino\Downloads\controle-parcelas.jsx" "C:\Users\LFAUST~1\AppData\Local\Temp\claude\c--Users-lfaustino-Gestao-de-pagamentos-Gestao-de-Pagamentos\f5d417d4-4de6-4a18-861f-7750c82c7e41\scratchpad\preview-app\src\App.jsx" -Force
```

Verify in browser:
- [ ] All 4 tabs work (Início, Cartões, Compras, Relatório)
- [ ] FAB opens new expense modal directly
- [ ] Adding a card shows it in Cartões
- [ ] Adding an expense shows it in Compras
- [ ] Home tab shows donut and recents after adding data
- [ ] Report tab filters work
- [ ] Modals open and close correctly
- [ ] No console errors

- [ ] **Step 9: Final commit (redesign only)**

```bash
git -C "c:/Users/lfaustino/Gestao de pagamentos/Gestao_de_Pagamentos" add -A
git -C "c:/Users/lfaustino/Gestao de pagamentos/Gestao_de_Pagamentos" commit -m "feat: complete mobile app redesign with purple theme, bottom nav, Poppins font"
```

---

### Task 8: Receipt Photo Scanning — "Escanear Nota"

**Files:**
- Modify: `c:\Users\lfaustino\Downloads\controle-parcelas.jsx`

**Interfaces:**
- Consumes: `ExpenseForm` component (adds scan button inside it); `store` (for saving API key under `"cp_anthropic_key"`); `App` state (no new state needed at App level)
- Produces: `ScanButton` component + `ApiKeyModal` component; `ExpenseForm` updated with scan trigger; form fields pre-filled after successful scan

**How it works:**
1. A "📷 Escanear nota" button appears at the top of `ExpenseForm`
2. Clicking it triggers a hidden `<input type="file" accept="image/*" capture="environment">`
3. User selects a photo from camera or gallery
4. Image is read as base64 via `FileReader` API
5. If no API key is stored (`cp_anthropic_key`), `ApiKeyModal` opens to collect it (saved to `window.storage`)
6. POST to `https://api.anthropic.com/v1/messages` with the image (claude-haiku-4-5-20251001 model, vision capability)
7. Claude extracts: `supplier` (store name), `total` (numeric BRL value), `date` (ISO format), `installments` (if visible on receipt, else 1)
8. Form fields `supplier`, `total`, `installments`, `date` are pre-filled; user reviews and selects the card, then saves normally

- [ ] **Step 1: Add `ApiKeyModal` component after `ReportView`**

```jsx
function ApiKeyModal({ onSave, onClose }) {
  const [key, setKey] = useState("");
  const submit = async () => {
    if (!key.trim()) return;
    await store.set("cp_anthropic_key", key.trim());
    onSave(key.trim());
  };
  return (
    <Modal title="Chave da API Anthropic" onClose={onClose}>
      <div style={s.formBody}>
        <p style={{ margin: 0, fontSize: 14, color: C.muted, lineHeight: 1.6 }}>
          Para escanear notas com IA, informe sua chave da API Anthropic. Ela fica salva localmente e nunca sai do seu dispositivo.
        </p>
        <Field label="API Key (sk-ant-...)">
          <input
            style={s.input}
            type="password"
            autoFocus
            value={key}
            placeholder="sk-ant-api03-..."
            onChange={(ev) => setKey(ev.target.value)}
            onKeyDown={(ev) => ev.key === "Enter" && submit()}
          />
        </Field>
      </div>
      <div style={s.formFoot}>
        <button type="button" style={s.ghostBtn} onClick={onClose}>cancelar</button>
        <button
          type="button"
          style={{ ...s.primaryBtn, opacity: key.trim() ? 1 : 0.5 }}
          disabled={!key.trim()}
          onClick={submit}
        >
          Salvar chave
        </button>
      </div>
    </Modal>
  );
}
```

- [ ] **Step 2: Add `ScanButton` component after `ApiKeyModal`**

```jsx
function ScanButton({ onExtracted }) {
  const [scanning, setScanning] = useState(false);
  const [showKeyModal, setShowKeyModal] = useState(false);
  const [pendingImage, setPendingImage] = useState(null);
  const inputRef = React.useRef(null);

  const handleFile = async (file) => {
    if (!file) return;
    const reader = new FileReader();
    reader.onload = async (ev) => {
      const base64 = ev.target.result.split(",")[1];
      const mimeType = file.type || "image/jpeg";
      const savedKey = await store.get("cp_anthropic_key", null);
      if (!savedKey) {
        setPendingImage({ base64, mimeType });
        setShowKeyModal(true);
        return;
      }
      await runScan(base64, mimeType, savedKey);
    };
    reader.readAsDataURL(file);
  };

  const runScan = async (base64, mimeType, apiKey) => {
    setScanning(true);
    try {
      const res = await fetch("https://api.anthropic.com/v1/messages", {
        method: "POST",
        headers: {
          "x-api-key": apiKey,
          "anthropic-version": "2023-06-01",
          "content-type": "application/json",
          "anthropic-dangerous-direct-browser-access": "true",
        },
        body: JSON.stringify({
          model: "claude-haiku-4-5-20251001",
          max_tokens: 256,
          messages: [{
            role: "user",
            content: [
              {
                type: "image",
                source: { type: "base64", media_type: mimeType, data: base64 },
              },
              {
                type: "text",
                text: "This is a receipt or invoice. Extract: store/supplier name, total amount in BRL (number only, e.g. 129.90), purchase date (YYYY-MM-DD), and number of installments if shown (default 1). Reply ONLY with valid JSON: {\"supplier\":\"...\",\"total\":0.00,\"date\":\"YYYY-MM-DD\",\"installments\":1}",
              },
            ],
          }],
        }),
      });
      if (!res.ok) throw new Error(`API error ${res.status}`);
      const data = await res.json();
      const text = data.content?.[0]?.text || "";
      const match = text.match(/\{[\s\S]*\}/);
      if (!match) throw new Error("No JSON in response");
      const extracted = JSON.parse(match[0]);
      onExtracted({
        supplier: extracted.supplier || "",
        total: String(extracted.total || ""),
        installments: String(extracted.installments || "1"),
        date: extracted.date || todayISO(),
      });
    } catch (err) {
      alert("Não foi possível ler a nota: " + err.message);
    } finally {
      setScanning(false);
      setPendingImage(null);
    }
  };

  const onKeyReady = async (apiKey) => {
    setShowKeyModal(false);
    if (pendingImage) {
      await runScan(pendingImage.base64, pendingImage.mimeType, apiKey);
    }
  };

  return (
    <>
      <input
        ref={inputRef}
        type="file"
        accept="image/*"
        capture="environment"
        style={{ display: "none" }}
        onChange={(ev) => handleFile(ev.target.files?.[0])}
      />
      <button
        type="button"
        style={s.scanBtn}
        disabled={scanning}
        onClick={() => inputRef.current?.click()}
      >
        {scanning ? "⏳ Lendo nota..." : "📷 Escanear nota"}
      </button>
      {showKeyModal && (
        <ApiKeyModal onSave={onKeyReady} onClose={() => setShowKeyModal(false)} />
      )}
    </>
  );
}
```

- [ ] **Step 3: Wire `ScanButton` into `ExpenseForm`**

Inside `ExpenseForm`, find the opening of `<div style={s.formBody}>` and add `ScanButton` as the first child, passing a callback that pre-fills the form state:

Find in `ExpenseForm`:
```jsx
      <div style={s.formBody}>
        <Field label="Fornecedor">
```
Replace with:
```jsx
      <div style={s.formBody}>
        <ScanButton
          onExtracted={(d) => {
            if (d.supplier) setSupplier(d.supplier);
            if (d.total) setTotal(d.total);
            if (d.installments) setInstallments(d.installments);
            if (d.date) setDate(d.date);
          }}
        />
        <Field label="Fornecedor">
```

- [ ] **Step 4: Add `scanBtn` style to the `s` object**

```js
  scanBtn: {
    display: "flex",
    alignItems: "center",
    justifyContent: "center",
    gap: 8,
    width: "100%",
    padding: "12px",
    background: C.surfaceAlt,
    border: `2px dashed ${C.line}`,
    borderRadius: 12,
    fontSize: 14,
    fontWeight: 600,
    color: C.primary,
    cursor: "pointer",
    fontFamily: FONTS.body,
  },
```

- [ ] **Step 5: Copy to preview and verify scanning feature**

```powershell
Copy-Item "c:\Users\lfaustino\Downloads\controle-parcelas.jsx" "C:\Users\LFAUST~1\AppData\Local\Temp\claude\c--Users-lfaustino-Gestao-de-pagamentos-Gestao-de-Pagamentos\f5d417d4-4de6-4a18-861f-7750c82c7e41\scratchpad\preview-app\src\App.jsx" -Force
```

Verify:
- [ ] "📷 Escanear nota" button appears at top of Nova Compra modal
- [ ] Clicking it opens file picker (camera on mobile)
- [ ] If no API key: `ApiKeyModal` appears asking for key
- [ ] After key saved: scan proceeds
- [ ] Form fields pre-fill with extracted data
- [ ] User can still edit all fields before saving
- [ ] No console errors

- [ ] **Step 6: Final commit**

```bash
git -C "c:/Users/lfaustino/Gestao de pagamentos/Gestao_de_Pagamentos" add -A
git -C "c:/Users/lfaustino/Gestao de pagamentos/Gestao_de_Pagamentos" commit -m "feat: add receipt photo scanning with AI extraction (Anthropic Vision)"
```
