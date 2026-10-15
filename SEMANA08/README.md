# Semana 08: Culturas Peruanas en tres niveles

**Alumno:** Pablo Isla Arone  
**Curso:** Programación en Móviles Avanzado  
**Docente:** Juan León

---

## Rama `ai-assisted`

### ¿Qué cambió respecto al Lab07?
En el Lab07 la app tenía dos pantallas: la lista de culturas y el detalle de cada una. Ahora la navegación tiene **tres niveles**, todos dentro de un **Navigation Controller**:

```
Pantalla 1: Culturas del Perú          (ViewController)
   │  tocas una cultura → segue "showElementos"
   ▼
Pantalla 2: Lo que ofrece la cultura   (ElementosViewController)
   │  tocas un elemento → segue "showDetalle"
   ▼
Pantalla 3: Detalle del elemento       (DetalleViewController)
```

* **Pantalla 1:** lista de las 6 culturas (Caral, Chavín, Paracas, Nazca, Moche e Inca) con imagen y nombre, en una celda personalizada (`CulturaTableViewCell`).
* **Pantalla 2:** lo que ofrece la cultura elegida: sitios arqueológicos, esculturas, textilería, cerámica, etc. Cada fila usa el estilo **Subtitle** (nombre y tipo) con una imagen.
* **Pantalla 3:** imagen, nombre, tipo, cultura y región, y una descripción del elemento.

### ¿Cómo viajan los datos?
1. En la pantalla 1, `didSelectRowAt` llama a `performSegue(withIdentifier: "showElementos", sender: indexPath)` y `prepare(for:sender:)` envía la **cultura** completa a `ElementosViewController`.
2. En la pantalla 2, la tabla se llena con `cultura.elementos`. Al tocar uno, `prepare(for:sender:)` envía la **cultura** y el **elemento** a `DetalleViewController`.
3. La pantalla 3 solo lee esos dos objetos en `viewDidLoad` y llena sus labels.

### Modelo de datos
* `Cultura` (nombre, región, imagen y un arreglo `elementos`).
* `Elemento` (nombre, tipo, descripción y nombre de su imagen).
* `DatosCulturas.swift` guarda la lista completa, para que los ViewControllers no queden llenos de datos.
* Si la imagen de un elemento no está en Assets, `cultura.imagenDe(elemento)` usa la imagen de la cultura, así que la app nunca muestra una imagen vacía.

### Commits de esta semana
1. `feat: Semana 08 - segunda pantalla con lo que ofrece cada cultura`: modelo `Elemento`, datos y la pantalla 2.
2. `feat: Semana 08 - tercera pantalla con el detalle de cada elemento`: `DetalleViewController`, el segue `showDetalle`, este README y la guía del Storyboard.

**Guía del Storyboard:** [GUIA_STORYBOARD.md](GUIA_STORYBOARD.md)
