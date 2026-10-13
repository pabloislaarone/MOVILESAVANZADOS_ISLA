# Guía rápida para armar el Storyboard en la Mac

El código `.swift` ya está en este repo. En la Mac solo hay que crear el proyecto, copiar los archivos y conectar el Storyboard.

## A. Lista de profesores — proyecto `Semana07_A`
1. Xcode > New Project > iOS App > Interface: **Storyboard**, Language: **Swift**. Nombre: `Semana07_A`.
2. `Main.storyboard`: arrastra un **Table View**, estíralo a los bordes y ponle constraints de **0** en los 4 lados (*Add New Constraints*).
3. Table View > Attributes Inspector > **Prototype Cells = 1**.
4. Selecciona la celda > **Identifier:** `celda`, **Style:** `Subtitle`.
5. Clic derecho sobre el Table View (en el Document Outline) y arrastra **dataSource** y **delegate** hasta el **View Controller** (ícono amarillo).
6. New File > Cocoa Touch Class > `Profesor` (subclase de **NSObject**). Pega el contenido de `Semana07_A/Profesor.swift`.
7. Reemplaza `ViewController.swift` por el de `Semana07_A/ViewController.swift`.
8. Arrastra las imágenes a **Assets** con los nombres `avatar1` … `avatar5`.
9. Ejecuta (⌘R) y toma las capturas.

## B. TableView personalizado — proyecto `Semana07_B`
1. Nuevo proyecto `Semana07_B` (Storyboard + Swift).
2. Table View con constraints de 0, **Prototype Cells = 1** y **Row Height = 80** (en la tabla y en la celda).
3. Celda > **Identifier:** `miCell`. Dentro de ella, un **Image View** (60×60, Aspect Fit) y un **Label**. Revisa en el Document Outline que queden dentro de *miCell > Content View*.
4. New File > Cocoa Touch Class > `PersonasTableViewCell` (subclase de **UITableViewCell**, sin XIB).
5. Selecciona la **celda** (no el Table View) > Identity Inspector > Class: `PersonasTableViewCell`.
6. Conecta los outlets **a la celda**: Image View > Connections Inspector > *New Referencing Outlet* > arrastrar hasta **miCell** > `PersonaImagen`; Label > `personaNombre`.
7. Conecta **dataSource** y **delegate** del Table View al View Controller.
8. Pega el código de `Semana07_B/` y copia los avatares a **Assets**.
9. Ejecuta y toca un docente para ver la alerta.

> **Errores comunes:**
> * Si al seleccionar el Table View no aparecen `dataSource` y `delegate` en el Connections Inspector, revisa que el Table View **no** tenga una clase personalizada en el Identity Inspector.
> * *"The outlet from the ViewController to the UIImageView is invalid"*: los controles de la celda quedaron conectados al ViewController. Borra esas conexiones (o borra y vuelve a agregar la imagen y el label) y conéctalos a **miCell**.
> * *"Invalid redeclaration of 'PersonasTableViewCell'"*: la clase está escrita dos veces en el proyecto.
