# Semana 11 · Grupo A · Caso Ventas (UIKit + Core Data)

App de una tienda que registra productos, clientes y ventas, con login, registro y dos roles (Vendedor y Supervisor). Las pestañas del `UITabBarController` cambian según el rol.

## Estructura

```
GrupoA_Ventas/
├── EXPEDIENTE.md                       modelo, permisos, reglas, pantallas, casos y plan
├── PROMPTS.md
├── evidencias/                         capturas del simulador (casos 1 a 9)
└── Ventas/
    ├── Ventas.xcodeproj
    └── Ventas/
        ├── AppDelegate.swift           persistentContainer (Core Data)
        ├── SceneDelegate.swift         pantalla inicial: login
        ├── Ventas.xcdatamodeld         Usuario, Producto, Cliente, Venta
        ├── BaseDeDatos.swift           contexto, guardar y consultas de Usuario
        ├── Sesion.swift                usuario conectado y cambio login <-> pestañas
        ├── Reglas.swift                categoría, descuento, IGV y formatos
        ├── Estilo.swift                piezas visuales compartidas
        ├── LoginViewController.swift           A1
        ├── RegistroViewController.swift        A2
        ├── MainTabBarController.swift          pestañas por rol + Cuenta
        ├── ProductosViewController.swift       A3
        ├── ClientesViewController.swift        A4
        ├── NuevaVentaViewController.swift      A5
        ├── VentasViewController.swift          A6, A7 y A8
        ├── ResumenViewController.swift         A9
        └── DatosDemo.swift             datos de ejemplo (argumento -datosDemo)
```

## Cómo iniciarlo

1. Clonar el repo y cambiar a la rama `ai-assisted`:
   ```
   git clone https://github.com/pabloislaarone/MOVILESAVANZADOS_ISLA.git
   cd MOVILESAVANZADOS_ISLA
   git checkout ai-assisted
   ```
2. Abrir `SEMANA11/GrupoA_Ventas/Ventas/Ventas.xcodeproj` en Xcode.
3. Elegir un simulador de iPhone y ejecutar con ▶ (⌘R).
4. Crear una cuenta (Vendedor o Supervisor) desde el login.

Para entrar con datos de ejemplo: **Product ▸ Scheme ▸ Edit Scheme ▸ Run ▸ Arguments** y agregar `-datosDemo`. Así se cargan los usuarios `cruiz` y `adiaz` (clave `123456`, Vendedor), además de productos, clientes y ventas de los últimos días.
