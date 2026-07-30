# Validation: AI Analysis (Fase 4)

## Per task group

### Task Group 1: Configuración del LLM
- [ ] Credencial del LLM configurada en n8n
- [ ] API key válida y con créditos
- [ ] Modelo accesible (test simple)

### Task Group 2: Prompt y AI Agent
- [ ] Prompt genera JSON válido con título, fecha, prioridad, categoría
- [ ] AI Agent node configurado correctamente
- [ ] Output parseable y consistente

### Task Group 3: Pipeline Integrado Gmail
- [ ] AI Agent se ejecuta después del pre-filtro
- [ ] Tareas se insertan en tabla tasks con source='email'
- [ ] Notificación se envía a Telegram
- [ ] Errores del LLM se manejan gracefully

### Task Group 4: Pipeline Integrado Outlook
- [ ] AI Agent se ejecuta después del pre-filtro
- [ ] Tareas se insertan en tabla tasks con source='email'
- [ ] Notificación se envía a Telegram
- [ ] Errores del LLM se manejan gracefully

### Task Group 5: Notificación Telegram
- [ ] Mensaje formateado con título, prioridad, categoría, fecha
- [ ] Notificación enviada al crear cada tarea
- [ ] Mensaje es claro y legible

### Task Group 6: Validación y Pruebas
- [ ] Pipeline Gmail completo funcional
- [ ] Pipeline Outlook completo funcional
- [ ] Tareas creadas correctamente en DB
- [ ] Notificaciones recibidas en Telegram
- [ ] Documentación actualizada

## Merge checklist
- [ ] Todos los criterios de task groups cumplidos
- [ ] Workflows de n8n exportados/documentados
- [ ] LLM configurado y funcionando
- [ ] Sin regresiones en Fase 1-3
