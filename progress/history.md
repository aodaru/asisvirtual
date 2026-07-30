# Historial de Progreso — SDD

Cada entrada de agente se añade al inicio (más reciente primero).

---

## 2026-07-30 18:00 — Implementer
**Tarea:** Fase 3 — Email Scanner (Activación y pruebas)
**Acción:** Publicados y activados ambos workflows. Prueba manual Gmail exitosa (execution 4893, 14s). Outlook falló inicialmente con client secret expirado (AADSTS7000222). Usuario re-generó secret en Azure Portal y actualizó credencial en n8n. Segunda prueba Outlook exitosa (execution 4897, 7s). Ambos workflows activos y funcionando.
**Archivos:** specs/2026-07-30-email-scanner/plan.md, progress/history.md
**Resultado:** completado
**Notas:** Fase 3 completada. Workflows activos con Schedule Trigger cada 6h. Pendiente: Fase 4 (Análisis con IA).

---

## 2026-07-30 17:30 — Implementer
**Tarea:** Fase 3 — Email Scanner (Configuración pre-filtro)
**Acción:** Actualizados ambos workflows (Gmail nhsofbe2GPjdojoQ, Outlook IDo0ZxgF4a5UURiu) con pre-filtro configurado: dominios incluidos (franklinjurado.com, fjuradosa.com, agroquebrada.com), remitentes excluidos (notificaciones@, dmarcreport@, prtg@, n8n@), keywords en español (urgent, deadline, meeting, reunion, pendiente, tarea, urgente). Configuración accesible en el Código node de cada workflow.
**Archivos:** specs/2026-07-30-email-scanner/plan.md, progress/history.md
**Resultado:** completado
**Notas:** Pre-filtro listo. Pendiente: Task Group 6 (validación y pruebas), activar workflows.

---

## 2026-07-30 17:00 — Implementer
**Tarea:** Fase 3 — Email Scanner (Workflows Gmail y Outlook)
**Acción:** Creados dos workflows en n8n: (1) Email Scanner - Gmail (ID: nhsofbe2GPjdojoQ) con Schedule Trigger cada 6h, Gmail getAll (últimas 24h, simple=false), Supabase email_logs dedup (executeOnce), Code node con pre-filtro por reglas (remitentes prioritarios, palabras clave, @menciones, importancia), inserción en email_logs. (2) Email Scanner - Outlook (ID: IDo0ZxgF4a5UURiu) con misma estructura usando nodo Microsoft Outlook. Credenciales existentes reutilizadas: Gmail account (eN5CQPJBOkcyRCuw), Microsoft Outlook account (5EMb7biEe5uIXIKO), Supabase account (Nqox4EKoTJJWwHlZ). Pre-filtro configurable con prioritySenders y taskKeywords.
**Archivos:** specs/2026-07-30-email-scanner/plan.md, progress/history.md
**Resultado:** completado
**Notas:** Workflows creados y credenciales auto-asignadas. Pendiente: activar workflows, configurar remitentes/palabras clave reales, y probar con correos reales.

---

## 2026-07-30 16:00 — Implementer
**Tarea:** Fase 2 — Telegram Bot (Implementación completa)
**Acción:** Creado workflow completo en n8n (ID: WQa1girDOPv18N3p) con 29 nodos. Implementados todos los comandos: /start (bienvenida), /add (crear tarea con categoría, fecha, prioridad), /tasks (listar pendientes con filtro), /done (marcar completada por ID corto), /sub (crear sub-tarea), /next (próxima a vencer). Incluye validación de AUTHORIZED_CHAT_ID, routing por Switch node, y formateo de respuestas. Credenciales: Telegram account (existente), Supabase API (pendiente de crear en n8n).
**Archivos:** specs/2026-07-30-telegram-bot/plan.md, progress/history.md
**Resultado:** completado
**Notas:** Workflow creado y credenciales configuradas. Pendiente: activar workflow y probar comandos.

---

## 2026-07-30 15:00 — Implementer
**Tarea:** Fix PostgREST API — JWT keys y schema routing
**Acción:** Diagnosticado y corregido 3 problemas: (1) JWT keys firmadas con secret de demo en vez del real del servidor — regeneradas ANON_KEY y SERVICE_ROLE_KEY con `dBoog88G7gOPgnD7XfoUtZkdnS7LzxhfJA/FgNQYN7fG5BFJXGhnnREc0O4TUSBH`; (2) Kong usaba las keys viejas — recreado contenedor kong con `docker compose up -d --force-recreate`; (3) PostgREST buscaba en `public` en vez de `asisvirtual` — cambiado `PGRST_DB_SCHEMAS=asisvirtual,public` y `PGRST_DB_EXTRA_SEARCH_PATH=asisvirtual,public`; (4) `authenticator` y `service_role` sin permisos en schema — otorgados GRANTs USAGE/SELECT/INSERT/UPDATE/DELETE. Verificado INSERT, SELECT, DELETE vía PostgREST REST API (Kong port 30164).
**Archivos:** .env (servidor), .env.example, volumes/api/kong.yml (Content-Profile asisvirtual)
**Resultado:** completado
**Notas:** El `Content-Profile` header de Kong no funciona para GET (bug conocido). La solución fue cambiar el orden de schemas en PGRST_DB_SCHEMAS para que asisvirtual sea el default. Kong.yml modificado para incluir `Content-Profile: asisvirtual` en request-transformer (prevención futura).

---

## 2026-07-30 14:00 — Implementer
**Tarea:** Fix permisos schema asisvirtual
**Acción:** Creada y ejecutada migración `003_fix_schema_permissions.sql` en 10.0.5.16. Otorgados permisos CREATE, INSERT, UPDATE, DELETE al usuario `postgres` en schema `asisvirtual` (owner sigue siendo `supabase_admin`). Verificada funcionalidad con INSERT/DELETE de prueba exitoso.
**Archivos:** db/migrations/003_fix_schema_permissions.sql, progress/history.md, asisvirtual_PROYECTO.md
**Resultado:** completado
**Notas:** Antes de la migración, `postgres` solo tenía USAGE y SELECT. Ahora tiene permisos completos para CRUD y CREATE en el schema. Los GRANTs dentro de BEGIN/COMMIT funcionan correctamente; el problema inicial fue con el pipeo del archivo SQL via stdin.

---

## 2026-07-30 — Implementer
**Tarea:** Cierre Fase 1 — Infraestructura
**Acción:** Ejecutado workflow de prueba exitosamente (execution 4793, status: success, `total_tasks: 0`). Completado checklist V1–V5 en validation.md. Todos los criterios verificados.
**Archivos:** specs/2026-07-27-fase-1-infraestructura/{plan,validation}.md, progress/history.md
**Resultado:** completado
**Notas:** Fase 1 cerrada. Pendiente merge de feature/fase-1-infraestructura a master.

---

## 2026-07-27 12:00 — Implementer
**Tarea:** 5.3 — Migración n8n a Cloudflare Tunnel
**Acción:** Actualizadas referencias de `teapartyn8n.duckdns.org` → `n8n.adalgarcia.com` en specs (requirements.md, plan.md, validation.md) y en MCP URL de opencode.json. Corregido Studio URL en validation.md (3000→30164).
**Archivos:** .config/opencode/opencode.json, specs/2026-07-27-fase-1-infraestructura/{requirements,plan,validation}.md
**Resultado:** completado

---

## 2026-07-27 11:00 — Implementer
**Tarea:** 3.3–4.2 — Actualización .env.example y aplicación de migraciones
**Acción:** Actualizado `.env.example` con puertos/URLs reales del despliegue (Kong 30164, PostgreSQL directo 5433, pooler 5432, Studio en 30164). Ejecutadas migraciones 001 y 002 vía `docker exec supabase-db psql -U supabase_admin` en 10.0.5.16. Schema `asisvirtual` creado con tablas `tasks`, `time_entries`, `email_logs` e índices, owner `supabase_admin`.
**Archivos:** .env.example
**Resultado:** completado
**Notas:** Usuario `postgres` no tiene permisos en DB `supabase`; se usó `supabase_admin`. El schema ya existía (de intento previo con postgres), las tablas se crearon sin issue.

---

## 2026-07-27 10:00 — Implementer
**Tarea:** 1.1–1.4 — Artefactos de configuración y migraciones
**Acción:** Creados `.env.example` (variables del stack oficial Supabase), `.gitignore`, `db/migrations/001_schema_asisvirtual_tasks.sql` (schema + tabla tasks con CHECKs, FK parent_id, trigger updated_at, índices) y `db/migrations/002_time_entries_email_logs.sql` (tablas time_entries con duration generada y email_logs con UNIQUE message_id)
**Archivos:** .env.example, .gitignore, db/migrations/001_schema_asisvirtual_tasks.sql, db/migrations/002_time_entries_email_logs.sql
**Resultado:** completado
**Notas:** Pendiente ejecución por el usuario: despliegue Supabase en 10.0.5.16 (plan §3), aplicación de migraciones (§4), configuración credencial n8n (§5)

---

## 2026-07-27 08:00 — Leader
**Tarea:** inicialización del harness
**Acción:** creados agentes (leader, spec_author, implementer, reviewer), agents.md, init.sh, progress/history.md
**Resultado:** sistema listo para recibir la primera tarea del roadmap

---

*Formato de entrada estándar:*

```markdown
## YYYY-MM-DD HH:MM — <Agente>
**Tarea:** <fase.sub-fase> — <nombre>
**Acción:** <descripción de lo que se hizo>
**Archivos:** <lista de archivos creados/modificados>
**Resultado:** <pendiente|completado|bloqueado>
**Notas:** <opcional>
```
