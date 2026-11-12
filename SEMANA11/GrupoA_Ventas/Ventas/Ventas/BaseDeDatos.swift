import UIKit
import CoreData

// Roles de la app (se guardan como texto en Usuario.rol)
enum Rol {
    static let vendedor = "Vendedor"
    static let supervisor = "Supervisor"
}

// Acceso único al contexto de Core Data (el mismo viewContext del AppDelegate)
enum BaseDeDatos {

    static var contexto: NSManagedObjectContext {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        return delegate.persistentContainer.viewContext
    }

    // Guarda los cambios. Si falla (por ejemplo, una regla Deny), deshace y devuelve false.
    @discardableResult
    static func guardar() -> Bool {
        do {
            try contexto.save()
            return true
        } catch {
            print("Error al guardar: \(error)")
            contexto.rollback()
            return false
        }
    }

    // Ejecuta un fetch request y devuelve un arreglo vacío si algo falla
    static func buscar<T: NSManagedObject>(_ request: NSFetchRequest<T>) -> [T] {
        return (try? contexto.fetch(request)) ?? []
    }
}

// MARK: - Consultas de Usuario

extension Usuario {

    var esSupervisor: Bool { rol == Rol.supervisor }

    // Usuario único sin distinguir mayúsculas: "usuario ==[c] %@"
    static func existe(_ usuario: String) -> Bool {
        let request: NSFetchRequest<Usuario> = Usuario.fetchRequest()
        request.predicate = NSPredicate(format: "usuario ==[c] %@", usuario)
        let cantidad = (try? BaseDeDatos.contexto.count(for: request)) ?? 0
        return cantidad > 0
    }

    static func login(usuario: String, clave: String) -> Usuario? {
        let request: NSFetchRequest<Usuario> = Usuario.fetchRequest()
        request.predicate = NSPredicate(format: "usuario ==[c] %@ AND clave == %@", usuario, clave)
        return BaseDeDatos.buscar(request).first
    }

    static func vendedores() -> [Usuario] {
        let request: NSFetchRequest<Usuario> = Usuario.fetchRequest()
        request.predicate = NSPredicate(format: "rol == %@", Rol.vendedor)
        request.sortDescriptors = [NSSortDescriptor(key: "nombre", ascending: true)]
        return BaseDeDatos.buscar(request)
    }
}

// MARK: - Cantidad de ventas (para la regla de borrado Deny)

extension Producto {
    var cantidadVentas: Int { ventas?.count ?? 0 }
}

extension Cliente {
    var cantidadVentas: Int { ventas?.count ?? 0 }
}
