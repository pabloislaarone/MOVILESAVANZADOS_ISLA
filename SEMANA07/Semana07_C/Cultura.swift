import UIKit

class Cultura: NSObject {

    var nombre: String = ""
    var region: String = ""
    var descripcion: String = ""
    var imagen: UIImage!

    init(nombre: String, region: String, descripcion: String, imagen: UIImage!) {
        self.nombre = nombre
        self.region = region
        self.descripcion = descripcion
        self.imagen = imagen
    }
}
