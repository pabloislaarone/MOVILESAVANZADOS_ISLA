# Laboratorio 06: ViewControllers – Navegación Modal – Segues

**Alumno:** Pablo Isla Arone  
**Curso:** Programación en Móviles Avanzado  
**Docente:** Juan León

---

## Rama `manual`

### Primera parte: Navigation Controller y segue Show (`Semana06/`)
Se creó un proyecto UIKit con dos pantallas. A la PANTALLA 01 se le agregó el ícono de TECSUP en `Assets > AppIcon`, luego se incrustó en un **Navigation Controller** (`Editor > Embed In > Navigation Controller`) y, desde un Bar Button Item "A Pantalla 2", se creó un segue **Show** hacia la PANTALLA 02, controlada por `ViewController2`.

**Evidencias:**
![icono](evidencias/evidencia01.png)
![navegacion](evidencias/evidencia02.png)

**16. ¿Qué cambio pudo notar en el diseño de la vista 1?**  
Al incrustarla en el Navigation Controller, la vista 1 deja de ser la pantalla inicial (la flecha pasa al Navigation Controller) y, además, en la parte superior aparece una **barra de navegación** con espacio para un título y botones. Por eso luego se puede colocar ahí el botón "A Pantalla 2".

**17. ¿Para qué sirve un Navigation Controller?**  
Básicamente, es un contenedor que administra una **pila de pantallas**. Cada vez que se navega con Show, la nueva pantalla se apila encima y, al mismo tiempo, se genera de forma automática el botón **Back** para regresar. En otras palabras, permite una navegación jerárquica (de lo general a lo específico), como en Ajustes del iPhone, sin tener que programar el regreso a mano.

**29. ¿Para qué sirven Show, Show Detail, Present Modally y Present As Popover?**
* **Show:** apila la pantalla dentro del Navigation Controller y muestra el botón Back. Es la navegación normal "hacia adelante".
* **Show Detail:** se usa con un Split View Controller; en iPad reemplaza el panel de detalle (derecha) y, en cambio, en iPhone se comporta parecido a Show.
* **Present Modally:** muestra la pantalla por encima de la actual, fuera de la pila de navegación. Sirve para tareas puntuales (un formulario, una confirmación) y se cierra con `dismiss`.
* **Present As Popover:** en iPad muestra una ventanita flotante que apunta al botón que la abrió; en iPhone, por defecto, se ve como un modal.

### Ventanas modales (`Semana06_02/`)
Se creó la clase `ClienteModel` (subclase de `NSObject`) para agrupar los datos del cliente. En la pantalla "DATOS DEL CLIENTE" se arma el objeto con los `UITextField` y se abre la pantalla "DATOS INGRESADOS" de forma **modal** usando `instantiateViewController(identifier:)` y `present`. Para que funcione, la segunda pantalla tiene como **Storyboard ID** `ViewControllerConfirmacion`. Además, se agregó el botón **Volver**, que cierra el modal con `dismiss(animated:)`.

**Evidencias:**
![datos cliente](evidencias/evidencia03.png)
![datos ingresados](evidencias/evidencia04.png)

---

> Las capturas se agregan en `evidencias/` después de ejecutar en el simulador. Los pasos del Storyboard están en [GUIA_STORYBOARD.md](GUIA_STORYBOARD.md).
