-- Gestão de Pagamentos — Supabase Schema
-- Execute este script no SQL Editor do seu projeto Supabase

-- ----------------------------------------------------------------
-- Tabela: cartões de crédito
-- ----------------------------------------------------------------
CREATE TABLE IF NOT EXISTS cards (
  id          UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id     UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  name        TEXT NOT NULL,
  color       TEXT NOT NULL DEFAULT '#7C3AED',
  digits      TEXT,
  created_at  TIMESTAMPTZ DEFAULT NOW()
);

-- ----------------------------------------------------------------
-- Tabela: compras parceladas (cartão de crédito)
-- ----------------------------------------------------------------
CREATE TABLE IF NOT EXISTS expenses (
  id                  UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id             UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  supplier            TEXT NOT NULL,
  card_id             UUID REFERENCES cards(id) ON DELETE SET NULL,
  total               NUMERIC(12,2) NOT NULL DEFAULT 0,
  total_installments  INTEGER NOT NULL DEFAULT 1,
  paid_installments   INTEGER NOT NULL DEFAULT 0,
  date                DATE NOT NULL,
  created_at          TIMESTAMPTZ DEFAULT NOW()
);

-- ----------------------------------------------------------------
-- Tabela: finanças (empréstimos, despesas de casa e carro)
-- ----------------------------------------------------------------
CREATE TABLE IF NOT EXISTS financas (
  id                  UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id             UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  category            TEXT NOT NULL CHECK (category IN ('emprestimos', 'casa', 'carro')),
  supplier            TEXT NOT NULL,
  total               NUMERIC(12,2) NOT NULL DEFAULT 0,
  total_installments  INTEGER NOT NULL DEFAULT 1,
  paid_installments   INTEGER NOT NULL DEFAULT 0,
  date                DATE NOT NULL,
  created_at          TIMESTAMPTZ DEFAULT NOW()
);

-- ----------------------------------------------------------------
-- Row Level Security — cada usuário vê apenas os próprios dados
-- ----------------------------------------------------------------
ALTER TABLE cards    ENABLE ROW LEVEL SECURITY;
ALTER TABLE expenses ENABLE ROW LEVEL SECURITY;
ALTER TABLE financas ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Usuário gerencia próprios cartões" ON cards;
CREATE POLICY "Usuário gerencia próprios cartões"
  ON cards FOR ALL
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "Usuário gerencia próprias compras" ON expenses;
CREATE POLICY "Usuário gerencia próprias compras"
  ON expenses FOR ALL
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "Usuário gerencia próprias finanças" ON financas;
CREATE POLICY "Usuário gerencia próprias finanças"
  ON financas FOR ALL
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

-- ----------------------------------------------------------------
-- Índices para performance
-- ----------------------------------------------------------------
CREATE INDEX IF NOT EXISTS idx_cards_user    ON cards(user_id);
CREATE INDEX IF NOT EXISTS idx_expenses_user ON expenses(user_id);
CREATE INDEX IF NOT EXISTS idx_financas_user ON financas(user_id, category);
