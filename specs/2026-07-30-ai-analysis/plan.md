# Plan: AI Analysis (Fase 4)

## Task Group 1: Configuración del LLM
- [x] 1.1 Verificar/crear API key de OpenAI o Groq en n8n
- [x] 1.2 Configurar credencial en n8n (tipo OpenAI API o Groq API)
- [x] 1.3 Verificar acceso al modelo (gpt-4o-mini o llama-3.3-70b)
Estimated scope: small

## Task Group 2: Prompt y AI Agent
- [x] 2.1 Diseñar prompt para extraer título, fecha, prioridad, categoría
- [x] 2.2 Configurar AI Agent node con el prompt
- [x] 2.3 Definir schema de salida (JSON estructurado)
- [x] 2.4 Probar con emails de ejemplo
Estimated scope: medium

## Task Group 3: Pipeline Integrado Gmail
- [x] 3.1 Agregar AI Agent node después del pre-filtro en workflow Gmail
- [x] 3.2 Parsear output del LLM y mapear a campos de tasks
- [x] 3.3 Insertar tareas en Supabase (tabla tasks, source='email')
- [x] 3.4 Notificar a Telegram al crear tarea
- [x] 3.5 Manejar errores del LLM (output vacío, JSON inválido)
Estimated scope: large

## Task Group 4: Pipeline Integrado Outlook
- [x] 4.1 Agregar AI Agent node después del pre-filtro en workflow Outlook
- [x] 4.2 Reutilizar prompt y lógica del workflow Gmail
- [x] 4.3 Insertar tareas en Supabase (tabla tasks, source='email')
- [x] 4.4 Notificar a Telegram al crear tarea
- [x] 4.5 Manejar errores del LLM
Estimated scope: large

## Task Group 5: Notificación Telegram
- [x] 5.1 Configurar nodo Telegram para enviar mensaje de notificación
- [x] 5.2 Formatear mensaje con título, prioridad, categoría, fecha
- [x] 5.3 Integrar en ambos workflows (Gmail y Outlook)
Estimated scope: medium

## Task Group 6: Validación y Pruebas
- [x] 6.1 Probar flujo completo Gmail (scan → filter → LLM → task → notify)
- [x] 6.2 Probar flujo completo Outlook
- [x] 6.3 Verificar inserción correcta en tabla tasks
- [x] 6.4 Verificar notificaciones en Telegram
- [x] 6.5 Documentar configuración
Estimated scope: medium
