# Guía rápida para armar el Storyboard en la Mac

El código `.swift` ya está en este repo. En la Mac solo hay que crear el proyecto, copiar los archivos y conectar el Storyboard.

## Caso: Culturas Peruanas — proyecto `Semana07_C`
1. Xcode > New Project > iOS App > Interface: **Storyboard**, Language: **Swift**. Nombre: `Semana07_C`.
2. Arrastra 6 imágenes a **Assets** con estos nombres exactos: `caral`, `chavin`, `paracas`, `nazca`, `moche`, `inca`. Si vienen en `.webp` o `.avif`, conviértelas a PNG primero.
3. New File > Cocoa Touch Class:
   - `Cultura` (subclase de **NSObject**)
   - `CulturaTableViewCell` (subclase de **UITableViewCell**, sin XIB)
   - `DetalleViewController` (subclase de **UIViewController**)

### Pantalla 1: Lista
4. Selecciona el View Controller > `Editor > Embed In > Navigation Controller`.
5. Agrega un **Table View** con constraints de **0** en los 4 lados, **Prototype Cells = 1** y **Row Height = 90**.
6. Celda > **Identifier:** `culturaCell`; Identity Inspector > **Class:** `CulturaTableViewCell` (en la **celda**, no en la tabla).
7. Dentro de la celda: **Image View** de 70×70 (Aspect Fill + Clips to Bounds) y un **Label** a la derecha.
8. Conecta **dataSource** y **delegate** del Table View al View Controller.

### Pantalla 2: Detalle
9. Arrastra un **View Controller** nuevo > Identity Inspector > **Class:** `DetalleViewController`.
10. Agrega un **Image View** (Aspect Fill, Clips to Bounds) y tres **Label**: nombre (Bold 24), región y descripción (**Lines = 0**).
11. Selecciona los 4 > **Embed In > Stack View** (Spacing 12) con constraints arriba, izquierda y derecha de **20**. Al Image View, **Height = 220**.

### Segue y outlets
12. Ctrl + arrastrar desde el **ícono amarillo** de la lista hasta el Detalle > **Show**. Selecciona el segue > **Identifier:** `showDetalle`.
13. Outlets de la celda (a `CulturaTableViewCell`): `celdaImagen`, `celdaNombre`.
14. Outlets del detalle (a `DetalleViewController`): `imgCultura`, `lblNombre`, `lblRegion`, `lblDescripcion`.
15. Pega el código de `Semana07_C/`, ejecuta (⌘R) y toca una cultura.

> **Si algo falla:**
> * Crash al abrir: revisa el Identifier `culturaCell` y que la Class esté en la celda.
> * Tocas una fila y no pasa nada: falta el **delegate** o el segue no se llama exactamente `showDetalle`.
> * Crash al abrir el detalle: algún outlet de `DetalleViewController` quedó sin conectar (círculo vacío ○).
