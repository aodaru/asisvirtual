# Backup — Supabase Self-Hosted (10.0.5.16)

Copia de seguridad de las personalizaciones hechas al stack de Supabase.

## Archivos

| Archivo | Descripción |
|---|---|
| `kong.yml` | Configuración declarativa de Kong (API Gateway). Incluye `Content-Profile: asisvirtual` en request-transformer. |
| `.env.server` | Variables de entorno reales del servidor (contiene secretos). **NUNCA commitear a git.** |
| `db-info.txt` | Información de conexión a la base de datos. |

## Personalizaciones aplicadas

### 1. JWT Keys (ANON_KEY, SERVICE_ROLE_KEY)
Regeneradas con el JWT_SECRET real del servidor (no el placeholder de demo).
Para regenerar:
```python
python3 -c "
import hmac, hashlib, base64, json
secret = 'TU_JWT_SECRET_AQUI'
def make_jwt(role):
    header = base64.urlsafe_b64encode(json.dumps({'alg':'HS256','typ':'JWT'},separators=(',',':')).encode()).rstrip(b'=').decode()
    payload_data = {'role':role,'iss':'supabase-demo','iat':1641769200,'exp':1799535600}
    payload = base64.urlsafe_b64encode(json.dumps(payload_data,separators=(',',':')).encode()).rstrip(b'=').decode()
    sig = base64.urlsafe_b64encode(hmac.new(secret.encode(), f'{header}.{payload}'.encode(), hashlib.sha256).digest()).rstrip(b'=').decode()
    return f'{header}.{payload}.{sig}'
print('ANON_KEY=' + make_jwt('anon'))
print('SERVICE_ROLE_KEY=' + make_jwt('service_role'))
"
```

### 2. PostgREST Schema
`PGRST_DB_SCHEMAS=asisvirtual,public` (asisvirtual primero = schema por defecto).
`PGRST_DB_EXTRA_SEARCH_PATH=asisvirtual,public`.

### 3. Kong — Content-Profile
`volumes/api/kong.yml` línea 173: `Content-Profile: asisvirtual` en request-transformer de `rest-v1`.

### 4. Permisos de base de datos
- `postgres`: CREATE, INSERT, UPDATE, DELETE en asisvirtual
- `service_role`: USAGE, ALL en asisvirtual
- `anon`: USAGE, SELECT en asisvirtual
- `authenticator`: USAGE, SELECT en asisvirtual

## Restauración

Si se sobreescribe `kong.yml` (ej: actualización de Supabase Docker):

```bash
# Copiar kong.yml al servidor
scp kong.yml truenas_admin@10.0.5.16:/tmp/kong.yml
ssh truenas_admin@10.0.5.16 "echo PASSWORD | sudo -S cp /tmp/kong.yml /mnt/Aodnas/Docker/supabase/docker/volumes/api/kong.yml"

# Recrear Kong
ssh truenas_admin@10.0.5.16 "echo PASSWORD | sudo -S docker compose -f /mnt/Aodnas/Docker/supabase/docker/docker-compose.yml up -d --force-recreate kong"
```

Si se sobreescribe `.env`:
```bash
# Restaurar variables clave del .env.server
scp .env.server truenas_admin@10.0.5.16:/tmp/.env
ssh truenas_admin@10.0.5.16 "echo PASSWORD | sudo -S cp /tmp/.env /mnt/Aodnas/Docker/supabase/docker/.env"

# Recrear contenedores afectados
ssh truenas_admin@10.0.5.16 "echo PASSWORD | sudo -S docker compose -f /mnt/Aodnas/Docker/supabase/docker/docker-compose.yml up -d --force-recreate rest kong"
```
