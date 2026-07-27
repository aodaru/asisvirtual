# Misión

Automatizar la captura, clasificación y organización de tareas provenientes del
correo electrónico (Gmail y Outlook), centralizándolas en un sistema jerárquico
con seguimiento de tiempo, accesible vía Telegram. El objetivo es reducir la
carga cognitiva del usuario eliminando la necesidad de revisar múltiples bandejas
de entrada para recordar pendientes.

## Principios

- **Automatización sobre esfuerzo manual**: el sistema debe operar sin intervención
  del usuario en su funcionamiento diario.
- **Eficiencia de tokens**: pipeline de dos etapas (pre-filtro por reglas + LLM)
  para minimizar consumo de API.
- **Extensibilidad**: un servidor Supabase aloja múltiples proyectos mediante
  schemas de PostgreSQL separados.
- **Privacidad first**: self-hosted total (Supabase + n8n), ningún dato sale de
  la infraestructura del usuario.
