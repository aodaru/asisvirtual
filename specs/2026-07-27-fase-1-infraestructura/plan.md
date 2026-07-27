# Plan — Fase 1: Infraestructura

> Roadmap 1.1–1.5 adaptado a las decisiones del usuario: n8n ya existe
> (`teapartyn8n.duckdns.org`); Supabase lo despliega el usuario en
> `10.0.5.16` con el stack oficial.

## 1. Artefactos de configuración

- [x] 1.1 Crear `.env.example` con las variables del stack oficial de
      Supabase (POSTGRES_PASSWORD, JWT_SECRET, ANON_KEY, SERVICE_ROLE_KEY,
      puertos de Studio/API, etc.) con valores placeholder.
- [x] 1.2 Asegurar que `.env` está en `.gitignore`.
- [x] 1.3 Documentar en el `.env.example` los requisitos de red: PostgreSQL
      (5432) accesible desde el host de n8n; Studio en `http://10.0.5.16:3000`.

## 2. Migraciones de base de datos

- [x] 2.1 `db/migrations/001_schema_asisvirtual_tasks.sql`:
      `CREATE SCHEMA IF NOT EXISTS asisvirtual;` + tabla `tasks` con todas
      las columnas, CHECKs (`category`, `status`, `source`, `priority`
      1–5), FK `parent_id → tasks.id` y defaults (`created_at`,
      `updated_at`) según el diseño del proyecto.
- [x] 2.2 `db/migrations/002_time_entries_email_logs.sql`: tabla
      `time_entries` (FK `task_id`, `duration` generada como
      `end_time - start_time`) y tabla `email_logs` con
      `UNIQUE(message_id)`.

## 3. Despliegue de Supabase (ejecuta el usuario)

- [ ] 3.1 El usuario despliega el stack oficial de Supabase self-hosted en
      `10.0.5.16` usando `.env.example` como referencia.
- [ ] 3.2 Verificar que Studio UI responde en `http://10.0.5.16:3000`.
- [ ] 3.3 ⏸️ **Punto de espera**: el usuario avisa cuando el despliegue esté
      listo para conexión.

## 4. Aplicación del schema

- [ ] 4.1 Ejecutar migraciones 001 y 002 contra el PostgreSQL de
      `10.0.5.16` (`psql` o desde Studio SQL Editor).
- [ ] 4.2 Verificar en Studio que existen `asisvirtual.tasks`,
      `asisvirtual.time_entries` y `asisvirtual.email_logs` con sus
      constraints.

## 5. Conexión n8n → PostgreSQL

- [ ] 5.1 Crear credencial PostgreSQL en el n8n existente: host `10.0.5.16`,
      puerto `5432`, database y rol configurados en el despliegue.
- [ ] 5.2 Workflow de prueba en n8n:
      `SET search_path TO asisvirtual; SELECT count(*) FROM tasks;`
      debe ejecutar sin error.

## 6. Cierre

- [ ] 6.1 Registrar la entrada en `progress/history.md` (formato estándar).
- [ ] 6.2 Checklist de `validation.md` completo → merge de
      `feature/fase-1-infraestructura` a `master`.
