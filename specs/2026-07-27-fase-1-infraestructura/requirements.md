# Requirements — Fase 1: Infraestructura

> Roadmap: Fase 1 (1.1–1.5) · Rama: `feature/fase-1-infraestructura`

## Contexto

- La misión del proyecto (ver `specs/mission.md`) exige infraestructura
  **100% self-hosted**: Supabase + PostgreSQL 15+ como base de datos y n8n
  como orquestador.
- **Decisión del usuario (2026-07-27):**
  - n8n **ya está desplegado** y opera en `https://n8n.adalgarcia.com/`.
    No se despliega n8n desde este repo.
  - Supabase se desplegará en el host **`10.0.5.16`** con el **stack oficial
    completo** de Supabase self-hosted. **El usuario ejecuta el despliegue**
    y avisará cuando esté listo para conexión.
- Este repo aporta los artefactos canónicos: variables de entorno de
  referencia, migraciones SQL del schema `asisvirtual` y verificación de
  conectividad n8n → PostgreSQL.

## Alcance

### In scope

1. `.env.example` documentando las variables del stack oficial de Supabase
   (referencia para el despliegue en `10.0.5.16`). El `.env` real nunca se
   commitea.
2. Migración SQL `001`: schema `asisvirtual` + tabla `tasks` (columnas y
   constraints según `asisvirtual_PROYECTO.md` §5).
3. Migración SQL `002`: tablas `time_entries` y `email_logs`.
4. Soporte del despliegue de Supabase (stack oficial) en `10.0.5.16`
   realizado por el usuario; verificación de Studio UI.
5. Aplicación de las migraciones contra el PostgreSQL de `10.0.5.16` y
   verificación en Studio.
6. Credencial PostgreSQL en el n8n existente apuntando a `10.0.5.16` y
   workflow de prueba (`SET search_path TO asisvirtual; SELECT ...`).
7. Migración SQL `003`: permisos del schema `asisvirtual` para el usuario
   `postgres` (migración de corrección post-despliegue).
8. Permisos de PostgREST: GRANTs a `anon`, `service_role` y `authenticator`
   en schema `asisvirtual` para que la API REST funcione.
9. JWT keys (ANON_KEY, SERVICE_ROLE_KEY) firmadas con el JWT_SECRET real
   del servidor (no el placeholder de demo).
10. PostgREST schema: `PGRST_DB_SCHEMAS=asisvirtual,public` (asisvirtual
    primero = schema por defecto).
11. Kong: `Content-Profile: asisvirtual` en `volumes/api/kong.yml` para
    soporte multi-schema.

### Out of scope

- Desplegar n8n (ya existe en `n8n.adalgarcia.com`).
- Ejecutar el despliegue de Supabase (lo realiza el usuario).
- Workflows de negocio de n8n (Fases 2+), bot de Telegram, escaneo de
  correo, LLM, time tracking, reportes.
- Configuración de Auth/Realtime de Supabase más allá de los defaults del
  stack oficial.

## Decisiones

| # | Decisión | Motivo |
|---|----------|--------|
| D1 | Stack oficial completo de Supabase self-hosted | Fidelidad total a "Supabase self-hosted"; incluye Studio, PostgREST, GoTrue, Realtime para uso futuro |
| D2 | n8n externo ya desplegado | Evita duplicar infraestructura; la Fase 1 solo verifica conectividad |
| D3 | Secretos en `.env` (git-ignored); `.env.example` commiteado | Privacidad first; ningún secreto en el repo |
| D4 | Schema `asisvirtual` separado en PostgreSQL | Principio multi-proyecto de la misión (extensibilidad) |
| D5 | Migraciones SQL versionadas en el repo (`db/migrations/`) | Reproducibilidad; el despliegue lo hace el usuario pero el schema es canónico |
| D6 | PostgreSQL accesible desde la red del n8n existente (puerto 5432 en `10.0.5.16`) | Requisito de conectividad para todas las fases siguientes |
| D7 | `PGRST_DB_SCHEMAS=asisvirtual,public` (asisvirtual primero) | PostgREST busca en `asisvirtual` por defecto; evita error PGRST205 |
| D8 | JWT keys regeneradas con secret real del servidor | Las keys de demo no funcionan con el JWT_SECRET del despliegue real |
| D9 | `Content-Profile: asisvirtual` en Kong request-transformer | Prevención para soporte multi-schema (bug conocido: no funciona para GET) |
| D10 | Permisos explícitos para `anon`, `service_role`, `authenticator` | PostgREST necesita estos GRANTs para acceder al schema `asisvirtual` |

## Referencias

- `specs/mission.md` — principios (automatización, self-hosted, privacidad)
- `specs/tech-stack.md` — versiones congeladas (Docker 24+, PostgreSQL 15+)
- `asisvirtual_PROYECTO.md` §5 — definición exacta de columnas de `tasks`,
  `time_entries`, `email_logs`
- `asisvirtual_PROYECTO.md` §11 — parámetros de conexión n8n → PostgreSQL
