---
name: worktree-manager
description: >
  Gestiona git worktrees para desarrollo paralelo de features. Usar cuando el
  usuario quiera trabajar en varias features simultáneamente, crear un worktree
  para una feature específica, listar worktrees activos, o eliminar worktrees
  terminados. Triggers: "worktree", "features en paralelo", "trabajar en paralelo",
  "nueva rama aislada", "crear worktree para", "limpiar worktrees", "worktree para X".
allowed-tools: "Bash(git worktree *), Bash(git branch *), Bash(mkdir *), Bash(ls *), Bash(git status *)"
---

# Worktree Manager

Git worktrees permiten tener múltiples branches del mismo repo en diferentes directorios simultáneamente, sin necesidad de hacer stash o switch. Ideal para implementar varias features en paralelo con Claude Code.

## Detectar la operación solicitada

Antes de ejecutar cualquier comando, identificar qué quiere hacer el usuario:

- **Crear**: "crear worktree para X", "nueva feature aislada", "trabajar en paralelo en X"
- **Listar**: "ver worktrees", "qué worktrees hay", "listar worktrees activos"
- **Eliminar**: "eliminar worktree X", "ya terminé con X", "limpiar worktree de X"
- **Limpiar stale**: "limpiar worktrees viejos", "prune worktrees"
- **Múltiples features**: el usuario menciona 2+ features a desarrollar simultáneamente

## Operaciones

### CREAR un worktree

```bash
# 1. Verificar que estamos en el repo raíz
git rev-parse --show-toplevel

# 2. Crear el directorio base si no existe
mkdir -p .worktrees

# 3. Crear worktree con nueva branch desde develop (o main si no hay develop)
git worktree add .worktrees/<feature-name> -b feature/<feature-name>

# Si la branch ya existe (fue creada antes):
git worktree add .worktrees/<feature-name> feature/<feature-name>
```

**Naming convention**:
- Worktree path: `.worktrees/<feature-name>` (relativo al root del repo)
- Branch name: `feature/<feature-name>` (kebab-case)
- Ejemplos: `feature/auth-social`, `feature/pdf-export`, `feature/dark-mode`

**Edge cases**:
- Si la branch ya existe: usar sin flag `-b`
- Si el worktree path ya existe: preguntar si sobreescribir o usar nombre diferente
- Base branch: usar `develop` si existe, sino `main`

### LISTAR worktrees activos

```bash
git worktree list
```

Mostrar en formato amigable:
```
Worktrees activos:
  [main]        /ruta/repo          HEAD abc1234 (main)
  [auth-social] /ruta/.worktrees/auth-social  HEAD def5678 [feature/auth-social]
  [pdf-export]  /ruta/.worktrees/pdf-export   HEAD ghi9012 [feature/pdf-export]
```

También mostrar el estado de cada worktree:
```bash
# Ver si hay cambios sin commitear en cada worktree
git -C .worktrees/<feature-name> status --short
```

### ELIMINAR un worktree

```bash
# 1. Asegurarse que no hay cambios sin commitear
git -C .worktrees/<feature-name> status --short

# 2. Eliminar el worktree
git worktree remove .worktrees/<feature-name>

# 3. Opcional: eliminar la branch si ya fue mergeada
git branch -d feature/<feature-name>
# Si hay error "not fully merged", preguntar al usuario antes de usar -D
```

**Antes de eliminar**: verificar si hay cambios sin commitear. Si los hay, advertir al usuario y preguntar si quiere proceder.

### LIMPIAR worktrees stale

```bash
# Eliminar referencias a worktrees que ya no existen en el filesystem
git worktree prune

# Luego verificar estado
git worktree list
```

### MÚLTIPLES features en paralelo

Cuando el usuario quiere trabajar en 2+ features simultáneamente, crear todos los worktrees de una vez:

```bash
# Para cada feature mencionada:
git worktree add .worktrees/<feature-1> -b feature/<feature-1>
git worktree add .worktrees/<feature-2> -b feature/<feature-2>
# etc.
```

## Cómo abrir un worktree en nueva sesión Claude Code

Después de crear un worktree, siempre informar al usuario cómo trabajar en él:

```
Para trabajar en esta feature con Claude Code, abre una nueva sesión:

  Opción 1 (terminal):
    cd .worktrees/<feature-name>
    claude

  Opción 2 (VS Code):
    code .worktrees/<feature-name>
    # Luego iniciar Claude Code en esa ventana

  Opción 3 (desde el IDE actual):
    Archivo > Abrir carpeta > seleccionar .worktrees/<feature-name>
```

## Flujo completo para "múltiples features en paralelo"

1. Preguntar cuántas features y sus nombres (si no los dio)
2. Verificar que el repo está limpio o advertir sobre cambios pendientes
3. Crear todos los worktrees
4. Mostrar resumen con paths y cómo abrirlos
5. Sugerir agregar `.worktrees/` al `.gitignore` si no está

```bash
# Verificar .gitignore
grep -q "\.worktrees" .gitignore 2>/dev/null || echo ".worktrees/" >> .gitignore
```

## Output esperado al crear

```
✅ Worktree creado exitosamente

  Feature:  auth-social
  Branch:   feature/auth-social
  Path:     .worktrees/auth-social
  Base:     develop (HEAD abc1234)

Para trabajar en esta feature:
  cd .worktrees/auth-social && claude
```

## Notas importantes

- Los worktrees comparten el mismo repositorio git — los cambios en `.git/` son visibles desde todos
- No se puede hacer checkout de la misma branch en dos worktrees simultáneamente
- El directorio `.worktrees/` no debería commitearse — debe estar en `.gitignore`
- Los worktrees creados con este comando son para desarrollo humano, no para agentes Claude (que usan `.claude/worktrees/`)
