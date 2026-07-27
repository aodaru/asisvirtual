BEGIN;

CREATE SCHEMA IF NOT EXISTS asisvirtual;

CREATE TABLE asisvirtual.tasks (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    parent_id       UUID REFERENCES asisvirtual.tasks(id) ON DELETE SET NULL,
    title           TEXT NOT NULL,
    description     TEXT,
    category        TEXT NOT NULL CHECK (category IN ('work', 'personal')),
    status          TEXT NOT NULL DEFAULT 'pending'
                        CHECK (status IN ('pending', 'in_progress', 'done', 'cancelled')),
    priority        INTEGER NOT NULL DEFAULT 3 CHECK (priority BETWEEN 1 AND 5),
    due_date        DATE,
    estimated_hours NUMERIC(5,1),
    source          TEXT NOT NULL CHECK (source IN ('email', 'manual', 'telegram')),
    source_email_id TEXT,
    email_account   TEXT,
    metadata        JSONB DEFAULT '{}'::jsonb,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_tasks_status ON asisvirtual.tasks (status);
CREATE INDEX idx_tasks_category ON asisvirtual.tasks (category);
CREATE INDEX idx_tasks_due_date ON asisvirtual.tasks (due_date);
CREATE INDEX idx_tasks_parent_id ON asisvirtual.tasks (parent_id);
CREATE INDEX idx_tasks_priority ON asisvirtual.tasks (priority);

CREATE OR REPLACE FUNCTION asisvirtual.set_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_tasks_updated_at
    BEFORE UPDATE ON asisvirtual.tasks
    FOR EACH ROW
    EXECUTE FUNCTION asisvirtual.set_updated_at();

COMMIT;
