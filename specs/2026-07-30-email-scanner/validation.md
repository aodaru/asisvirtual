# Validation: Email Scanner (Fase 3)

## Per task group

### Task Group 1: Credenciales OAuth2 Gmail
- [ ] Credencial creada en n8n tipo Gmail OAuth2
- [ ] Token de acceso obtenido exitosamente
- [ ] Refresh token funciona correctamente
- [ ] Nodo Gmail puede listar correos (test manual)

### Task Group 2: Credenciales OAuth2 Outlook
- [ ] Credencial creada en n8n tipo Microsoft Outlook OAuth2
- [ ] Token de acceso obtenido exitosamente
- [ ] Refresh token funciona correctamente
- [ ] Nodo Outlook puede listar correos (test manual)

### Task Group 3: Workflow Escaneo Gmail
- [ ] Workflow creado y activo en n8n
- [ ] Schedule Trigger ejecuta a la frecuencia configurada
- [ ] Gmail node retorna correos de las últimas 24h
- [ ] Filtrado de correos ya en `email_logs` funciona
- [ ] Pre-filtro aplica reglas correctamente
- [ ] `email_logs` se actualiza con nuevos message_ids
- [ ] Output contiene correos que pasaron el filtro

### Task Group 4: Workflow Escaneo Outlook
- [ ] Workflow creado y activo en n8n
- [ ] Schedule Trigger ejecuta a la frecuencia configurada
- [ ] Outlook node retorna correos de las últimas 24h
- [ ] Filtrado de correos ya en `email_logs` funciona
- [ ] Pre-filtro aplica reglas correctamente
- [ ] `email_logs` se actualiza con nuevos message_ids
- [ ] Output contiene correos que pasaron el filtro

### Task Group 5: Configuración del Pre-Filtro
- [ ] Lista de remitentes prioritarios definida
- [ ] Palabras clave configuradas
- [ ] Detección de @menciones funciona
- [ ] Detección de marcado como importante funciona
- [ ] Reglas documentadas

### Task Group 6: Validación y Pruebas
- [ ] Flujo completo Gmail ejecutado sin errores
- [ ] Flujo completo Outlook ejecutado sin errores
- [ ] Deduplicación verificada (mismo correo no se procesa 2 veces)
- [ ] Errores de API manejados gracefully
- [ ] README actualizado con configuración

## Merge checklist
- [ ] Todos los criterios de task groups cumplidos
- [ ] Workflows de n8n exportados/documentados
- [ ] Credenciales configuradas (o documentación para configurar)
- [ ] Pre-filtro documentado
- [ ] Sin regresiones en Fase 1 y 2
