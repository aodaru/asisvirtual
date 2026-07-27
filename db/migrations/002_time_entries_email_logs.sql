BEGIN;

CREATE TABLE asisvirtual.time_entries (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    task_id     UUID NOT NULL REFERENCES asisvirtual.tasks(id) ON DELETE CASCADE,
    start_time  TIMESTAMPTZ NOT NULL DEFAULT now(),
    end_time    TIMESTAMPTZ,
    duration    INTERVAL GENERATED ALWAYS AS (end_time - start_time) STORED,
    notes       TEXT,
    created_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_time_entries_task_id ON asisvirtual.time_entries (task_id);
CREATE INDEX idx_time_entries_start_time ON asisvirtual.time_entries (start_time);

CREATE TABLE asisvirtual.email_logs (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    message_id      TEXT NOT NULL UNIQUE,
    source          TEXT NOT NULL CHECK (source IN ('gmail', 'outlook')),
    processed_at    TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_email_logs_source ON asisvirtual.email_logs (source);

COMMIT;
