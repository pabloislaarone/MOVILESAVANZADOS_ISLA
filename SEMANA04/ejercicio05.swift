// ===== CASO 2 PARTE B: BIBLIOTECA (CON IA) =====
// Docente: Juan León

// TODO 20: pega aquí el código generado por la IA, ya comentado línea por línea

// Declara un enum llamado EstadoLibro para controlar la disponibilidad
enum EstadoLibro {
    // Caso que indica que el libro está disponible en la biblioteca
    case disponible
    // Caso que indica que el libro ya ha sido prestado
    case prestado
}

// Define un struct llamado Libro, ya que es un tipo de valor
struct Libro {
    // Almacena el título del libro como constante
    let titulo: String
    // Almacena el autor del libro como constante
    let autor: String
    // Inicializa el estado del libro como disponible por defecto
    var estado: EstadoLibro = .disponible
}

// Define la clase Biblioteca, usando clase por ser tipo de referencia
class Biblioteca {
    // Inicializa un arreglo vacío que contendrá objetos de tipo Libro
    var libros: [Libro] = []
    
    // Función para agregar un nuevo libro al arreglo
    func agregar(libro: Libro) {
        // Usa el método append para insertar el elemento al final del arreglo
        libros.append(libro)
    }
    
    // Función para prestar un libro buscando por título y retornando un Bool
    func prestar(titulo: String) -> Bool {
        // Inicia un bucle iterando sobre los índices del arreglo libros
        for i in 0..<libros.count {
            // Compara el título en la posición actual con el título buscado
            if libros[i].titulo == titulo {
                // Comprueba si el estado del libro es disponible
                if libros[i].estado == .disponible {
                    // Cambia el estado modificando directamente el struct en el arreglo
                    libros[i].estado = .prestado
                    // Imprime un mensaje indicando que el préstamo fue aprobado
                    print("Préstamo aprobado: \(titulo)")
                    // Retorna true confirmando que la operación fue exitosa
                    return true
                } else {
                    // Imprime un mensaje de error si el libro ya está prestado
                    print("Error: \(titulo) ya está prestado")
                    // Retorna false indicando que la operación fue rechazada
                    return false
                }
            }
        }
        // Imprime un error si el bucle termina sin encontrar el libro
        print("Error: no existe \(titulo)")
        // Retorna false porque el libro no se encontró en la biblioteca
        return false
    }
    
    // Función para devolver un libro buscando por título
    func devolver(titulo: String) -> Bool {
        // Inicia un bucle iterando sobre los índices del arreglo
        for i in 0..<libros.count {
            // Compara el título en la posición actual con el buscado
            if libros[i].titulo == titulo {
                // Comprueba si el estado del libro es prestado
                if libros[i].estado == .prestado {
                    // Cambia el estado a disponible en el índice correspondiente
                    libros[i].estado = .disponible
                    // Imprime un mensaje indicando éxito en la devolución
                    print("Devolución registrada: \(titulo)")
                    // Retorna true para confirmar la operación
                    return true
                }
            }
        }
        // Retorna false si no se encuentra el libro o no estaba prestado
        return false
    }
    
    // Función para mostrar todos los libros y sus estados actuales
    func inventario() {
        // Imprime la cabecera del inventario en consola
        print("===== INVENTARIO =====")
        // Itera sobre cada elemento del arreglo libros
        for libro in libros {
            // Inicia una variable String vacía para guardar el texto del estado
            var estadoStr = ""
            // Evalúa el estado del libro usando una estructura switch
            switch libro.estado {
            // En caso de que el estado sea disponible
            case .disponible:
                // Asigna la cadena correspondiente a la variable
                estadoStr = "disponible"
            // En caso de que el estado sea prestado
            case .prestado:
                // Asigna la cadena correspondiente a la variable
                estadoStr = "prestado"
            }
            // Imprime el título, el autor y el estado formateados en una línea
            print("\(libro.titulo) (\(libro.autor)) - \(estadoStr)")
        }
    }
}

// --- Simulación ---
// Crea una instancia de la clase Biblioteca
let bibliotecaIA = Biblioteca()

// Agrega el primer libro al arreglo de la biblioteca
bibliotecaIA.agregar(libro: Libro(titulo: "Cien años de soledad", autor: "Gabriel García Márquez"))
// Agrega el segundo libro al arreglo de la biblioteca
bibliotecaIA.agregar(libro: Libro(titulo: "La ciudad y los perros", autor: "Mario Vargas Llosa"))
// Agrega el tercer libro al arreglo de la biblioteca
bibliotecaIA.agregar(libro: Libro(titulo: "El Quijote", autor: "Miguel de Cervantes"))

// Intenta prestar un libro disponible, usando _ para ignorar el Bool que retorna
_ = bibliotecaIA.prestar(titulo: "La ciudad y los perros")
// Intenta prestar el mismo libro que ya está prestado para forzar el error
_ = bibliotecaIA.prestar(titulo: "La ciudad y los perros")
// Devuelve el libro prestado para cambiar su estado a disponible
_ = bibliotecaIA.devolver(titulo: "La ciudad y los perros")
// Presta un libro diferente que está disponible
_ = bibliotecaIA.prestar(titulo: "El Quijote")
// Intenta prestar un libro que no fue agregado al arreglo para forzar el error de inexistencia
_ = bibliotecaIA.prestar(titulo: "El Principito")

// Llama a la función inventario para imprimir el estado final de todos los libros
bibliotecaIA.inventario()