enum CategoriaElectro { case lineaBlanca, tecnologia, pequenos }

struct Electrodomestico {
    let nombre: String, marca: String
    let precioLista: Double
    let categoria: CategoriaElectro
}

class Sucursal {
    let nombre: String, ciudad: String
    init(nombre: String, ciudad: String) {
        self.nombre = nombre; self.ciudad = ciudad
    }
    func descuento() -> Double { return 0.05 }
    func costoEnvio(monto: Double) -> Double { return 30.0 }
    
    func cotizar(item: Electrodomestico) {
        let precioConDescuento = item.precioLista * (1 - descuento())
        let envio = costoEnvio(monto: precioConDescuento)
        let total = precioConDescuento + envio
        print("\(nombre): \(item.nombre) -> S/ \(precioConDescuento) + envio S/ \(envio) = S/ \(total)")
    }
}

class SucursalLima: Sucursal {
    override func descuento() -> Double { return 0.10 }
    override func costoEnvio(monto: Double) -> Double { return monto >= 1500 ? 0.0 : 30.0 }
}

class SucursalProvincia: Sucursal {
    override func costoEnvio(monto: Double) -> Double {
        let costo = monto * 0.08
        return costo < 50.0 ? 50.0 : costo
    }
}

class SucursalOutlet: Sucursal {
    override func descuento() -> Double { return 0.25 }
    override func costoEnvio(monto: Double) -> Double { return 0.0 }
}

class SucursalOnline: Sucursal {
    override func costoEnvio(monto: Double) -> Double { return 15.0 }
}

let refrigeradora = Electrodomestico(nombre: "Refrigeradora", marca: "Frost", precioLista: 2000.0, categoria: .lineaBlanca)
let licuadora = Electrodomestico(nombre: "Licuadora", marca: "Mix", precioLista: 250.0, categoria: .pequenos)

let sucursales: [Sucursal] = [
    SucursalLima(nombre: "Lima Centro", ciudad: "Lima"),
    SucursalProvincia(nombre: "Provincia Cusco", ciudad: "Cusco"),
    SucursalOutlet(nombre: "Outlet Ate", ciudad: "Lima"),
    SucursalOnline(nombre: "Tienda Web", ciudad: "Internet")
]

print("===== Refrigeradora =====")
for sucursal in sucursales { sucursal.cotizar(item: refrigeradora) }

print("===== Licuadora =====")
for sucursal in sucursales { sucursal.cotizar(item: licuadora) }