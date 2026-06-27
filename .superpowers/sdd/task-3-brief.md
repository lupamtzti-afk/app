# Task 3 Brief: Add HomeView Component

## Context
Tasks 1–2 are complete. The file now has purple theme, Poppins font, bottom navigation, and 4 view stub functions.
Task 3 replaces the `HomeView` stub with the full implementation + adds a `DonutChart` SVG component + adds HomeView styles to `s`.

File to edit: `c:\Users\lfaustino\Downloads\controle-parcelas.jsx`

---

## Change 1: Replace the `HomeView` stub with the full implementation

Find this stub (exact):
```jsx
function HomeView({ cards, expenses, enrich, totals, cardTotals, cardById }) {
  return <div style={{ padding: "24px 20px", color: C.muted }}>Início — em breve</div>;
}
```

Replace with the full `DonutChart` component followed by the full `HomeView` component:

```jsx
function DonutChart({ segments, centerLabel }) {
  const r = 54;
  const cx = 80;
  const cy = 80;
  const strokeW = 20;
  const circumference = 2 * Math.PI * r;
  const total = segments.reduce((sum, x) => sum + x.value, 0);

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

---

## Change 2: Add HomeView styles to the `s` object

Find the last line of the `s` object's bottom nav block:
```js
    justifyContent: "center",
  },
};
```

Replace with:
```js
    justifyContent: "center",
  },

  /* home view */
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
};
```

---

## After changes: sync and commit

```powershell
Copy-Item "c:\Users\lfaustino\Downloads\controle-parcelas.jsx" "C:\Users\LFAUST~1\AppData\Local\Temp\claude\c--Users-lfaustino-Gestao-de-pagamentos-Gestao-de-Pagamentos\f5d417d4-4de6-4a18-861f-7750c82c7e41\scratchpad\preview-app\src\App.jsx" -Force
```

```bash
git -C "c:/Users/lfaustino/Gestao de pagamentos/Gestao_de_Pagamentos" add -A
git -C "c:/Users/lfaustino/Gestao de pagamentos/Gestao_de_Pagamentos" commit -m "feat: add HomeView with donut chart, summary card, recents"
```

---

## Report
Write to: `c:\Users\lfaustino\Gestao de pagamentos\Gestao_de_Pagamentos\.superpowers\sdd\task-3-report.md`

Include: Status, commit hash, confirmation both changes applied, any concerns.
