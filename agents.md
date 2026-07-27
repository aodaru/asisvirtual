# Harness Engineering — Spec-Driven Development

Este repositorio utiliza un flujo **Spec-Driven Development (SDD)** orquestado por agentes especializados.

## ⚠️ Protocolo de Entrada Obligatorio

Antes de comenzar cualquier trabajo, **todo agente debe ejecutar**:

```bash
source .harness/init.sh
```

Este script verifica:
- Entorno correcto (directorios esenciales existen)
- Dependencias instaladas (Docker, psql, etc.)
- Tests actuales pasando
- Estado del progreso

Si el script falla, detener la operación y reportar el error.

## Arquitectura de Agentes

| Agente | Archivo | Responsabilidad |
|--------|---------|-----------------|
| **Leader** | `.harness/agents/leader.md` | Orquestador: decide qué fase sigue y qué agente ejecutar |
| **Spec Author** | `.harness/agents/spec_author.md` | Redacta req (EARS), diseño técnico y task list |
| **Implementer** | `.harness/agents/implementer.md` | Escribe código siguiendo la especificación |
| **Reviewer** | `.harness/agents/reviewer.md` | Valida código contra especificación, convenciones y tests |

## Flujo SDD

```
Leader → (selecciona tarea) → Spec Author → Leader → Implementer → Leader → Reviewer → Leader
                                                                          │
                                                                    [RECHAZADO] → Implementer
                                                                          │
                                                                    [APROBADO] → siguiente tarea
```

## Archivos de Progreso

- `progress/history.md` — historial cronológico de todas las acciones de agentes
- `progress/` — artefactos intermedios por sesión

## Convenciones

- Los agentes **nunca** modifican archivos fuera de su alcance definido
- Cada entrada en `history.md` tiene timestamp ISO
- Las tareas solo se marcan completadas tras aprobación del reviewer
