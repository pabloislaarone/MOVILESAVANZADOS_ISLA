# Laboratorio 06: ViewControllers – Navegación Modal – Segues

**Alumno:** Pablo Isla Arone  
**Curso:** Programación en Móviles Avanzado  
**Docente:** Juan León

---

## Rama `ai-assisted`

### Ejercicio 4: Calculadora de Venta a Plazos de Electrodoméstico (`Semana06_Calculadora/`)
App con dos pantallas dentro de un Navigation Controller. En **Nueva Venta** se ingresan el electrodoméstico, precio unitario, cantidad, meses e interés mensual. El botón **Calcular** tiene un segue **Show** (`showResultado`) hacia **Resultado**, y en `prepare(for:sender:)` se calcula todo y se envía un `VentaModel` con los 6 valores. Finalmente, la pantalla Resultado los muestra en soles con `String(format: "S/. %.2f", valor)`.

**Conexiones en el Storyboard:**
* Nueva Venta (`NuevaVentaViewController`): `tfElectrodomestico`, `tfPrecioUnitario`, `tfCantidad`, `tfMeses`, `tfInteresMensual`.
* Resultado (`ResultadoViewController`): `lblSubtotal`, `lblIgv`, `lblBase`, `lblIntereses`, `lblTotal`, `lblCuota`.
* Segue Show desde el botón Calcular con identifier `showResultado`.

**Evidencias:**
![nueva venta](evidencias/evidencia01.png)
![resultado](evidencias/evidencia02.png)

**Guía del Storyboard:** [GUIA_STORYBOARD.md](GUIA_STORYBOARD.md)

**Nota:** los prompts y la comparación con la IA están en [PROMPTS.md](PROMPTS.md).

---

## Conclusiones

**1. ¿Cuándo conviene usar Show y cuándo Present Modally?**  
Show conviene cuando el usuario va avanzando por un flujo y necesita poder regresar paso a paso; por ejemplo, en una app de delivery, al pasar de la lista de restaurantes al menú y luego al detalle de un plato. En cambio, Present Modally sirve para una tarea corta y separada que se abre, se completa y se cierra, como el formulario para agregar una tarjeta de pago o una pantalla de confirmación, tal como hicimos con "DATOS INGRESADOS".

**2. ¿Para qué sirven Show Detail y Present As Popover y en qué dispositivo tienen sentido?**  
Ambos tienen sentido sobre todo en **iPad**, donde la pantalla es grande. Show Detail se usa con un Split View Controller: a la izquierda queda una lista y a la derecha cambia el detalle, como en la app Correo. Por otro lado, Present As Popover muestra una ventanita flotante que apunta al botón que la abrió, útil para opciones rápidas. En iPhone, en cambio, Show Detail se comporta casi como Show y el popover se muestra como un modal.

**3. ¿Qué pasaría si ClienteModel o VentaModel fueran struct en vez de class? ¿Se rompería el paso de datos hacia adelante?**  
El paso de datos hacia adelante **no se rompería**, porque al asignar `oPantalla2.pCliente = oCliente` o `oResultado.pVenta = ...` la segunda pantalla recibe una **copia** con los mismos valores y los puede mostrar sin problema. Sin embargo, la diferencia aparece si la segunda pantalla modifica los datos: con un struct, ese cambio queda solo en la copia y la primera pantalla nunca se entera, mientras que con una class ambas comparten el mismo objeto. Además, si fuera struct ya no podría heredar de `NSObject`, que es el patrón que usamos en clase.

**4. ¿Qué diferencia notaste entre resolver el Ejercicio 2 (manual) y el Ejercicio 4 (con IA) en tiempo y comprensión?**  
Con la IA el código salió mucho más rápido, sobre todo la parte de las fórmulas y el formato en soles. Sin embargo, el ejercicio manual me ayudó más a entender cómo se conectan los outlets y cómo viaja el objeto de una pantalla a otra; de hecho, si no lo hubiera hecho antes, no habría podido revisar si lo que generó la IA estaba bien. Por eso creo que lo ideal es entender primero el patrón a mano y después usar la IA para avanzar más rápido.
