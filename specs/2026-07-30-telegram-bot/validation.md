# Validation: Telegram Bot

## Per task group

### Task Group 1: Configuración del Bot y Trigger
- [ ] El bot responde a mensajes en Telegram
- [ ] El trigger de n8n recibe eventos del bot correctamente
- [ ] Mensajes de chat_ids no autorizados son ignorados
- Verificación: enviar /start desde Telegram y confirmar respuesta

### Task Group 2: Comando /start
- [ ] /start devuelve mensaje de bienvenida con lista de comandos
- [ ] El mensaje está formateado en Markdown y se renderiza correctamente en Telegram
- Verificación: ejecutar /start y revisar formato

### Task Group 3: Comando /add
- [ ] `/add "Tarea de prueba" /work /due:2026-08-15` crea tarea en DB con source='telegram'
- [ ] `/add "Tarea simple" /personal` crea tarea sin due_date ni prioridad custom
- [ ] La respuesta incluye el ID corto de la tarea creada
- [ ] Argumentos inválidos devuelven mensaje de error claro
- Verificación: crear tarea vía bot y confirmar en Supabase Studio

### Task Group 4: Comando /tasks
- [ ] `/tasks` lista todas las tareas pendientes e in_progress
- [ ] `/tasks work` filtra solo categoría work
- [ ] `/tasks personal` filtra solo categoría personal
- [ ] Lista vacía devuelve mensaje "No hay tareas pendientes"
- [ ] Cada tarea muestra: ID corto, título, prioridad, fecha de vencimiento
- Verificación: crear varias tareas y listar con distintos filtros

### Task Group 5: Comando /done
- [ ] `/done abc12345` marca la tarea como done
- [ ] ID inexistente devuelve error "Tarea no encontrada"
- [ ] Tarea ya completada devuelve mensaje informativo
- Verificación: marcar tarea y confirmar status en DB

### Task Group 6: Comando /sub
- [ ] `/sub "Sub-tarea" de abc12345` crea sub-tarea con parent_id correcto
- [ ] Tarea padre inexistente devuelve error
- [ ] La sub-tarea aparece en /tasks con indicación de su padre
- Verificación: crear sub-tarea y verificar parent_id en DB

### Task Group 7: Comando /next
- [ ] `/next` devuelve la tarea con due_date más próxima
- [ ] Si no hay tareas con fecha, informa al usuario
- [ ] Solo considera tareas pending o in_progress
- Verificación: crear tareas con distintas fechas y verificar orden

### Task Group 8: Manejo de errores y validación
- [ ] Mensajes desde chat_id no autorizado no producen respuesta
- [ ] Comandos desconocidos devuelven mensaje de ayuda
- [ ] Errores de DB no rompen el workflow (respuesta graceful al usuario)
- Verificación: enviar mensajes inválidos y desde chat no autorizado

## Merge checklist
- [ ] All task group criteria met
- [ ] No regressions (run test suite)
- [ ] Code reviewed
- [ ] Docs updated if needed
- [ ] Workflow publicado en n8n y funcional desde Telegram
