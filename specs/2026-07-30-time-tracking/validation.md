# Validation: Time Tracking

## Per task group

### Task Group 1: Workflow /start-timer
- [x] `/start-timer 1` crea un registro en `time_entries` con `start_time` actual
- [x] Respuesta confirma: "Timer iniciado para tarea #1"
- [x] Si el task_id no existe, responde con error claro

### Task Group 2: Workflow /stop-timer
- [x] `/stop-timer` actualiza `end_time` y calcula duración correctamente
- [x] Respuesta muestra duración en formato legible (ej: "1h 23min")
- [x] Si no hay timer activo, responde "No hay timer activo"

### Task Group 3: Workflow /time
- [x] `/time 1` retorna la suma de todas las entradas de tiempo para tarea #1
- [x] Si no hay registros, retorna "0h 0min"

### Task Group 4: Validaciones
- [x] No se puede iniciar un segundo timer sin detener el primero
- [x] `/start-timer abc` responde con error de formato
- [x] `/stop-timer` sin timer activo no genera error en la DB

## Merge checklist
- [x] Todos los criterios de cada task group cumplidos
- [x] No hay regresiones en workflows existentes (Telegram Bot Fase 2)
- [x] Código revisado
- [x] Documentación actualizada si aplica
