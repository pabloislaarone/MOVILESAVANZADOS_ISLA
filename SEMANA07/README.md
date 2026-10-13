# Laboratorio 07: Manejo de Datos – Tablas y Colecciones

**Alumno:** Pablo Isla Arone  
**Curso:** Programación en Móviles Avanzado  
**Docente:** Juan León

---

## Rama `ai-assisted`

### Caso a desarrollar: Culturas Peruanas (`Semana07_C/`)
App en UIKit para explorar culturas peruanas. Tiene dos pantallas dentro de un **Navigation Controller**:

* **Pantalla 1 – Lista de Culturas Peruanas:** un `UITableView` con una celda personalizada (`CulturaTableViewCell`) que muestra la **imagen** y el **nombre** de cada cultura: Caral, Chavín, Paracas, Nazca, Moche e Inca.
* **Pantalla 2 – Detalle de la Cultura (`DetalleViewController`):** muestra la **imagen**, el **nombre**, la **región** y una **descripción** breve.

**¿Cómo se pasa de una vista a otra?** Al tocar una fila, `didSelectRowAt` llama a `performSegue(withIdentifier: "showDetalle", sender: indexPath)`. Luego, en `prepare(for:sender:)` se toma el `indexPath`, se busca la cultura en `listaCulturas` y se le asigna a la propiedad `cultura` de `DetalleViewController`. Así, la pantalla de detalle solo tiene que leer ese objeto en `viewDidLoad` y llenar sus labels.

Los datos de cada cultura se guardan en la clase modelo `Cultura` (subclase de `NSObject`), siguiendo el mismo patrón de `Profesor` en la parte A.

**Conexiones en el Storyboard:**
* Celda `culturaCell` (Class `CulturaTableViewCell`): `celdaImagen`, `celdaNombre`.
* Detalle (`DetalleViewController`): `imgCultura`, `lblNombre`, `lblRegion`, `lblDescripcion`, dentro de un Stack View.
* Segue **Show** desde el View Controller de la lista hasta el detalle, con identifier `showDetalle`.

**Evidencias:**

Storyboard: Navigation Controller → Lista → Detalle, unidos por el segue `showDetalle`:
![storyboard](evidencias/evidencia01.png)

Pantalla 1, lista de culturas con su imagen:
![lista](evidencias/evidencia02.png)

Pantalla 2, detalle de Caral:
![detalle caral](evidencias/evidencia03.png)

Pantalla 2, detalle de Moche:
![detalle moche](evidencias/evidencia04.png)

**Guía del Storyboard:** [GUIA_STORYBOARD.md](GUIA_STORYBOARD.md)

**Nota:** los prompts y la comparación con la IA están en [PROMPTS.md](PROMPTS.md).

---

## Conclusiones

**1.** El `UITableView` es la forma más práctica de mostrar listas de datos en UIKit. Funciona gracias a dos protocolos: `UITableViewDataSource`, que le dice a la tabla cuántas filas tiene y qué va en cada celda, y `UITableViewDelegate`, que responde a lo que hace el usuario, como tocar una fila. Además, gracias a `dequeueReusableCell` y al Identifier de la celda prototipo, la app reutiliza las celdas en lugar de crear una nueva por cada elemento, así que ahorra memoria aunque la lista sea grande.

**2.** Organizar los datos en una clase modelo hace que el código sea más ordenado y fácil de ampliar. En este laboratorio, las clases `Profesor` y `Cultura` agrupan en un solo objeto el nombre, el cargo o la región, la descripción y la imagen; por eso, agregar un campo nuevo, como la foto, solo exigió cambiar la clase y la línea que llena la celda. También comprobamos que las imágenes deben estar en Assets con el nombre exacto que se usa en `UIImage(named:)`; de lo contrario, simplemente no se muestran.

**3.** Personalizar la celda y navegar a una vista de detalle permite crear apps más completas. Al crear `PersonasTableViewCell` y `CulturaTableViewCell` aprendimos que los outlets de los controles de la celda deben conectarse a la clase de la celda y no al ViewController, porque Xcode lo marca como error. Por otro lado, con `didSelectRowAt`, `performSegue` y `prepare(for:sender:)` pudimos pasar la cultura seleccionada a una segunda pantalla, igual que en el Lab06, pero esta vez a partir de una fila de la tabla.

---

> Las partes A y B del laboratorio (lista de profesores y TableView personalizado) están en la rama `manual`.
