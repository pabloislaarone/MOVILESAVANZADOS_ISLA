import UIKit

class Cultura: NSObject {

    var nombre: String = ""
    var region: String = ""
    var imagen: UIImage!
    var elementos: [Elemento] = []   // Lo que ofrece la cultura (pantalla 2)

    init(nombre: String, region: String, imagen: UIImage!, elementos: [Elemento]) {
        self.nombre = nombre
        self.region = region
        self.imagen = imagen
        self.elementos = elementos
    }

    // Imagen de un elemento; si no está en Assets, se usa la imagen de la cultura
    func imagenDe(_ elemento: Elemento) -> UIImage? {
        return UIImage(named: elemento.imagenNombre) ?? imagen
    }
}
