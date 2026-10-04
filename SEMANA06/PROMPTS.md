# Prompts utilizados
Laboratorio 06

## Herramienta de IA utilizada
Claude

## Ejercicio 4: Calculadora de Venta a Plazos de Electrodoméstico

### Prompt (estructura CTRFE)

**Contexto:**
Soy estudiante de Programación en Móviles Avanzado, semana 6. Trabajo en Xcode con UIKit y Storyboard. Ya tengo un proyecto con dos pantallas dentro de un Navigation Controller: "Nueva Venta" y "Resultado", unidas por un segue Show con identifier `showResultado`.

**Tarea:**
1. Define `class VentaModel: NSObject` con 6 propiedades `Double`: subtotal, igv, base, intereses, total y cuota.
2. En "Nueva Venta" lee 5 `UITextField` (electrodoméstico, precio unitario, cantidad, meses e interés mensual en %) y calcula:
   - subtotal = precioUnitario x cantidad
   - igv = subtotal x 0.18
   - base = subtotal + igv
   - intereses = base x (tasaInteresMensual / 100) x meses
   - total = base + intereses
   - cuota = total / meses
3. Pasa el `VentaModel` a "Resultado" con `prepare(for:sender:)`.
4. En "Resultado" muestra los 6 valores en `UILabel` con `String(format: "S/. %.2f", valor)`.

**Restricciones:**
Solo lo visto hasta la semana 6: clases, `UINavigationController`, `prepare(for:sender:)`, `@IBOutlet` / `@IBAction`. Nada de Combine, Codable ni persistencia. Explica por qué usas `class` y no `struct` para `VentaModel`.

**Formato:**
Tres archivos Swift completos (`VentaModel.swift`, `NuevaVentaViewController.swift`, `ResultadoViewController.swift`) con comentarios cortos, y los nombres de los outlets que debo conectar.

**Ejemplo:**
Precio 3500, cantidad 1, 12 meses, 1% mensual → Subtotal S/. 3500.00, IGV S/. 630.00, Base S/. 4130.00, Intereses S/. 495.60, Total S/. 4625.60, Cuota S/. 385.47.

### Respuesta de la IA
Generó los tres archivos. `VentaModel` sigue el mismo estilo que `ClienteModel` (subclase de `NSObject` con un `init()` vacío y otro con parámetros). El cálculo quedó en una función `calcularVenta()` que se llama dentro de `prepare(for:sender:)`, y en "Resultado" cada label se llena con `String(format:)`.

Sobre `class` vs `struct`, explicó que se usa `class` porque es un tipo por **referencia**: la pantalla "Resultado" recibe el mismo objeto creado en "Nueva Venta", igual que en el ejercicio de ventanas modales. Además, al heredar de `NSObject` mantiene el mismo patrón visto en clase.

### ¿Funcionó a la primera?
_(Completar después de ejecutar en Xcode.)_ Con los datos del ejemplo, los valores esperados coinciden con los de la guía.

### ¿Usó algo que no hemos visto en clase?
Usó el operador `?? 0` para convertir el texto a `Double`, de modo que si un campo está vacío se toma como 0 y la app no se cae. No usó `guard let`, Combine ni Codable.

### ¿Qué hizo distinto la IA?
* **Validó sin que se lo pidiera:** puso `?? 0` en las conversiones y un `if meses > 0` antes de calcular la cuota, para no dividir entre cero.
* **Separó el cálculo** en una función `calcularVenta()` en lugar de escribirlo todo dentro de `prepare(for:sender:)`, lo que lo hace más fácil de leer.
* **Agregó el nombre del electrodoméstico** en el título de la pantalla "Resultado", que no estaba en el enunciado.
