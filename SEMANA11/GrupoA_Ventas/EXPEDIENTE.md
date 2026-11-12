# Expediente · Grupo A · Caso Ventas

## 1. Integrantes y caso

| | |
|---|---|
| Integrantes | Pablo Isla Arone |
| Grupo | A · Caso Ventas |
| App | **Ventas** (UIKit + Core Data) |

## 2. Modelo de datos

| Entidad | Atributos | Relaciones (delete rule) |
|---|---|---|
| **Usuario** | nombre, usuario, clave, rol (String: Vendedor o Supervisor) | ventas: To Many ▸ Venta (**Deny**) |
| **Producto** | nombre, categoria (String), precio (Double), stock (Int) | ventas: To Many ▸ Venta (**Deny**) |
| **Cliente** | nombre, documento (String) | ventas: To Many ▸ Venta (**Deny**) |
| **Venta** | fecha (Date), cantidad (Int), precioUnitario, descuento, igv, total (Double), anulada (Bool), motivoAnulacion (String, opcional) | vendedor ▸ Usuario, producto ▸ Producto, cliente ▸ Cliente (To One, Nullify) |

```
 Usuario 1 ──────< Venta >────── 1 Cliente
  (vendedor)        │
                    │ 1
                 Producto
```

- **Deny** en los tres "To Many": no se puede borrar un usuario, producto o cliente que ya tiene ventas, porque la venta perdería su historia.
- **Nullify** en los "To One" de Venta: borrar una venta no borra a su vendedor, cliente ni producto.

## 3. Roles y permisos

| Qué puede hacer | Vendedor | Supervisor |
|---|---|---|
| Pestañas | Productos, Clientes, Venta, Mis ventas, Cuenta | Resumen, Ventas, Productos, Clientes, Cuenta |
| Productos | Solo consultar y buscar | Crear, editar y borrar |
| Clientes | Crear, editar y consultar | Crear, editar, consultar y borrar |
| Ventas | Registrar y ver **solo las suyas** | Ver **todas**, filtrar por vendedor y **anular** con motivo |
| Resumen | No lo ve | Indicadores, gráfico de 7 días y ranking |

## 4. Reglas de negocio con ejemplos

**Categoría del cliente** (se calcula con las ventas no anuladas, no se guarda):

| Comprado | Categoría |
|---|---|
| menos de S/ 1,000 | Regular |
| desde S/ 1,000 | Frecuente |
| desde S/ 5,000 | VIP |

**Descuento, IGV y total.** VIP tiene 10 % de descuento sobre el subtotal y los demás 0 %. El IGV es 18 % de (subtotal − descuento), y total = subtotal − descuento + IGV.

- 2 Laptop × S/ 200.00 a un cliente VIP:
  - subtotal = 400.00
  - descuento = 400.00 × 10 % = 40.00
  - IGV = (400.00 − 40.00) × 18 % = 64.80
  - **total = 400.00 − 40.00 + 64.80 = 424.80**
- 3 Mouse × S/ 35.00 a un cliente Regular:
  - subtotal = 105.00
  - descuento = 0.00
  - IGV = 105.00 × 18 % = 18.90
  - **total = 123.90**

**Stock.**
- Con stock 40, vender 2 lo deja en 38.
- Con stock 40, vender 50 muestra una alerta y no registra nada: el stock sigue en 40.

**Anular** (solo supervisor):
- Pide un motivo obligatorio y marca la venta como anulada.
- Devuelve el stock: si se anula la venta de 2 laptops, el stock pasa de 38 a 40.
- La venta deja de contar en el resumen (baja 424.80) y en la categoría del cliente.

**Visibilidad.** El vendedor ve sus ventas con el predicate `vendedor == %@`; el supervisor ve todas.

## 5. Pantallas

| Pant. | Propósito | Lee | Escribe |
|---|---|---|---|
| A1 Login | Entrar con usuario y clave | Usuario (`usuario ==[c] %@ AND clave == %@`) | Sesión |
| A2 Crear cuenta | Registro con usuario único y rol | Usuario (`usuario ==[c] %@`) | Usuario nuevo |
| A3 Productos | Buscar y filtrar por categoría; stock en color | Producto (`categoria == %@`, `nombre CONTAINS[cd] %@`) | Producto (solo supervisor) |
| A4 Clientes | Lista con total comprado y categoría | Cliente y sus ventas no anuladas | Cliente |
| A5 Nueva venta | Registrar una venta con su resumen calculado | Cliente, Producto, sesión | Venta y Producto.stock |
| A6 Mis ventas | Ventas propias con indicadores de hoy y del mes | Venta (`vendedor == %@`, `fecha >= %@`, `cliente.nombre CONTAINS[cd] %@`) | — |
| A7 Ventas del equipo | Todas las ventas, con filtro por vendedor | Venta (`vendedor == %@`, fechas, cliente) | — |
| A8 Anular venta | Motivo obligatorio y devolución del stock | Venta | Venta.anulada, motivo, Producto.stock |
| A9 Resumen | Hoy vs ayer, IGV del mes, 7 días, ranking y stock bajo | Venta (no anuladas), Producto (`stock <= 5`) | — |
| Cuenta | Nombre, usuario, rol y Cerrar sesión | Sesión | Sesión = nil |

## 6. Casos de prueba

| N.º | Caso | Resultado esperado |
|---|---|---|
| 1 | Registrar a "lparedes" como Supervisor e intentar registrar otro "LPAREDES" | Se crea el primero y entra; el segundo se rechaza por usuario repetido |
| 2 | Registrar con claves distintas o de 4 caracteres | Mensaje de error; no se crea el usuario |
| 3 | Login con clave incorrecta | "Usuario o clave incorrectos"; no entra |
| 4 | Vendedor vende 2 Laptop a S/ 200.00 a un cliente VIP | 400.00 · −40.00 · IGV 64.80 · total 424.80 · stock 40 → 38 |
| 5 | Vendedor vende 3 Mouse a S/ 35.00 a un cliente Regular | 105.00 · IGV 18.90 · total 123.90 |
| 6 | Venta de 50 unidades con stock 40 | Alerta; no se registra y el stock no cambia |
| 7 | Un vendedor abre Mis ventas | Solo sus ventas; ninguna fila permite Anular |
| 8 | El supervisor anula la venta del caso 4 sin motivo y luego con motivo | Sin motivo no se puede; con motivo queda anulada, el stock vuelve a 40 y el resumen baja 424.80 |
| 9 | Borrar un cliente que tiene ventas | Se impide con un mensaje |
| 10 | El supervisor intenta borrar un producto con ventas (Laptop Pro 14) | Se impide con un mensaje (regla Deny) |
| 11 | El vendedor abre Mis ventas después de la anulación | La venta aparece tachada, con la etiqueta "Anulada" y su motivo |

## 7. Plan de commits

| N.º | Commit |
|---|---|
| 1 | Proyecto Ventas y modelo Core Data con las 4 entidades y sus delete rules |
| 2 | A1 login y sesión |
| 3 | A2 registro con usuario único y rol |
| 4 | Pestañas por rol y Cuenta (cerrar sesión) |
| 5 | A3 productos con chips, stock en color y borrado bloqueado |
| 6 | A4 clientes con categoría y total calculados |
| 7 | A5 nueva venta con descuento, IGV y stock |
| 8 | A6 mis ventas con indicadores y filtros por periodo |
| 9 | A7 y A8 ventas del equipo y anulación con motivo |
| 10 | A9 resumen del supervisor |
| 11 | Ícono, evidencias de los casos y PROMPTS.md |

## 8. Plan de uso de IA

- **Se pide a la IA:** la construcción de las pantallas en UIKit a partir de este expediente (modelo, permisos, reglas y casos ya definidos).
- **Se hace a mano:**
  - el modelo de datos y las delete rules
  - la matriz de permisos
  - los cálculos de los ejemplos
  - la revisión del código para poder explicarlo en la defensa
- **Cómo se verifica:**
  - Se corren los 9 casos (más 2 propios) en el simulador y se comparan con los resultados de la sección 6, al céntimo.
  - Cada consulta queda anotada en `PROMPTS.md`.

## 9. Visto bueno

| | |
|---|---|
| Fecha | |
| Docente | |
| Confirmación | |
