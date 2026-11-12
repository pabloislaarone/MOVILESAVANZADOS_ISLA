import Foundation
import CoreData

// Datos de ejemplo para probar la app (se cargan solo con el argumento -datosDemo y si la base está vacía)
// Usuarios demo: cruiz / 123456 (Vendedor) y adiaz / 123456 (Vendedor)
enum DatosDemo {

    static func cargarSiEstaVacia() {
        let contexto = BaseDeDatos.contexto
        let request: NSFetchRequest<Usuario> = Usuario.fetchRequest()
        guard ((try? contexto.count(for: request)) ?? 0) == 0 else { return }

        let carlos = usuario("Carlos Ruiz", "cruiz")
        let ana = usuario("Ana Díaz", "adiaz")

        let laptop = producto("Laptop Pro 14", "Laptops", 200.00, 40)
        let monitor = producto("Monitor 24\"", "Monitores", 450.00, 8)
        let mouse = producto("Mouse inalámbrico", "Accesorios", 35.00, 120)
        let teclado = producto("Teclado mecánico", "Accesorios", 129.90, 4)
        _ = producto("Monitor 27\"", "Monitores", 890.00, 15)

        let andina = cliente("Comercial Andina SAC", "20100000001")
        let maria = cliente("María Quispe", "00000001")
        let luis = cliente("Luis Rojas", "00000002")
        _ = cliente("Tienda Sol EIRL", "20100000044")

        // Ventas de días anteriores (no tocan el stock actual). Comercial Andina llega a VIP.
        venta(hace: 6, carlos, andina, monitor, 4)
        venta(hace: 5, ana, andina, monitor, 5)
        venta(hace: 4, carlos, andina, laptop, 3)
        venta(hace: 3, ana, maria, monitor, 2)
        venta(hace: 2, carlos, luis, mouse, 4)
        venta(hace: 1, ana, maria, teclado, 1)
        venta(hace: 1, carlos, andina, mouse, 10)

        BaseDeDatos.guardar()
    }

    private static func usuario(_ nombre: String, _ usuario: String) -> Usuario {
        let u = Usuario(context: BaseDeDatos.contexto)
        u.nombre = nombre
        u.usuario = usuario
        u.clave = "123456"
        u.rol = Rol.vendedor
        return u
    }

    private static func producto(_ nombre: String, _ categoria: String, _ precio: Double, _ stock: Int64) -> Producto {
        let p = Producto(context: BaseDeDatos.contexto)
        p.nombre = nombre
        p.categoria = categoria
        p.precio = precio
        p.stock = stock
        return p
    }

    private static func cliente(_ nombre: String, _ documento: String) -> Cliente {
        let c = Cliente(context: BaseDeDatos.contexto)
        c.nombre = nombre
        c.documento = documento
        return c
    }

    private static func venta(hace dias: Int, _ vendedor: Usuario, _ cliente: Cliente, _ producto: Producto, _ cantidad: Int) {
        let hoy = Calendar.current.startOfDay(for: Date())
        let fecha = Calendar.current.date(byAdding: .day, value: -dias, to: hoy)!.addingTimeInterval(11 * 3600)
        let calculo = CalculoVenta(precio: producto.precio, cantidad: cantidad, categoria: cliente.categoria)
        let v = Venta(context: BaseDeDatos.contexto)
        v.fecha = fecha
        v.cantidad = Int64(cantidad)
        v.precioUnitario = producto.precio
        v.descuento = calculo.descuento
        v.igv = calculo.igv
        v.total = calculo.total
        v.vendedor = vendedor
        v.cliente = cliente
        v.producto = producto
    }
}
