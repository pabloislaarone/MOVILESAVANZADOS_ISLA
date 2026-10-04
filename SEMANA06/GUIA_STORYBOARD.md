# Guía del Storyboard — Calculadora de Venta a Plazos

El código ya está en `Semana06_Calculadora/`. En la Mac solo hay que armar las dos pantallas así:

## 1. Proyecto
1. Xcode > New Project > iOS App > Interface: **Storyboard**, Language: **Swift**.
2. Crea los 3 archivos (Cocoa Touch Class) y pega el código:
   - `VentaModel` → subclase de **NSObject**
   - `NuevaVentaViewController` → subclase de **UIViewController**
   - `ResultadoViewController` → subclase de **UIViewController**
3. Selecciona la primera vista > `Editor > Embed In > Navigation Controller`.

## 2. Pantalla "Nueva Venta"
Identity Inspector > Class: `NuevaVentaViewController`.

| Label (texto) | TextField (outlet) | Keyboard Type |
|---|---|---|
| Electrodoméstico: | `tfElectrodomestico` | Default |
| Precio unitario: | `tfPrecioUnitario` | Decimal Pad |
| Cantidad: | `tfCantidad` | Number Pad |
| Meses: | `tfMeses` | Number Pad |
| Interés mensual (%): | `tfInteresMensual` | Decimal Pad |

- Título arriba: **Nueva Venta** (centrado, negrita).
- Botón **Calcular**: estilo *Filled*, color azul, ancho completo.
- Tip: si usas un **Vertical Stack View** (Spacing 8) con todos los labels y campos, queda alineado como en la imagen.

## 3. Pantalla "Resultado"
Identity Inspector > Class: `ResultadoViewController`.

Cada fila tiene un label fijo a la izquierda y un label de valor a la derecha (Alignment: **Right**):

| Label fijo | Label de valor (outlet) | Estilo |
|---|---|---|
| Subtotal | `lblSubtotal` | normal |
| IGV (18%) | `lblIgv` | normal |
| Base | `lblBase` | normal |
| Intereses | `lblIntereses` | normal |
| *(línea separadora: una View de 1 pt de alto, color gris claro)* | | |
| **Total** | `lblTotal` | **negrita** (ambos labels) |
| Cuota mensual | `lblCuota` | color **azul** (ambos labels) |

- Título arriba: **Resultado** (centrado, negrita).
- Tip: cada fila puede ser un **Horizontal Stack View** (Distribution: *Fill Equally*), y todas las filas dentro de un Vertical Stack View.

## 4. Segue
1. Ctrl + arrastrar desde el botón **Calcular** hasta la pantalla Resultado > **Show**.
2. Selecciona el segue (la flecha) > Attributes Inspector > Identifier: **`showResultado`**.

## 5. Probar
Electrodoméstico: Refrigeradora · Precio: 3500 · Cantidad: 1 · Meses: 12 · Interés: 1

Resultado esperado:

| | |
|---|---|
| Subtotal | S/. 3500.00 |
| IGV (18%) | S/. 630.00 |
| Base | S/. 4130.00 |
| Intereses | S/. 495.60 |
| **Total** | **S/. 4625.60** |
| Cuota mensual | S/. 385.47 |

> Si la app se cierra con "unexpectedly found nil", falta conectar algún outlet. Si al tocar Calcular no aparecen los valores, revisa que el identifier del segue sea exactamente `showResultado`.
