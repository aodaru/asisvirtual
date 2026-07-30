# Plan — Fase 1: Infraestructura

> Roadmap 1.1–1.5 adaptado a las decisiones del usuario: n8n ya existe
> (`n8n.adalgarcia.com`); Supabase lo despliega el usuario en
> `10.0.5.16` con el stack oficial.

## 1. Artefactos de configuración

- [x] 1.1 Crear `.env.example` con las variables del stack oficial de
      Supabase (POSTGRES_PASSWORD, JWT_SECRET, ANON_KEY, SERVICE_ROLE_KEY,
      puertos de Studio/API, etc.) con valores placeholder.
- [x] 1.2 Asegurar que `.env` está en `.gitignore`.
- [x] 1.3 Documentar en el `.env.example` los requisitos de red: PostgreSQL
      (5432) accesible desde el host de n8n; Studio en `http://10.0.5.16:30164`.

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

- [x] 3.1 El usuario despliega el stack oficial de Supabase self-hosted en
      `10.0.5.16` usando `.env.example` como referencia.
- [x] 3.2 Verificar que Studio UI responde en `http://10.0.5.16:30164`.
- [x] 3.3 El usuario avisó; despliegue healthy, migraciones aplicadas.

## 4. Aplicación del schema

- [x] 4.1 Ejecutar migraciones 001 y 002 contra el PostgreSQL de
      `10.0.5.16` (`psql` o desde Studio SQL Editor).
- [x] 4.2 Verificar en Studio que existen `asisvirtual.tasks`,
      `asisvirtual.time_entries` y `asisvirtual.email_logs` con sus
      constraints.

## 5. Conexión n8n → PostgreSQL

- [x] 5.1 Crear credencial PostgreSQL en el n8n existente: host `10.0.5.16`,
      puerto `5432`, database y rol configurados en el despliegue.
- [x] 5.2 Workflow de prueba en n8n:
      `SET search_path TO asisvirtual; SELECT count(*) FROM tasks;`
      debe ejecutar sin error.

## 6. Cierre

- [ ] 6.1 Registrar la entrada en `progress/history.md` (formato estándar).
- [ ] 6.2 Checklist de `validation.md` completo → merge de
      `feature/fase-1-infraestructura` a `master`.

## 7. Fix PostgREST API y permisos (2026-07-30)

- [x] 7.1 **Migración 003** (`003_fix_schema_permissions.sql`): otorgar
      permisos CREATE, INSERT, UPDATE, DELETE al usuario `postgres` en el
      schema `asisvirtual` (owner sigue siendo `supabase_admin`).
- [x] 7.2 **Permisos PostgREST**: GRANTs a `anon` (USAGE, SELECT),
      `service_role` (ALL), `authenticator` (USAGE, SELECT) en schema
      `asisvirtual`. Default privileges para futuras tablas/secuencias.
- [x] 7.3 **JWT keys**: regenerar ANON_KEY y SERVICE_ROLE_KEY firmadas con
      el JWT_SECRET real del servidor (no el placeholder de demo). Script
      de regeneración: `python3 -c "..."` con HMAC-SHA256.
- [x] 7.4 **PostgREST schema**: cambiar `PGRST_DB_SCHEMAS` de
      `public,asisvirtual` a `asisvirtual,public` para que PostgREST busque
      en `asisvirtual` por defecto. Actualizar `PGRST_DB_EXTRA_SEARCH_PATH`
      a `asisvirtual,public`.
- [x] 7.5 **Kong**: recrear contenedor con `docker compose up -d
      --force-recreate kong` para aplicar nuevas keys JWT. Modificar
      `volumes/api/kong.yml` línea 173: agregar `Content-Profile:
      asisvirtual` al request-transformer de la ruta `rest-v1` (prevención
      futura para multi-schema). **Nota**: este cambio persiste en el host
      pero se perdería si se sobreescribe `kong.yml` desde un template
      oficial de Supabase.
