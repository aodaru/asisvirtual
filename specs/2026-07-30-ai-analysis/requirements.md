# Feature: AI Analysis (Fase 4)

## Goal

Integrar un modelo de lenguaje (LLM) para analizar correos electrónicos que pasaron el pre-filtro, extraer información clave (título, fecha de vencimiento, prioridad, categoría) y crear tareas automáticamente en Supabase. Completa el pipeline: correo → pre-filtro → LLM → tarea en DB.

## Scope

### In scope
- Configurar API key del LLM en n8n (OpenAI o Groq)
- Integrar AI Agent node en los workflows de Email Scanner
- Prompt para extraer: título, fecha de vencimiento, prioridad (1-5), categoría (work/personal)
- Insertar tareas extraídas en tabla `tasks` con source='email'
- Notificación a Telegram cuando se crea una tarea desde correo
- Manejo de errores del LLM (fallback, reintentos)

### Out of scope
- Clasificación avanzada con embeddings
- Análisis de attachments
- Respuesta automática a correos
- Entrenamiento de modelos personalizados

## Context

### Decisions
- Se usa OpenAI (gpt-4o-mini) o Groq (llama-3.3-70b) como LLM
- Pipeline de dos etapas: pre-filtro (reglas) + LLM (análisis semántico)
- Los correos que no pasan el pre-filtro NO se envían al LLM (ahorro de tokens)
- Las tareas creadas tienen source='email' para diferenciar de las manuales
- Se envía notificación a Telegram al crear cada tarea

### Constraints
- Consumo de tokens: minimizar enviando solo snippets al LLM
- Latencia: el LLM puede tardar 2-5 segundos por correo
- Costo: gpt-4o-mini es económico (~$0.15/1M input tokens)
- Límites de API: rate limits de OpenAI/Groq

## References
- specs/mission.md (pipeline de dos etapas, eficiencia de tokens)
- specs/tech-stack.md (Claude / GPT API)
- asisvirtual_PROYECTO.md §6 (flujo de procesamiento)
