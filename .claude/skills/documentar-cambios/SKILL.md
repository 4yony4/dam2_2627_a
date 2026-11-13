---
name: documentar-cambios
description: Detecta cambios en este proyecto Flutter y sincroniza README.md y docs/ con el comportamiento, la configuración y la estructura reales. Úsala al terminar cambios relevantes o cuando se pida actualizar la documentación.
---

# Documentar cambios del proyecto

Revisa el estado del repositorio con `git status --short`, `git diff` y `git diff --cached`. Compara también con la rama base si la tarea trata de una rama o un PR. Incluye archivos nuevos sin seguimiento que pertenezcan a la tarea. Distingue los cambios de la tarea de los cambios locales previos.

Contrasta los cambios con el código y la configuración actuales antes de escribir. Para este proyecto, revisa según corresponda `lib/`, `functions/`, `pubspec.yaml`, `test/`, `android/` (manifest, Kotlin) y la configuración de Firebase (`firebase.json`, reglas). Los archivos generados y las credenciales no son fuentes para copiar valores sensibles: nunca copies claves, tokens, IDs de proyecto ni huellas SHA.

## Dónde va cada cosa

- `README.md` es el **hub**: qué hace la app, puesta en marcha, mapa del proyecto, línea de tiempo, tabla de guías, estructura de carpetas, dependencias, fallos conocidos y ejercicios generales. Actualízalo cuando cambien esas secciones; no metas detalle técnico largo.
- `docs/NN-tema.md` son las **guías por módulo** (01 arquitectura … 12 tema). Cada una sigue la misma plantilla: 🎯 Qué vas a aprender · 🧠 Conceptos clave · 📁 Archivos implicados · 🗺 Diagramas · 👣 Paso a paso · ⚙️ Configuración · 🧪 Cómo probarlo · 🐞 Fallos conocidos · 🛠 Ejercicios · ❓ Autoevaluación. Edita la guía afectada en vez de duplicar contenido.
- Un módulo nuevo → nueva guía con el siguiente número, enlazada desde `docs/README.md` (tabla y ruta de aprendizaje), desde la tabla "Guías por módulo" del `README.md` y, si procede, en la línea de tiempo.
- Términos nuevos → `docs/13-glosario.md`, con ancla explícita `### <a id="termino"></a>Término` (sin tildes en el id).
- Los números `archivo:línea` deben comprobarse con la herramienta Read o `awk '{print NR": "$0}'` (un filtro de shell puede quitar comentarios de `cat`/`grep` y descuadrar las líneas).
- Diagramas en Mermaid compatible con GitHub (etiquetas con caracteres especiales entre comillas, sin `click`).

Mantén el español, el tono didáctico y la estructura existente.

Si el cambio no tiene impacto documental, deja los documentos intactos e indícalo brevemente. Si falta evidencia para afirmar algo, descríbelo como pendiente de verificar. No modifiques código de aplicación para hacer coincidir una afirmación documental.

Antes de terminar, comprueba que los enlaces relativos y comandos añadidos sean correctos y revisa el diff de la documentación para detectar afirmaciones obsoletas o contradictorias. Resume qué documentos actualizaste y qué cambios motivaron la actualización.
