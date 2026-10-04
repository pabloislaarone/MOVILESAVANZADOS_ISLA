# Guía rápida para armar el Storyboard en la Mac

El código `.swift` ya está listo en este repo. En la Mac solo hay que crear el proyecto, copiar los archivos y conectar el Storyboard.

## Primera parte — proyecto `Semana06`
1. Xcode > New Project > iOS App > Interface: **Storyboard**, Language: **Swift**. Nombre: `Semana06`.
2. `Main.storyboard`: label **PANTALLA 01** y abajo "Desarrollado por: ...".
3. Ícono: genera el set en https://hotpot.ai/icon-resizer (Universal) y arrastra los PNG a `Assets > AppIcon`.
4. Agrega otro **View Controller** con el label **PANTALLA 02**.
5. Selecciona la PANTALLA 01 > `Editor > Embed In > Navigation Controller`.
6. New File > Cocoa Touch Class > `ViewController2` (subclase de `UIViewController`, sin XIB). Pega el contenido de `Semana06/ViewController2.swift`.
7. PANTALLA 02 > Identity Inspector > Class: `ViewController2`.
8. Arrastra un **Bar Button Item** a la barra de la PANTALLA 01, texto **A Pantalla 2**.
9. Ctrl + arrastrar del botón a la PANTALLA 02 > **Show**.
10. Ejecuta (⌘R) y toma las capturas.

## Ventanas modales — proyecto `Semana06_02`
1. Nuevo proyecto `Semana06_02` (Storyboard + Swift).
2. Vista 1 "DATOS DEL CLIENTE": 3 labels (Apellidos, Nombres, DNI), 3 **TextField** y un botón **Continuar**. Embed In > Navigation Controller.
3. Vista 2 "DATOS INGRESADOS": 3 labels fijos y 3 **Label** para los valores, más un botón **Volver**.
4. Crea `ClienteModel` (Cocoa Touch Class, subclase de **NSObject**) y `ViewControllerConfirmacion` (subclase de **UIViewController**). Pega el código de `Semana06_02/`.
5. Reemplaza el contenido de `ViewController.swift` por el de `Semana06_02/ViewController.swift`.
6. Vista 2 > Identity Inspector > Class **y** Storyboard ID: `ViewControllerConfirmacion`.
7. Conecta los outlets (clic derecho sobre el círculo del controlador en el Storyboard, o Ctrl + arrastrar):
   - Vista 1: `tfApellido`, `tfNombre`, `tfDni` → los TextField; botón Continuar → `btnContinuar`.
   - Vista 2: `tfApellido`, `tfNombre`, `tfDni` → los Label de valores; botón Volver → `btnVolver`.
8. Ejecuta y toma las capturas.

> Tip: si al pegar el código aparece un círculo vacío al lado de un `@IBOutlet`, ese outlet todavía no está conectado. Si la app se cierra al abrir la pantalla con el error "unexpectedly found nil", falta conectar un outlet.
