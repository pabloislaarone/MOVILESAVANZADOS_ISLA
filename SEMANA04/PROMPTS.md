# Prompts utilizados
Laboratorio 04

## Herramienta de IA utilizada
Gemini

## Caso 2B Biblioteca

### Prompt 1:
Soy estudiante de Swift, cuarta semana, trabajo en un Playground de Xcode. Necesito una biblioteca con enum EstadoLibro, struct Libro y class Biblioteca con prestar, devolver e inventario. Solo struct, class, herencia, protocolos, enums, arrays, bucles y funciones. Sin optionals ni guard let, sin firstIndex(where:), sin didSet, sin propiedades calculadas, sin genéricos. Solo el código Swift, con las firmas exactas que te indico.
Salida esperada:
Préstamo aprobado: La ciudad y los perros
Error: La ciudad y los perros ya está prestado
Devolución registrada: La ciudad y los perros
Préstamo aprobado: El Quijote
Error: no existe El Principito
===== INVENTARIO =====
Cien años de soledad (Gabriel García Márquez) - disponible
La ciudad y los perros (Mario Vargas Llosa) - disponible
El Quijote (Miguel de Cervantes) - prestado

### Respuesta de la IA:
Me generó exactamente la estructura solicitada, respetando las restricciones de no usar closures ni optionals, e iterando el arreglo de libros con un bucle for-in basado en índices para mutar el estado.

### ¿Funcionó a la primera?
Sí, funcionó a la primera porque el prompt fue bastante restrictivo respecto a los métodos avanzados de Swift, evitando que la IA use código que aún no hemos visto.

### ¿Usó algo que no hemos visto en clase?
No, gracias a las restricciones impuestas en el prompt, la IA se limitó a utilizar `for i in 0..<libros.count` y un `switch` clásico.

## Mi versión (Parte A) vs. la versión de la IA (Parte B)

### ¿Qué hizo distinto la IA respecto a mi solución?
La lógica fue idéntica. La IA se apegó al recorrido por índices para mutar el struct dentro del array, tal como yo lo resolví en la rama manual siguiendo las indicaciones de clase.

### ¿Hay alguna línea de la IA que no entiendo del todo? ¿Cuál?
No, el código resultante utiliza únicamente conceptos de control de flujo básicos y manejo directo de colecciones por índice que entiendo perfectamente.

### ¿Qué me pareció mejor de MI versión?
Mi versión la estructuré con mayor comprensión natural de las reglas de negocio desde el inicio, sin necesidad de ser sobre-específico con una máquina.

### ¿Qué me pareció mejor de la versión de la IA?
La versión de la IA tiene la ventaja de documentar automáticamente cada línea, lo cual agiliza la lectura del código por parte de terceros.