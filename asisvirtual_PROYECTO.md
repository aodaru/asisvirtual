# AsistVirtual — Asistente Virtual de Tareas

## 1. Resumen Ejecutivo

**AsistVirtual** es un sistema automatizado de gestión de tareas que centraliza correos electrónicos de múltiples cuentas (trabajo y personal), los analiza para detectar tareas implícitas, y las organiza en un sistema jerárquico con seguimiento de tiempo. El usuario interactúa con el sistema a través de un bot de Telegram para consultar, agregar y gestionar tareas, y recibe resúmenes diarios automáticos.

El sistema está construido sobre una arquitectura orientada a servicios, utilizando **Supabase** como infraestructura de datos compartida que puede servir a múltiples proyectos independientes mediante schemas de PostgreSQL.

---

## 2. Objetivos del Proyecto

### Objetivo General
Automatizar la captura, clasificación, organización y seguimiento de tareas provenientes del correo electrónico, reduciendo la carga cognitiva del usuario al centralizar todas sus responsabilidades en un solo sistema accesible vía chat.

### Objetivos Específicos

1. **Escaneo automático diario** de bandejas de entrada de correo electrónico (Gmail personal + Outlook laboral), incluyendo correos leídos y no leídos.
2. **Detección inteligente de tareas** mediante un pipeline de dos etapas: filtro por reglas y análisis fino con un modelo de lenguaje (LLM), minimizando el consumo de tokens.
3. **Clasificación automática** de tareas en categorías (trabajo / personal) con asignación a la cuenta origen correspondiente.
4. **Gestión jerárquica de tareas** con soporte para tareas principales y sub-tareas (estructura de árbol).
5. **Registro y consulta de tiempo invertido** por tarea.
6. **Interacción vía Telegram** para consultar tareas pendientes, agregar tareas manualmente, marcar como completadas, y obtener respuestas a preguntas como "¿cuál es la tarea más próxima a vencer?" o "¿cuánto tiempo llevo en esta tarea?".
7. **Resumen diario automático** de tareas pendientes enviado a Telegram.
8. **Arquitectura extensible** que permita agregar nuevos proyectos en el futuro, cada uno con su propio schema de base de datos dentro del mismo servidor Supabase.

---

## 3. Público Destinatario

| Rol | Descripción |
|-----|-------------|
| **Usuario final** | Profesional con una o más cuentas de correo (trabajo y personal) que necesita centralizar y dar seguimiento a sus tareas sin depender de múltiples herramientas. |
| **Perfil técnico** | Usuario con capacidad para desplegar contenedores Docker y configurar n8n. No se requiere programación para el uso diario; la configuración inicial es la única parte técnica. |

---

## 4. Arquitectura del Sistema

```
                    ┌──────────────────────┐
                    │    Telegram App      │
                    │      (usuario)       │
                    └─────────┬────────────┘
                              │ comandos / notificaciones
                              ▼
┌─────────────────────────────────────────────────────────┐
│                        n8n                               │
│                                                         │
│  ┌────────────────┐  ┌──────────────┐  ┌─────────────┐ │
│  │ Email Scanner  │  │ Telegram Bot │  │Daily Report │ │
│  │ (schedule)     │  │ (trigger)    │  │ (schedule)  │ │
│  └───────┬────────┘  └──────┬───────┘  └──────┬──────┘ │
│          │                  │                  │        │
│  ┌───────┴────────┐         │                  │        │
│  │   AI Agent     │◄────────┘                  │        │
│  │  (analiza)     │                            │        │
│  └───────┬────────┘                            │        │
│          │                                     │        │
└──────────┼─────────────────────────────────────┼────────┘
           │                                     │
           ▼                                     ▼
┌────────────────────────────────────────────────────────┐
│                    Supabase (Docker)                    │
│                                                         │
│  ┌─────────────────────────────────────────────────┐   │
│  │              PostgreSQL                          │   │
│  │                                                  │   │
│  │  schema: asisvirtual                             │   │
│  │   ├── tasks                                      │   │
│  │   ├── time_entries                               │   │
│  │   └── email_logs                                 │   │
│  │                                                  │   │
│  │  schema: ventas          (futuro)                │   │
│  │  schema: blog            (futuro)                │   │
│  └──────────────────────────────────────────────────┘   │
│                                                         │
│  Servicios adicionales:                                  │
│   ├── Studio UI (http://localhost:3000)                 │
│   ├── PostgREST (REST API auto-generada)                │
│   ├── GoTrue (Auth)                                     │
│   └── Realtime (WebSockets)                             │
└─────────────────────────────────────────────────────────┘
```

### 4.1 Componentes

| Componente | Rol | Tecnología |
|------------|-----|------------|
| **n8n** | Orquestador de workflows | n8n (Docker o cloud) |
| **Supabase** | Almacenamiento de datos + API | Supabase self-hosted (Docker) |
| **PostgreSQL** | Base de datos relacional subyacente | PostgreSQL 15+ |
| **Telegram Bot** | Interfaz de usuario (chat) | Telegram Bot API |
| **LLM** | Análisis semántico de correos | Claude / GPT vía n8n AI Agent |
| **Gmail API** | Obtención de correo personal | Google API (OAuth2) |
| **Microsoft Graph API** | Obtención de correo laboral | Microsoft Graph (OAuth2) |

### 4.2 Principio Multi-Proyecto

Un solo servidor Supabase aloja múltiples proyectos independientes, cada uno en su propio **schema de PostgreSQL**:

```
esquema: asisvirtual/  → tablas: tasks, time_entries, email_logs
esquema: ventas/       → tablas: products, orders, customers (futuro)
esquema: blog/         → tablas: posts, categories (futuro)
```

n8n se conecta al mismo servidor PostgreSQL y selecciona el schema según el workflow:

```sql
SET search_path TO asisvirtual;
SELECT * FROM tasks WHERE status = 'pending';
```

---

## 5. Diseño de la Base de Datos

### Schema: `asisvirtual`

#### Tabla: `tasks`

| Columna | Tipo | Descripción |
|---------|------|-------------|
| `id` | `UUID PK` | Identificador único |
| `parent_id` | `UUID FK → tasks.id` | Para sub-tareas (jerarquía) |
| `title` | `TEXT NOT NULL` | Título de la tarea |
| `description` | `TEXT` | Descripción detallada |
| `category` | `TEXT CHECK ('work','personal')` | Clasificación |
| `status` | `TEXT CHECK ('pending','in_progress','done','cancelled')` | Estado actual |
| `priority` | `INTEGER (1-5)` | Prioridad (1=máxima, 5=mínima) |
| `due_date` | `DATE` | Fecha de vencimiento |
| `estimated_hours` | `NUMERIC(5,1)` | Estimación inicial |
| `source` | `TEXT CHECK ('email','manual','telegram')` | Origen de la tarea |
| `source_email_id` | `TEXT` | ID del mensaje original (si vino por email) |
| `email_account` | `TEXT` | Cuenta de correo origen |
| `metadata` | `JSONB` | Datos adicionales flexibles |
| `created_at` | `TIMESTAMPTZ` | Fecha de creación |
| `updated_at` | `TIMESTAMPTZ` | Última modificación |

#### Tabla: `time_entries`

| Columna | Tipo | Descripción |
|---------|------|-------------|
| `id` | `UUID PK` | Identificador único |
| `task_id` | `UUID FK → tasks.id` | Tarea asociada |
| `start_time` | `TIMESTAMPTZ NOT NULL` | Inicio del registro |
| `end_time` | `TIMESTAMPTZ` | Fin del registro |
| `duration` | `INTERVAL (generated)` | Diferencia end_time - start_time |
| `notes` | `TEXT` | Notas sobre el período |
| `created_at` | `TIMESTAMPTZ` | Fecha de creación |

#### Tabla: `email_logs`

| Columna | Tipo | Descripción |
|---------|------|-------------|
| `id` | `UUID PK` | Identificador único |
| `message_id` | `TEXT NOT NULL` | ID único del mensaje |
| `source` | `TEXT CHECK ('gmail','outlook')` | Proveedor de correo |
| `processed_at` | `TIMESTAMPTZ` | Cuándo se procesó |

**Garantía:** `UNIQUE(message_id)` — evita reprocesar el mismo correo.

---

## 6. Flujo de Procesamiento de Correos

```
 Email recibido
      │
      ▼
 ┌─────────────────────┐
 │   PRE-FILTRO        │  ← Sin LLM, solo reglas
 │                     │
 │  • Remitentes       │
 │  • Palabras clave   │
 │  • @menciones       │
 │  • Marcado como     │
 │    importante       │
 └──────────┬──────────┘
            │ ¿pasa el filtro?
            │
     ┌──────┴──────┐
     │ SI          │ NO → ignorar
     ▼
 ┌─────────────────────┐
 │   ANÁLISIS CON LLM  │  ← Solo si pasó el pre-filtro
 │                     │
 │  • Extraer título   │
 │  • Fecha vencimiento │
 │  • Prioridad        │
 │  • Clasificar       │
 │    (trabajo/personal)│
 └──────────┬──────────┘
            │
            ▼
 ┌─────────────────────┐
 │  INSERTAR EN        │
 │  Supabase (tasks)   │
 └─────────────────────┘
```

Este pipeline de dos etapas reduce drásticamente el consumo de tokens de LLM, ya que solo una fracción de los correos diarios pasa el pre-filtro.

---

## 7. Interfaz de Usuario — Telegram Bot

### Comandos disponibles

| Comando | Ejemplo | Respuesta |
|---------|---------|-----------|
| `/start` | — | Mensaje de bienvenida con instrucciones |
| `/tasks` | `/tasks` | Lista tareas pendientes agrupadas (trabajo / personal) |
| `/tasks work` | — | Solo tareas del trabajo |
| `/tasks personal` | — | Solo tareas personales |
| `/next` | — | Tarea con la fecha límite más próxima |
| `/add` | `/add "Investigación API" /trabajo /due:2026-08-15` | Crea tarea y confirma con su ID |
| `/sub` | `/sub "Unificar datos" de "Plataforma precios"` | Crea sub-tarea bajo una tarea existente |
| `/done` | `/done abc-123` | Marca tarea como completada |
| `/start-timer` | `/start-timer abc-123` | Inicia time tracking |
| `/stop-timer` | `/stop-timer abc-123` | Detiene y registra tiempo |
| `/time` | `/time abc-123` | Muestra tiempo total invertido |
| `/summary` | — | Resumen de pendientes del día |

### Notificaciones automáticas

El sistema envía mensajes proactivos al usuario:
- **Resumen diario** (configurable, ej. 08:00 AM): tareas pendientes, próximas a vencer, atrasadas.
- **Nueva tarea detectada**: notificación cuando un correo se convierte en tarea.

---

## 8. Workflows de n8n

| # | Workflow | Trigger | Descripción |
|---|----------|---------|-------------|
| 1 | **Email Scanner** | Schedule (diario) | Obtiene correos nuevos de Gmail y Outlook, aplica pre-filtro, envía al AI Agent para análisis, inserta tareas en Supabase. |
| 2 | **Telegram Bot** | Telegram Trigger | Escucha comandos del usuario y ejecuta la acción correspondiente (CRUD de tareas, consultas, time tracking). |
| 3 | **Daily Report** | Schedule (diaria) | Consulta tareas pendientes en Supabase, genera resumen y lo envía a Telegram. |
| 4 | **Nueva Tarea Detectada** | Sub-workflow llamado desde #1 | Envía notificación a Telegram cuando se crea una tarea desde un correo. |

---

## 9. Plan de Implementación por Fases

### Fase 1 — Infraestructura
- Desplegar Supabase self-hosted en Docker
- Crear schema `asisvirtual` con las tablas `tasks`, `time_entries`, `email_logs`
- Verificar conexión desde n8n

### Fase 2 — Telegram Bot
- Crear bot en Telegram con BotFather
- Implementar comandos básicos: `/add`, `/tasks`, `/done`
- Workflow en n8n que procesa comandos y opera sobre Supabase

### Fase 3 — Email Scanner
- Configurar credenciales OAuth2 para Gmail y Microsoft Graph
- Workflow de escaneo diario con nodos nativos Gmail + Outlook
- Implementar pre-filtro por reglas (sin LLM)
- Almacenar en `email_logs` para evitar reprocesos

### Fase 4 — Análisis con IA
- Integrar AI Agent (Claude/GPT) para la segunda etapa de análisis
- Extraer título, fecha de vencimiento, prioridad y categoría
- Pipeline completo: correo → pre-filtro → LLM → tarea en Supabase

### Fase 5 — Time Tracking
- Comandos `/start-timer`, `/stop-timer`, `/time`
- Tabla `time_entries` operativa
- Consultas de tiempo agregado por tarea

### Fase 6 — Daily Report
- Workflow schedule que consulta tareas pendientes
- Formatea resumen y envía a Telegram
- Incluye: tareas vencidas, próximas a vencer (próximos 3 días), total de pendientes

---

## 10. Tecnologías y Herramientas

| Herramienta | Versión | Propósito |
|-------------|---------|-----------|
| Docker | 24+ | Contenedores |
| Supabase | latest | Base de datos + servicios |
| PostgreSQL | 15+ | Motor de base de datos |
| n8n | latest | Orquestación de workflows |
| Python | 3.11+ | Lógica personalizada (si es necesaria) |
| Telegram Bot API | — | Interfaz de usuario |
| Google API (Gmail) | — | Correo personal |
| Microsoft Graph API | — | Correo laboral |
| Claude / GPT (API) | — | Análisis semántico de correos |

---

## 11. Notas Técnicas Adicionales

### Conexión n8n → Supabase (PostgreSQL)
```
Host: localhost (o nombre del contenedor)
Port: 5432
Database: supabase (o el nombre de la base)
User: postgres (o el rol configurado)
Password: <configurada en docker-compose>

Query inicial recomendada para cada workflow:
  SET search_path TO asisvirtual;
```

### Autenticación de Correos
- **Gmail**: OAuth2 con Google Cloud Console (credenciales de aplicación de escritorio)
- **Outlook**: OAuth2 con Azure AD App Registration (permisos: Mail.Read, Mail.ReadWrite)

Ambos métodos son soportados nativamente por los nodos de n8n, que manejan el refresh de tokens automáticamente.

### Extensibilidad Futura
Para agregar un nuevo proyecto al servidor Supabase:

```sql
CREATE SCHEMA IF NOT EXISTS nuevo_proyecto;
-- Crear tablas específicas dentro del schema
CREATE TABLE nuevo_proyecto.mi_tabla ( ... );
```

Desde n8n se accede con:
```sql
SET search_path TO nuevo_proyecto;
```

No hay límite práctico en la cantidad de schemas o proyectos que puede albergar un solo servidor Supabase.
