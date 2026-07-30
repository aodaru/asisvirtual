# Feature: Email Scanner (Fase 3)

## Goal

Escaneo automático de bandejas de entrada de correo electrónico (Gmail personal + Outlook laboral) para capturar correos que podrían contener tareas. Los correos se procesan con un pre-filtro por reglas (sin LLM) y se almacenan en `email_logs` para evitar reprocesos.

## Scope

### In scope
- Credenciales OAuth2 para Gmail (Google Cloud Console)
- Credenciales OAuth2 para Outlook (Azure AD App Registration)
- Workflow n8n con Schedule Trigger para escaneo diario
- Nodo Gmail: fetch correos recientes
- Nodo Outlook (Microsoft Graph): fetch correos recientes
- Pre-filtro por reglas: remitentes, palabras clave, @menciones, marcado como importante
- Deduplicación vía tabla `email_logs` (UNIQUE message_id)
- Almacenamiento de metadata del correo procesado

### Out of scope
- Análisis con IA/LLM (Fase 4)
- Inserción automática de tareas en `tasks` (Fase 4)
- Notificaciones a Telegram al detectar correos (Fase 7)
- Respuesta o envío de correos
- Gestión de carpetas/labels

## Context

### Decisions
- Se usa Schedule Trigger en n8n para escaneo diario (frecuencia a definir, sugerido: cada 4-6 horas)
- Pre-filtro es 100% reglas, sin consumo de tokens de LLM
- Deduplicación garantizada por `UNIQUE(message_id)` en `email_logs`
- Se procesan tanto correos leídos como no leídos
- Los correos ya procesados (en `email_logs`) se saltan

### Constraints
- Gmail: límites de API de Google (cuota diaria de 1000 unidades de cuota por usuario)
- Outlook: límites de Microsoft Graph (10,000 requests por 10 minutos por app)
- Credenciales OAuth2 requieren configuración manual en consolas de Google/Azure
- n8n debe estar corriendo con acceso a internet para OAuth2 flow

## References
- specs/mission.md (pipeline de dos etapas: pre-filtro + LLM)
- specs/tech-stack.md (Google Gmail API, Microsoft Graph API)
- asisvirtual_PROYECTO.md §6 (flujo de procesamiento de correos)
