# Task 1 Brief: Replace Color & Font Constants

## Context
You are implementing Task 1 of 8 in a mobile app redesign of a React JSX component.
This is the first task — it replaces color and font constants to establish the new purple theme.
The production file is a single JSX file used in a Bubble.io-like platform.

## Your Job
Make exactly 3 find-and-replace changes in `c:\Users\lfaustino\Downloads\controle-parcelas.jsx`. Nothing else.

---

## Step 1: Replace the `C` constant

**Find** (exact match):
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

**Replace with** (exact):
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

---

## Step 2: Replace the `FONTS` constant

**Find** (exact match):
```js
const FONTS = {
  display: "'Space Grotesk', system-ui, sans-serif",
  body: "'Inter', system-ui, sans-serif",
  mono: "'Space Mono', 'SFMono-Regular', monospace",
};
```

**Replace with** (exact):
```js
const FONTS = {
  display: "'Poppins', system-ui, sans-serif",
  body: "'Poppins', system-ui, sans-serif",
  mono: "'Poppins', system-ui, sans-serif",
};
```

---

## Step 3: Replace the Google Fonts URL in the font-injection useEffect

**Find** (exact match):
```js
    link.href =
      "https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@400;500;600;700&family=Inter:wght@400;500;600&family=Space+Mono:wght@400;700&display=swap";
```

**Replace with** (exact):
```js
    link.href =
      "https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap";
```

---

## Step 4: Sync preview file

Run:
```powershell
Copy-Item "c:\Users\lfaustino\Downloads\controle-parcelas.jsx" "C:\Users\LFAUST~1\AppData\Local\Temp\claude\c--Users-lfaustino-Gestao-de-pagamentos-Gestao-de-Pagamentos\f5d417d4-4de6-4a18-861f-7750c82c7e41\scratchpad\preview-app\src\App.jsx" -Force
```

---

## Step 5: Commit

```bash
git -C "c:/Users/lfaustino/Gestao de pagamentos/Gestao_de_Pagamentos" add -A
git -C "c:/Users/lfaustino/Gestao de pagamentos/Gestao_de_Pagamentos" commit -m "refactor: replace colors and fonts with purple theme + Poppins"
```

---

## Report
Write your report to: `c:\Users\lfaustino\Gestao de pagamentos\Gestao_de_Pagamentos\.superpowers\sdd\task-1-report.md`

Report must include:
- Status: DONE | BLOCKED | NEEDS_CONTEXT
- Commit hash
- Confirmation that each of the 3 find-and-replace changes succeeded
- Any concerns
