# Roadmap

## Fase 1 — Infraestructura
1.1 Docker Compose base (networks, volúmenes, variables de entorno)
1.2 Desplegar Supabase self-hosted y verificar Studio UI
1.3 Crear schema `asisvirtual` con tabla `tasks`
1.4 Crear tablas `time_entries` y `email_logs`
1.5 Desplegar n8n y verificar conexión PostgreSQL

## Fase 2 — Telegram Bot
2.1 Crear bot en BotFather, configurar token en n8n
2.2 Workflow `/add` → INSERT en tasks
2.3 Workflow `/tasks` → SELECT + formatear respuesta
2.4 Workflow `/done` → UPDATE status
2.5 Workflow `/sub` → crear sub-tarea con parent_id

## Fase 3 — Email Scanner
3.1 Credenciales OAuth2 Gmail (Google Cloud Console)
3.2 Credenciales OAuth2 Outlook (Azure AD)
3.3 Workflow schedule + Gmail node: fetch correos
3.4 Workflow schedule + Outlook node: fetch correos
3.5 Deduplicación vía email_logs
3.6 Pre-filtro por reglas (remitentes, palabras clave, @menciones)

## Fase 4 — Análisis con IA
4.1 Configurar API key del LLM en n8n
4.2 Integrar AI Agent node al pipeline
4.3 Prompt para extraer título, fecha, prioridad, categoría
4.4 Pipeline completo: correo → pre-filtro → LLM → tarea en DB

## Fase 5 — Time Tracking
5.1 `/start-timer` → INSERT en time_entries
5.2 `/stop-timer` → UPDATE end_time, calcular duración
5.3 `/time` → consulta agregada por tarea
5.4 Validaciones (evitar timers solapados)

## Fase 6 — Daily Report
6.1 Workflow schedule (08:00 AM)
6.2 Query: tareas pendientes, vencidas, próximas (3 días)
6.3 Formatear resumen
6.4 Enviar a Telegram via Bot

## Fase 7 — Notificaciones de Nuevas Tareas
7.1 Sub-workflow llamado desde Email Scanner
7.2 Enviar notificación a Telegram al crear tarea desde correo
