# Validation — Fase 1: Infraestructura

Cómo saber que la implementación tuvo éxito y la rama puede mergearse.

## Criterios verificables

### V1 — Artefactos en el repo

- [x] `.env.example` existe, documenta todas las variables del stack oficial
      de Supabase y **no contiene secretos reales**.
- [x] `.env` está listado en `.gitignore` y no aparece en `git status`.
- [x] `db/migrations/001_*.sql` y `db/migrations/002_*.sql` existen y son
      idempotentes (`IF NOT EXISTS` donde aplique).

### V2 — Supabase operativo (en `10.0.5.16`)

- [x] Studio UI responde en `http://10.0.5.16:30164` y permite login.
- [x] Los servicios del stack oficial están arriba
      (`docker compose ps` sin contenedores caídos/restarting).

### V3 — Schema correcto

Ejecutar contra el PostgreSQL de `10.0.5.16`:

- [x] `\dn` lista el schema `asisvirtual`.
- [x] `\dt asisvirtual.*` lista exactamente `tasks`, `time_entries`,
      `email_logs`.
- [x] Constraints verificados con pruebas negativas:
  - `INSERT` en `tasks` con `category='otro'` → **falla** (CHECK).
  - `INSERT` en `tasks` con `priority=7` → **falla** (CHECK 1–5).
  - Segundo `INSERT` en `email_logs` con el mismo `message_id` →
    **falla** (UNIQUE).
  - `INSERT` en `time_entries` con `task_id` inexistente → **falla** (FK).
- [x] `duration` en `time_entries` se calcula automáticamente al insertar
      `start_time`/`end_time`.

### V4 — Conectividad n8n

- [x] Desde el n8n de `n8n.adalgarcia.com`, el nodo Postgres con la
      credencial nueva ejecuta sin error:

      ```sql
      SET search_path TO asisvirtual;
      SELECT count(*) FROM tasks;
      ```

      y devuelve `0` (tabla vacía, accesible).

### V5 — Higiene del proceso

- [x] Entrada de cierre en `progress/history.md` con resultado `completado`.
- [x] Ningún archivo fuera del alcance fue modificado.
- [x] Roadmap Fase 1 (1.1–1.5) satisfecho: 1.1 y 1.2 vía despliegue del
      usuario + artefactos del repo; 1.3 y 1.4 vía migraciones; 1.5 vía
      credencial y workflow de prueba en el n8n existente.

## Criterio de merge

Todos los checks V1–V5 marcados → merge de
`feature/fase-1-infraestructura` a `master`. Si V3/V4 fallan, la rama no se
mergea y se documenta el bloqueo en `progress/history.md`.
