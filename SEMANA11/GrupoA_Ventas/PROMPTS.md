# Prompts utilizados
Semana 11 · Grupo A · Caso Ventas (UIKit + Core Data)

## Herramienta de IA utilizada
Claude

## Prompt 1 · Construcción de la app

**Contexto:**
Estudiante de Programación en Móviles Avanzado, semana 11. Trabajo de la semana del Grupo A: una tienda que registra productos, clientes y ventas, con login, registro y dos roles (Vendedor y Supervisor). Ya tengo el enunciado completo de la guía (entidades, matriz de permisos, 9 pantallas A1–A9, reglas de negocio y 9 casos de prueba) y la Actividad 01 de Core Data hecha en clase.

**Tarea:**
1. Proyecto UIKit + Core Data llamado Ventas con las 4 entidades:
   - Usuario, Producto, Cliente y Venta
   - relaciones To Many con regla Deny y To One hacia Usuario, Producto y Cliente
2. Login (A1) y registro (A2):
   - el usuario es único sin distinguir mayúsculas
   - la clave tiene mínimo 6 caracteres y debe coincidir con su confirmación
   - el rol lo elige quien se registra y entra directo a la app
3. Sesión con un objeto compartido (`static let shared`) y un `UITabBarController` con las pestañas de cada rol, más la pestaña Cuenta con Cerrar sesión.
4. Las pantallas A3–A9 según las leyendas de la maqueta:
   - chips de categoría y stock en color
   - categoría del cliente calculada
   - venta con stepper y resumen calculado
   - Mis ventas con indicadores y Todas/Hoy/Mes
   - Ventas del equipo con chips por vendedor
   - anulación con motivo obligatorio
   - resumen con gráfico de 7 días, ranking y stock bajo
5. Ícono de la app y nombre "Ventas" bajo el ícono.

**Restricciones:**
- Filtros con `NSPredicate`:
  - `usuario ==[c] %@`
  - `vendedor == %@`
  - fechas con `fecha >= %@`
  - `cliente.nombre CONTAINS[cd] %@`
  - `categoria == %@`
- Descuento VIP del 10 %. IGV del 18 % sobre (subtotal − descuento). Montos redondeados a 2 decimales.
- Si la cantidad supera el stock, alerta y no se registra.
- Al anular se devuelve el stock y la venta deja de contar en reportes y en la categoría.
- No se borra un producto, cliente o usuario con ventas; se muestra una alerta.
- La clave se guarda como texto porque es una práctica, como dice la guía.

**Formato esperado:**
- El proyecto de Xcode completo, con un archivo `.swift` por pantalla y comentarios que indiquen qué número de la maqueta (①, ②…) cubre cada parte.
- Un commit por pantalla.

**Ejemplo / validación:**
Los 9 casos de la guía deben dar exactamente estos resultados:
- caso 4: 400.00 · −40.00 · 64.80 · **424.80** y stock de 40 a 38
- caso 5: **123.90**
- caso 8: stock de vuelta a 40 y el resumen baja 424.80

## Qué se hizo con la respuesta
- Se aceptó la estructura: una clase por pantalla, `BaseDeDatos` para el contexto, `Sesion` para el usuario conectado y `Reglas.swift` con los cálculos.
- Se verificaron los 9 casos de la guía y 2 propios con una prueba automática en el simulador de iPhone. Las capturas están en `evidencias/`.
- `Mis ventas` y `Ventas del equipo` comparten la clase `VentasViewController` con un `modo`, porque las dos pantallas solo cambian en el filtro por vendedor y en el permiso de anular.
- Los datos de ejemplo (`DatosDemo.swift`) solo se cargan con el argumento `-datosDemo`, para no mezclarlos con el uso normal.
