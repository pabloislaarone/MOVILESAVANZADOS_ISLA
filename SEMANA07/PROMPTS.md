# Prompts utilizados
Laboratorio 07

## Herramienta de IA utilizada
Claude

## Caso a desarrollar: Culturas Peruanas

### Prompt (estructura CTRFE)

**Contexto:**
Soy estudiante de Programación en Móviles Avanzado, semana 7. Trabajo en Xcode con UIKit y Storyboard. En el laboratorio ya hice una lista de profesores con `UITableView` (celda Subtitle y clase `Profesor`) y una celda personalizada `PersonasTableViewCell` con imagen, label y una alerta en `didSelectRowAt`. En el Lab06 pasé datos entre pantallas con un segue y `prepare(for:sender:)`.

**Tarea:**
Desarrollar una app que permita explorar culturas peruanas:
1. **Pantalla 1:** un `UITableView` con una celda personalizada que muestre el **nombre** y una **imagen representativa** de cada cultura.
2. **Pantalla 2:** al seleccionar una celda, navegar a una vista de detalle con **nombre**, **región**, **descripción breve** e **imagen**.
3. Usar una clase modelo `Cultura` y pasar la cultura seleccionada a la pantalla de detalle.

**Restricciones:**
Solo lo visto hasta la semana 7: clases que heredan de `NSObject`, `UITableViewDelegate` / `UITableViewDataSource`, celdas personalizadas, Navigation Controller, segue con identifier y `prepare(for:sender:)`. Nada de SwiftUI, Codable ni datos desde internet; las imágenes van en Assets.

**Formato:**
Los archivos Swift completos (`Cultura.swift`, `CulturaTableViewCell.swift`, `DetalleViewController.swift`, `ViewController.swift`) con comentarios cortos, los nombres de los outlets que debo conectar y los pasos del Storyboard.

**Ejemplo:**
Al tocar "Caral" en la lista, debe abrirse el detalle con su imagen, "Caral", "Región: Lima (valle de Supe, Barranca)" y una descripción corta.

### Respuesta de la IA
Generó los cuatro archivos. La clase `Cultura` sigue el mismo estilo que `Profesor` (subclase de `NSObject` con un `init` con parámetros). Para la navegación, propuso crear el segue **desde el View Controller** (ícono amarillo) y no desde la celda, y lanzarlo con `performSegue(withIdentifier: "showDetalle", sender: indexPath)` dentro de `didSelectRowAt`. Así, en `prepare(for:sender:)` el `indexPath` llega como `sender` y no hace falta crear un outlet de la tabla.

También explicó cómo acomodar la pantalla de detalle rápido con un **Stack View** y por qué el label de la descripción debe tener **Lines = 0**.

### ¿Funcionó a la primera?
Casi. Al principio la lista salió **sin imágenes**, pero no era un error del código: todavía no había agregado las fotos a **Assets**. Cuando las coloqué con los nombres `caral`, `chavin`, `paracas`, `nazca`, `moche` e `inca`, la lista y el detalle funcionaron bien.

Un detalle de diseño: en algunas culturas, como Moche, la imagen ocupa mucho alto y la descripción se corta con "…". Se arregla bajando la altura del Image View o poniendo el contenido dentro de un Scroll View.

### ¿Usó algo que no hemos visto en clase?
* `performSegue(withIdentifier:sender:)` para lanzar el segue por código. En el Lab06 el segue salía directo de un botón.
* `if let cultura = cultura` para leer de forma segura el objeto opcional que llega al detalle.
* `tableView.deselectRow(at:animated:)` para que la fila no quede marcada en gris al regresar.

### ¿Qué hizo distinto la IA?
* **Usó una clase modelo** en vez de varios arreglos separados (como en la parte B), lo que hace más fácil agregar la región y la descripción.
* **Mandó el `indexPath` como `sender`** del segue, en lugar de buscar la fila seleccionada desde un outlet de la tabla.
* **Agregó títulos** a las pantallas ("Culturas del Perú" y "Detalle") con `title`, aprovechando la barra del Navigation Controller.
