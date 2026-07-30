BEGIN;

-- Otorgar permisos al usuario postgres en el schema asisvirtual
-- Owner sigue siendo supabase_admin

GRANT CREATE ON SCHEMA asisvirtual TO postgres;
GRANT INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA asisvirtual TO postgres;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA asisvirtual TO postgres;
ALTER DEFAULT PRIVILEGES IN SCHEMA asisvirtual
  GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES IN SCHEMA asisvirtual
  GRANT USAGE, SELECT ON SEQUENCES TO postgres;

COMMIT;
