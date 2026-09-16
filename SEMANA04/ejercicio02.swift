//===== CASO 2 PARTE A: BIBLIOTECA (SIN IA) =====
// Docente: Juan León

// TODO 19: escribe aquí el enum, el struct, la clase y la simulación

enum EstadoLibro {
    case disponible
    case prestado
}

struct Libro {
    let titulo: String
    let autor: String
    var estado: EstadoLibro = .disponible
}

class Biblioteca {
    var libros: [Libro] = []
    
    func agregar(libro: Libro) {
        libros.append(libro)
    }
    
    func prestar(titulo: String) -> Bool {
        // Se recorre por índice para poder modificar el struct original dentro del array
        for i in 0..<libros.count {
            if libros[i].titulo == titulo {
                if libros[i].estado == .disponible {
                    libros[i].estado = .prestado
                    print("Préstamo aprobado: \(titulo)")
                    return true
                } else {
                    print("Error: \(titulo) ya está prestado")
                    return false
                }
            }
        }
        print("Error: no existe \(titulo)")
        return false
    }
    
    func devolver(titulo: String) -> Bool {
        for i in 0..<libros.count {
            if libros[i].titulo == titulo {
                if libros[i].estado == .prestado {
                    libros[i].estado = .disponible
                    print("Devolución registrada: \(titulo)")
                    return true
                }
            }
        }
        return false
    }
    
    func inventario() {
        print("===== INVENTARIO =====")
        for libro in libros {
            var estadoStr = ""
            // Uso de switch obligatorio según el requerimiento
            switch libro.estado {
            case .disponible:
                estadoStr = "disponible"
            case .prestado:
                estadoStr = "prestado"
            }
            print("\(libro.titulo) (\(libro.autor)) - \(estadoStr)")
        }
    }
}

// Simulación
let biblioteca = Biblioteca()
biblioteca.agregar(libro: Libro(titulo: "Cien años de soledad", autor: "Gabriel García Márquez"))
biblioteca.agregar(libro: Libro(titulo: "La ciudad y los perros", autor: "Mario Vargas Llosa"))
biblioteca.agregar(libro: Libro(titulo: "El Quijote", autor: "Miguel de Cervantes"))

// Usamos _ = para silenciar el warning del valor Bool que retorna la función y no estamos almacenando
_ = biblioteca.prestar(titulo: "La ciudad y los perros")
_ = biblioteca.prestar(titulo: "La ciudad y los perros")
_ = biblioteca.devolver(titulo: "La ciudad y los perros")
_ = biblioteca.prestar(titulo: "El Quijote")
_ = biblioteca.prestar(titulo: "El Principito")

biblioteca.inventario()