---
name: documentar-cambios
description: Detecta cambios en este proyecto Flutter y sincroniza README.md y docs/ con el comportamiento, la configuración y la estructura reales. Úsala al terminar cambios relevantes o cuando se pida actualizar la documentación.
---

# Documentar cambios del proyecto

Revisa el estado del repositorio con `git status --short`, `git diff` y `git diff --cached`. Compara también con la rama base si la tarea trata de una rama o un PR. Incluye archivos nuevos sin seguimiento que pertenezcan a la tarea. Distingue los cambios de la tarea de los cambios locales previos.

Contrasta los cambios con el código y la configuración actuales antes de escribir. Para este proyecto, revisa según corresponda `lib/`, `pubspec.yaml`, `test/` y la configuración de plataformas. Los archivos generados y las credenciales no son fuentes para copiar valores sensibles al README.

Actualiza `README.md` cuando cambien la puesta en marcha, las funciones visibles, la navegación, la arquitectura, las dependencias o la estructura descrita allí. Usa `docs/` para explicaciones técnicas que necesiten más detalle y enlázalas desde el README cuando sean útiles. Mantén el español, el tono didáctico y la estructura existente; edita las secciones afectadas en vez de duplicarlas.

Si el cambio no tiene impacto documental, deja los documentos intactos e indícalo brevemente. Si falta evidencia para afirmar algo, descríbelo como pendiente de verificar. No modifiques código de aplicación para hacer coincidir una afirmación documental.

Antes de terminar, comprueba que los enlaces y comandos añadidos sean correctos y revisa el diff de la documentación para detectar afirmaciones obsoletas o contradictorias. Resume qué documentos actualizaste y qué cambios motivaron la actualización.
