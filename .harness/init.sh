#!/usr/bin/env bash
set -euo pipefail

echo "=== Harness Init — Verificación del Entorno ==="

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

FAIL=0

# 1. Directorios esenciales
echo "[1/5] Verificando estructura de directorios..."
for dir in ".harness/agents" "specs" "progress"; do
    if [ -d "$dir" ]; then
        echo "  ✓ $dir/"
    else
        echo "  ✗ $dir/ — NO ENCONTRADO"
        FAIL=1
    fi
done

# 2. Archivos esenciales
echo "[2/5] Verificando archivos esenciales..."
for file in "agents.md" \
            ".harness/agents/leader.md" \
            ".harness/agents/spec_author.md" \
            ".harness/agents/implementer.md" \
            ".harness/agents/reviewer.md" \
            "specs/mission.md" \
            "specs/tech-stack.md" \
            "specs/roadmap.md"; do
    if [ -f "$file" ]; then
        echo "  ✓ $file"
    else
        echo "  ✗ $file — NO ENCONTRADO"
        FAIL=1
    fi
done

# 3. Dependencias del proyecto
echo "[3/5] Verificando dependencias..."
if command -v docker &>/dev/null; then
    echo "  ✓ docker $(docker --version)"
else
    echo "  ✗ docker — NO INSTALADO"
    FAIL=1
fi

if command -v psql &>/dev/null; then
    echo "  ✓ psql $(psql --version)"
else
    echo "  ⚠ psql — NO INSTALADO (opcional si Supabase no está desplegado)"
fi

if command -v python3 &>/dev/null; then
    echo "  ✓ python3 $(python3 --version 2>&1)"
else
    echo "  ✗ python3 — NO INSTALADO"
    FAIL=1
fi

# 4. Tests actuales (si existen)
echo "[4/5] Verificando tests..."
if [ -f "Makefile" ]; then
    echo "  → Makefile encontrado, ejecutando 'make test'..."
    make test && echo "  ✓ tests pasan" || { echo "  ✗ tests FALLAN"; FAIL=1; }
elif ls tests/ test/ *.test.* 2>/dev/null | head -1 &>/dev/null; then
    echo "  ⚠ Tests encontrados pero sin Makefile — ejecución manual requerida"
else
    echo "  ⚠ No hay tests definidos aún — OK para proyecto en fase inicial"
fi

# 5. Estado del progreso
echo "[5/5] Verificando progreso..."
if [ -f "progress/history.md" ]; then
    echo "  ✓ progress/history.md existe"
    LAST_ENTRY=$(grep "^## " progress/history.md | tail -1)
    echo "  Última entrada: ${LAST_ENTRY:-ninguna}"
else
    echo "  ⚠ progress/history.md no existe — se creará al iniciar"
fi

echo ""
if [ $FAIL -eq 0 ]; then
    echo "=== ✓ INIT OK — Entorno listo para SDD ==="
else
    echo "=== ✗ INIT FAIL — Corrige los errores antes de continuar ==="
    exit 1
fi
