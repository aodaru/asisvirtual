# Feature: Telegram Bot

## Goal

Implementar un bot de Telegram como interfaz principal del usuario para gestionar tareas. El bot escucha comandos vía Telegram Trigger en n8n y ejecuta operaciones CRUD sobre la tabla `asisvirtual.tasks` en Supabase, permitiendo al usuario crear, listar, completar y anidar tareas directamente desde el chat.

## Scope

### In scope
- Crear bot en BotFather y configurar token en n8n
- Workflow `/add` → INSERT en `asisvirtual.tasks` (source='telegram')
- Workflow `/tasks` → SELECT con filtros por categoría (work/personal) + formatear respuesta
- Workflow `/done` → UPDATE status a 'done'
- Workflow `/sub` → INSERT con `parent_id` referenciando tarea existente
- Comando `/start` con mensaje de bienvenida e instrucciones
- Comando `/next` → tarea con fecha de vencimiento más próxima
- Mensajes de error claros (tarea no encontrada, formato inválido, etc.)

### Out of scope
- `/start-timer`, `/stop-timer`, `/time` (Fase 5 — Time Tracking)
- `/summary` y Daily Report automático (Fase 6)
- Notificaciones proactivas de nuevas tareas desde email (Fase 7)
- Autenticación de usuario (single-user por ahora)
- UI web o app móvil

## Context

### Decisions
- Un único workflow en n8n con routing por comando (Switch node) en lugar de un workflow por comando, para simplificar mantenimiento
- Conexión a Supabase vía **nodo Supabase nativo** (`n8n-nodes-base.supabase`) que usa PostgREST internamente, no PostgreSQL directo
- Credencial `supabaseApi` en n8n: Host `http://10.0.5.16:30164` + `SERVICE_ROLE_KEY` (bypasses RLS)
- Schema custom: `useCustomSchema: true, schema: "asisvirtual"` en cada nodo Supabase
- Formato de respuesta en Markdown para mejor legibilidad en Telegram
- IDs de tarea mostrados al usuario en formato corto (primeros 8 chars del UUID)
- Para búsquedas por ID corto (`/done`, `/sub`): usar `filterString` con sintaxis PostgREST raw (`id.like.{shortId}*`) — Opción A

### Constraints
- El bot es single-user (un solo chat_id autorizado) por seguridad inicial
- n8n debe estar accesible desde internet (webhook) para recibir updates de Telegram
- La tabla `tasks` ya existe con schema definido en migración 001

## References
- specs/mission.md — automatización sobre esfuerzo manual
- specs/tech-stack.md — Telegram Bot API, n8n, PostgreSQL
- db/migrations/001_schema_asisvirtual_tasks.sql — estructura de tasks
- asisvirtual_PROYECTO.md §7 — comandos y flujo detallado del bot
