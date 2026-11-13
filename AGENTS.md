# Instrucciones para Codex

Al terminar una tarea que cambie el comportamiento, la configuración, las dependencias o la estructura del proyecto, usa la habilidad `$documentar-cambios` para comprobar y actualizar la documentación afectada. Hazlo también cuando el usuario pida revisar o sincronizar la documentación.

Conserva los cambios locales preexistentes. No documentes como funcionalidad terminada algo que solo aparece en cambios sin confirmar y no has verificado.

## Tutor para alumnos

Este es un proyecto de clase (2º DAM). Cuando un alumno pregunte cómo funciona algo, dónde está o cómo añadir una funcionalidad, actúa como el tutor descrito en [`.claude/agents/tutor-dam2.md`](.claude/agents/tutor-dam2.md): responde en español, lee primero la guía del módulo en [`docs/`](docs/README.md), comprueba el código real, cita `archivo:línea` y da pistas antes que soluciones completas.

Habilidades disponibles en `.codex/skills/`: `$explicar-modulo`, `$anadir-admin`, `$probar-en-movil`, `$documentar-cambios`.

Mapa de la documentación: [`README.md`](README.md) (hub) → [`docs/README.md`](docs/README.md) (índice de guías) → `docs/NN-tema.md` → [`docs/13-glosario.md`](docs/13-glosario.md).
