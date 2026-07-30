# Plan: Email Scanner (Fase 3)

## Task Group 1: Credenciales OAuth2 Gmail
- [x] 1.1 Crear proyecto en Google Cloud Console
- [x] 1.2 Habilitar Gmail API
- [x] 1.3 Crear credenciales OAuth2 (aplicación de escritorio)
- [x] 1.4 Configurar consent screen
- [x] 1.5 Crear credencial en n8n (tipo Gmail OAuth2)
- [x] 1.6 Autorizar y verificar acceso
Estimated scope: medium

## Task Group 2: Credenciales OAuth2 Outlook
- [x] 2.1 Crear App Registration en Azure AD
- [x] 2.2 Configurar permisos (Mail.Read, Mail.ReadWrite)
- [x] 2.3 Configurar redirect URI para n8n
- [x] 2.4 Crear credencial en n8n (tipo Microsoft Outlook OAuth2)
- [x] 2.5 Autorizar y verificar acceso
Estimated scope: medium

## Task Group 3: Workflow Escaneo Gmail
- [x] 3.1 Crear workflow con Schedule Trigger (cada 6 horas)
- [x] 3.2 Agregar nodo Gmail: buscar correos recientes (últimas 24h)
- [x] 3.3 Consultar `email_logs` para obtener IDs ya procesados
- [x] 3.4 Filtrar correos ya procesados (excluir message_ids existentes)
- [x] 3.5 Aplicar pre-filtro por reglas (remitentes, palabras clave, menciones)
- [x] 3.6 Insertar en `email_logs` los correos nuevos procesados
- [x] 3.7 Output: array de correos que pasaron el filtro (para Fase 4)
Estimated scope: large

## Task Group 4: Workflow Escaneo Outlook
- [x] 4.1 Crear workflow con Schedule Trigger (cada 6 horas)
- [x] 4.2 Agregar nodo Microsoft Outlook: buscar correos recientes (últimas 24h)
- [x] 4.3 Consultar `email_logs` para obtener IDs ya procesados
- [x] 4.4 Filtrar correos ya procesados (excluir message_ids existentes)
- [x] 4.5 Aplicar pre-filtro por reglas (remitentes, palabras clave, menciones)
- [x] 4.6 Insertar en `email_logs` los correos nuevos procesados
- [x] 4.7 Output: array de correos que pasaron el filtro (para Fase 4)
Estimated scope: large

## Task Group 5: Configuración del Pre-Filtro
- [x] 5.1 Definir lista de remitentes prioritarios (configurable)
- [x] 5.2 Definir palabras clave para detección de tareas
- [x] 5.3 Detectar @menciones al usuario
- [x] 5.4 Detectar marcado como importante
- [x] 5.5 Documentar reglas en archivo de configuración
Estimated scope: medium

## Task Group 6: Validación y Pruebas
- [x] 6.1 Probar flujo completo Gmail (scan → filter → log)
- [x] 6.2 Probar flujo completo Outlook (scan → filter → log)
- [x] 6.3 Verificar deduplicación (no reprocesar correos)
- [x] 6.4 Verificar manejo de errores (API failures, rate limits)
- [x] 6.5 Documentar configuración en README
Estimated scope: medium
