# Guía rápida para armar el Storyboard en la Mac

Se parte del proyecto del Lab07 (`Semana07_C`) o de uno nuevo llamado `Semana08` (Storyboard + Swift). El código está en `Semana08/`.

## Imágenes en Assets
* Culturas (las mismas del Lab07): `caral`, `chavin`, `paracas`, `nazca`, `moche`, `inca`.
* Elementos (**opcionales**: si falta alguna, se muestra la imagen de la cultura):

| Cultura | Imágenes |
|---|---|
| Caral | `caral_piramide`, `caral_anfiteatro`, `caral_intercambio` |
| Chavín | `chavin_templo`, `chavin_lanzon`, `chavin_cabezas` |
| Paracas | `paracas_mantos`, `paracas_trepanacion`, `paracas_necropolis` |
| Nazca | `nazca_lineas`, `nazca_acueductos`, `nazca_cahuachi` |
| Moche | `moche_huacas`, `moche_sipan`, `moche_huacos` |
| Inca | `inca_machupicchu`, `inca_sacsayhuaman`, `inca_qhapaqnan` |

## Commit 1: Pantalla 2 (lo que ofrece la cultura)
1. Archivos nuevos (Cocoa Touch Class o Swift File): `Elemento` (NSObject), `DatosCulturas` (Swift File), `ElementosViewController` (UIViewController). Reemplaza `Cultura.swift` y `ViewController.swift` por los de este repo.
   > Si partes del Lab07, **borra** el `DetalleViewController` viejo (Move to Trash) y también su pantalla en el Storyboard. El nuevo llega en el commit 2.
2. Arrastra un **View Controller** nuevo → Identity Inspector → **Class: `ElementosViewController`**.
3. Agrega un **Table View** con constraints de **0**, **Prototype Cells = 1** y **Row Height = 70**.
4. Celda → **Identifier: `elementoCell`**, **Style: Subtitle**.
5. Conecta **dataSource** y **delegate** del Table View a **Elementos View Controller**.
6. Segue: Control + arrastrar desde el **ícono amarillo** de la pantalla 1 hasta la pantalla 2 → **Show** → **Identifier: `showElementos`**.
7. Ejecuta: al tocar una cultura debe abrirse la lista con lo que ofrece. 📸 Captura.

## Commit 2: Pantalla 3 (detalle del elemento)
1. Crea `DetalleViewController` (UIViewController) y pega el código de este repo. Reemplaza también `ElementosViewController.swift`.
2. Arrastra un **View Controller** nuevo → **Class: `DetalleViewController`**.
3. Agrega un **Image View** (Aspect Fill, Clips to Bounds) y 4 **Labels**: nombre (Bold 24), tipo, cultura y descripción (**Lines = 0**).
4. Selecciona los 5 → **Embed In → Stack View** (Spacing 12) con constraints arriba, izquierda y derecha de **20**. Al Image View, **Height = 180**.
5. Conecta los outlets a `DetalleViewController`: `imgElemento`, `lblNombre`, `lblTipo`, `lblCultura`, `lblDescripcion`.
6. Segue: Control + arrastrar desde el **ícono amarillo** de la pantalla 2 hasta la pantalla 3 → **Show** → **Identifier: `showDetalle`**.
7. Ejecuta: Cultura → elemento → detalle. 📸 Capturas.

> **Si algo falla:**
> * Crash al abrir la pantalla 2: revisa el Identifier `elementoCell`.
> * Tocas una fila y no pasa nada: falta el **delegate** o el segue no se llama exactamente igual (`showElementos` / `showDetalle`).
> * Crash al abrir el detalle: algún outlet de `DetalleViewController` quedó sin conectar.
