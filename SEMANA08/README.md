# Semana 08: Culturas Peruanas en tres pantallas

**Alumno:** Pablo Isla Arone  
**Curso:** Programación en Móviles Avanzado  
**Docente:** Juan León

---

## Rama `manual`

Proyecto de Xcode: `Semana08/` (UIKit + Storyboard).

En el Lab07 la app tenía dos pantallas: la lista de culturas y el detalle de cada una. Ahora la navegación tiene **tres niveles** dentro de un **Navigation Controller**:

```
Pantalla 1: Culturas del Perú        (ViewController)
   │  tocas una cultura → segue "showElementos"
   ▼
Pantalla 2: Lo que ofrece la cultura (ElementosViewController)
   │  tocas un elemento → segue "showDetalle"
   ▼
Pantalla 3: Detalle del elemento     (DetalleViewController)
```

* **Pantalla 1:** lista de las 6 culturas (Caral, Chavín, Paracas, Nazca, Moche e Inca), con una celda personalizada `CulturaTableViewCell` (imagen y nombre).
* **Pantalla 2:** lo que ofrece la cultura elegida, como sitios arqueológicos, esculturas, textilería o cerámica, en una celda de estilo **Subtitle** (nombre, tipo e imagen).
* **Pantalla 3:** imagen, nombre, tipo, cultura y región, y la descripción del elemento.

### ¿Cómo viajan los datos?
1. En la pantalla 1, `didSelectRowAt` llama a `performSegue(withIdentifier: "showElementos", sender: indexPath)`, y `prepare(for:sender:)` envía la **cultura** a `ElementosViewController`.
2. En la pantalla 2, la tabla se llena con `cultura.elementos`. Al tocar uno, `prepare(for:sender:)` envía la **cultura** y el **elemento** a `DetalleViewController`.
3. La pantalla 3 lee esos objetos en `viewDidLoad` y llena sus labels.

### Modelo
* `Cultura`: nombre, región, imagen y el arreglo `elementos`.
* `Elemento`: nombre, tipo, descripción y nombre de su imagen.
* `DatosCulturas.swift`: la lista completa de culturas con lo que ofrece cada una.

### Commits
1. `feat: Semana 08 - segunda pantalla con lo que ofrece cada cultura`
2. `feat: Semana 08 - tercera pantalla con el detalle de cada elemento`
