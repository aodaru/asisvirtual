# Plan: Telegram Bot

## Task Group 1: Configuración del Bot y Trigger
- [x] 1.1 Crear bot en BotFather, obtener token
- [x] 1.2 Configurar credencial Telegram en n8n
- [x] 1.3 Configurar credencial `supabaseApi` en n8n (Host: `http://10.0.5.16:30164`, API Key: `SERVICE_ROLE_KEY` del `.env` del servidor)
- [x] 1.4 Crear workflow con Telegram Trigger node
- [x] 1.5 Agregar Switch node para routing por comando (/add, /tasks, /done, /sub, /start, /next)
- [x] 1.6 Configurar variable de entorno `AUTHORIZED_CHAT_ID` para restringir acceso
Estimated scope: small

## Task Group 2: Comando /start
- [x] 2.1 Implementar respuesta de bienvenida con lista de comandos disponibles
- [x] 2.2 Formatear mensaje en Markdown
Estimated scope: small

## Task Group 3: Comando /add
- [x] 3.1 Parsear argumentos: título, categoría (work/personal), fecha opcional (due:YYYY-MM-DD), prioridad opcional (1-5)
- [x] 3.2 Validar campos requeridos (título obligatorio, categoría válida)
- [x] 3.3 Ejecutar Supabase node `create` → tabla `tasks`, schema `asisvirtual`, source='telegram'
- [x] 3.4 Responder con confirmación e ID corto de la tarea
Estimated scope: medium

## Task Group 4: Comando /tasks
- [x] 4.1 Ejecutar Supabase node `getAll` → tabla `tasks`, schema `asisvirtual`, filtros: `status.in.(pending,in_progress)`
- [x] 4.2 Soportar filtro por categoría: `/tasks work`, `/tasks personal`, sin filtro = todas (agregar filtro `category.eq.{cat}`)
- [x] 4.3 Formatear respuesta agrupada por categoría con ID corto, título, prioridad y fecha
- [x] 4.4 Manejar caso de lista vacía
Estimated scope: medium

## Task Group 5: Comando /done
- [x] 5.1 Parsear ID corto de tarea desde argumento
- [x] 5.2 Ejecutar Supabase node `getAll` con `filterString: "id.like.{shortId}*"` para buscar por prefijo de UUID
- [x] 5.3 Ejecutar Supabase node `update` → status = 'done', filtrando por ID completo encontrado
- [x] 5.4 Confirmar al usuario o reportar error si no se encuentra
Estimated scope: small

## Task Group 6: Comando /sub
- [x] 6.1 Parsear título de sub-tarea y referencia a tarea padre
- [x] 6.2 Ejecutar Supabase node `getAll` con `filterString: "id.like.{shortId}*"` para buscar tarea padre
- [x] 6.3 Ejecutar Supabase node `create` → tabla `tasks`, schema `asisvirtual`, con `parent_id` apuntando a la tarea padre
- [x] 6.4 Confirmar creación con vínculo jerárquico
Estimated scope: medium

## Task Group 7: Comando /next
- [x] 7.1 Ejecutar Supabase node `getAll` → tabla `tasks`, schema `asisvirtual`, filtros: `status.in.(pending,in_progress)`, `due_date.not.is.null`, orderBy: `due_date.asc`, limit: 1
- [x] 7.2 Formatear respuesta con detalle de la tarea más próxima a vencer
- [x] 7.3 Manejar caso sin tareas con fecha
Estimated scope: small

## Task Group 8: Manejo de errores y validación
- [x] 8.1 Validar chat_id contra AUTHORIZED_CHAT_ID en cada mensaje
- [x] 8.2 Respuestas de error para comandos desconocidos
- [x] 8.3 Respuestas de error para formatos inválidos
- [x] 8.4 Logging básico de errores en n8n
Estimated scope: small
