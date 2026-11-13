# Instrucciones para Claude Code

Sigue las mismas reglas que [`AGENTS.md`](AGENTS.md):

- Al terminar un cambio de comportamiento, configuración, dependencias o estructura, usa la habilidad `documentar-cambios`.
- Conserva los cambios locales preexistentes y no documentes como terminado lo que no has verificado.
- Proyecto de clase (2º DAM): responde en español. Para preguntas de alumnos usa el agente `tutor-dam2` (`claude --agent tutor-dam2`) y las habilidades de [`.claude/skills/`](.claude/skills/): `explicar-modulo`, `anadir-admin`, `probar-en-movil`, `documentar-cambios`.
- Documentación: [`README.md`](README.md) (hub) → [`docs/README.md`](docs/README.md) (índice de guías) → `docs/NN-tema.md` → [`docs/13-glosario.md`](docs/13-glosario.md).
- Nunca copies claves (Stripe, Firebase), tokens, IDs de proyecto ni datos personales a la documentación.
