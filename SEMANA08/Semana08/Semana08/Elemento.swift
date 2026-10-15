import UIKit

// Lo que ofrece cada cultura: un sitio arqueológico, una obra de arte, una técnica, etc.
class Elemento: NSObject {

    var nombre: String = ""
    var tipo: String = ""
    var descripcion: String = ""
    var imagenNombre: String = ""

    init(nombre: String, tipo: String, descripcion: String, imagenNombre: String) {
        self.nombre = nombre
        self.tipo = tipo
        self.descripcion = descripcion
        self.imagenNombre = imagenNombre
    }
}
