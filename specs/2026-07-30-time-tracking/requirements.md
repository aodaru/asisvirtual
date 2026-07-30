# Feature: Time Tracking

## Goal

Permitir al usuario registrar tiempo invertido en tareas mediante comandos de Telegram, almacenando los datos en la tabla `time_entries` de Supabase. Esto permite medir productividad y generar reportes de tiempo dedicado por tarea.

## Scope

### In scope
- Comando `/start-timer <task_id>` — inicia un timer para una tarea existente
- Comando `/stop-timer` — detiene el timer activo y calcula la duración
- Comando `/time <task_id>` — muestra tiempo total acumulado por tarea
- Validación para evitar timers solapados (solo un timer activo a la vez)
- Inserción y actualización en tabla `time_entries`

### Out of scope
- Reportes de tiempo por rango de fechas (Fase 6 — Daily Report)
- Timer automático basado en detección de actividad
- Exportación de datos de tiempo a CSV/PDF
- Múltiples timers simultáneos

## Context

### Decisions
- Un solo timer activo por usuario a la vez
- La tabla `time_entries` ya existe desde Fase 1 (Fase 1.4)
- Se reutiliza la conexión PostgreSQL existente en n8n

### Constraints
- Solo usuarios autenticados vía Telegram
- El task_id debe corresponder a una tarea existente en la tabla `tasks`
- El timer activo se almacena en la tabla para persistencia

## References
- specs/mission.md — objetivo de automatización y seguimiento
- specs/tech-stack.md — Stack: Supabase + n8n + Telegram Bot API
- specs/roadmap.md — Fase 5, items 5.1–5.4
