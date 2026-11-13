---
name: explicar-modulo
description: Explica de forma didáctica, en español, un módulo del proyecto dam2_2627_a (arquitectura, navegación, Firestore, autenticación, Storage, mapa/GPS, API HTTP, Cloud Functions, push FCM, Stripe, NFC, tema). Úsala cuando un alumno pregunte cómo funciona una parte de la app o pida un repaso de un tema.
---

# Explicar un módulo

## 1. Localiza el material

- Busca la guía del módulo en `docs/README.md` (índice) y léela entera.
- Abre los archivos de la tabla "📁 Archivos implicados" de esa guía y confirma que el código sigue
  igual. Usa Read o `awk '{print NR": "$0}' fichero` para obtener números de línea fiables.

## 2. Estructura de la explicación (siempre en este orden)

1. **La idea en una frase** — qué problema resuelve el módulo.
2. **Analogía** — algo cotidiano (ej.: un webhook es "Stripe llamándote por teléfono cuando el pago termina").
3. **Mapa** — un diagrama Mermaid pequeño (5-8 nodos) con quién llama a quién.
4. **Recorrido por el código** — 3-6 pasos numerados, cada uno con `archivo:línea` y un
   fragmento corto (máx. 10 líneas).
5. **Qué puede fallar** — un fallo conocido de la sección 🐞 de la guía, explicado como "qué pasa · por qué".
6. **Pregunta de comprobación** — una pregunta para que el alumno piense, sin dar la respuesta.

## 3. Adapta el nivel

- Si el alumno usa palabras como "no entiendo nada", empieza por el glosario (`docs/13-glosario.md`)
  y quita el código del paso 4.
- Si el alumno ya sabe, ve directo a los pasos 4-5 y propone un ejercicio de la sección 🛠 de la guía.

## 4. Si la guía está desactualizada

Explica según el código real, señala la diferencia al alumno y ofrece ejecutar `documentar-cambios`.
