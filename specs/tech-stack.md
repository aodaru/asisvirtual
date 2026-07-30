# Tech Stack

Todas las versiones están congeladas y se documentan en el `docker-compose.yml`.

| Herramienta        | Versión | Propósito                          |
|--------------------|---------|------------------------------------|
| Docker             | 24+     | Contenedores                       |
| Supabase           | latest  | Base de datos + servicios backend  |
| PostgreSQL         | 15+     | Motor de base de datos             |
| n8n                | latest  | Orquestación de workflows          |
| Python             | 3.11+   | Lógica personalizada (si necesaria)|
| Telegram Bot API   | —       | Interfaz de usuario (chat)         |
| Google Gmail API   | —       | Correo personal                    |
| Microsoft Graph API| —       | Correo laboral                     |
| Claude / GPT API   | —       | Análisis semántico de correos      |

## Servicios Supabase (self-hosted en 10.0.5.16)

| Servicio | Puerto | Función |
|---|---|---|
| Kong (API Gateway) | 30164→8000 | Routing de requests REST/GraphQL |
| PostgREST | 3000 (interno) | API REST sobre PostgreSQL |
| GoTrue | 9999 (interno) | Autenticación y JWT |
| Studio | 30164 (vía Kong) | UI de administración |
| Realtime | 4000 (interno) | WebSocket subscriptions |
| Storage | 5000 (interno) | Archivos y buckets |
| PostgreSQL | 5433→5432 | Base de datos directa |
| Supavisor | 5432, 6543 | Connection pooler |

### Configuración PostgREST
- `PGRST_DB_SCHEMAS=asisvirtual,public` (asisvirtual = schema por defecto)
- `PGRST_DB_EXTRA_SEARCH_PATH=asisvirtual,public`
- JWT keys firmadas con el `JWT_SECRET` real del servidor

### Configuración Kong
- `volumes/api/kong.yml`: declarativa, incluye `Content-Profile: asisvirtual`
- Consumer keys: ANON_KEY (rol `anon`), SERVICE_ROLE_KEY (rol `service_role`)
- **Nota**: si se actualiza Supabase Docker, volver a aplicar el cambio en `kong.yml` línea 173
