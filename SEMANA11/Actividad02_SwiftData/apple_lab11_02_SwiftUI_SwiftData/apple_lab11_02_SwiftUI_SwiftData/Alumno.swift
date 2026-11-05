import Foundation
// Importamos SwiftData para poder usar la anotación @Model y la persistencia automática
import SwiftData

// Indicamos que esta clase representa una entidad persistente en la base de datos
@Model
class Alumno {
    var idAlumno: UUID      // Identificador único del alumno
    var apellido: String
    var nombre: String
    var dni: String

    // Constructor que inicializa un nuevo objeto Alumno con los datos proporcionados
    init(idAlumno: UUID = UUID(), apellido: String, nombre: String, dni: String) {
        self.idAlumno = idAlumno
        self.apellido = apellido
        self.nombre = nombre
        self.dni = dni
    }
}
