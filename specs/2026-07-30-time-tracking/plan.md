# Plan: Time Tracking

## Task Group 1: Workflow /start-timer
- [x] Crear workflow con trigger de comando `/start-timer <task_id>`
- [x] Validar que el task_id existe en tabla `tasks`
- [x] Verificar que no hay un timer activo para este usuario
- [x] INSERT en tabla `time_entries` con `start_time = now()` y `task_id`
- [x] Responder al usuario con confirmación
Estimated scope: small

## Task Group 2: Workflow /stop-timer
- [x] Crear workflow con trigger de comando `/stop-timer`
- [x] Buscar el timer activo del usuario en `time_entries` (donde `end_time IS NULL`)
- [x] Si no hay timer activo, informar al usuario
- [x] UPDATE: `end_time = now()`, calcular `duration = end_time - start_time`
- [x] Responder con la duración formateada (horas, minutos)
Estimated scope: small

## Task Group 3: Workflow /time
- [x] Crear workflow con trigger de comando `/time <task_id>`
- [x] Ejecutar query de suma de duraciones agrupada por task_id
- [x] Formatear respuesta con tiempo total acumulado
- [x] Responder al usuario con el resumen
Estimated scope: small

## Task Group 4: Validaciones y edge cases
- [x] Manejar caso donde task_id no existe
- [x] Manejar caso donde no hay timer activo al hacer /stop-timer
- [x] Manejar caso donde ya existe un timer activo al hacer /start-timer
- [x] Respuestas claras en español para cada error
Estimated scope: small
