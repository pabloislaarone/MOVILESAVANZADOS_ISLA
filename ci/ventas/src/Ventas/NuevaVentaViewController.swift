import UIKit
import CoreData

// A5 · Nueva venta (solo vendedor)
class NuevaVentaViewController: UITableViewController {

    private var cliente: Cliente?
    private var producto: Producto?
    private var cantidad = 1

    private let stepper = UIStepper()
    private let campoCantidad = UITextField()

    init() { super.init(style: .insetGrouped) }
    required init?(coder: NSCoder) { fatalError("init(coder:) no se usa") }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Nueva venta"
        tableView.keyboardDismissMode = .onDrag

        stepper.minimumValue = 1
        stepper.maximumValue = 999
        stepper.value = 1
        stepper.addTarget(self, action: #selector(cambioStepper), for: .valueChanged)

        campoCantidad.text = "1"
        campoCantidad.keyboardType = .numberPad
        campoCantidad.textAlignment = .center
        campoCantidad.font = .systemFont(ofSize: 17, weight: .semibold)
        campoCantidad.accessibilityIdentifier = "cantidad"
        campoCantidad.widthAnchor.constraint(equalToConstant: 44).isActive = true
        campoCantidad.addTarget(self, action: #selector(cambioCampo), for: .editingChanged)

        // Barra sobre el teclado numérico con el botón Listo
        let barra = UIToolbar()
        barra.sizeToFit()
        barra.items = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Listo", style: .done, target: self, action: #selector(cerrarTeclado))
        ]
        campoCantidad.inputAccessoryView = barra

        tableView.tableHeaderView = cabeceraVendedor()
        tableView.tableFooterView = pieRegistrar()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData() // el stock o la categoría pudieron cambiar
    }

    // ① Vendedor de la sesión (automático, no editable)
    private func cabeceraVendedor() -> UIView {
        let contenedor = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 84))
        let caja = UIView()
        caja.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.1)
        caja.layer.cornerRadius = 12

        let usuario = Sesion.shared.usuario
        let avatar = AvatarView(tamano: 36)
        avatar.configurar(nombre: usuario?.nombre ?? "")
        let nombre = Estilo.texto("\(usuario?.nombre ?? "") · \(usuario?.rol ?? "")", tamano: 14, peso: .semibold, color: .systemBlue)
        let nota = Estilo.texto("Sesión iniciada · la venta se registra a tu nombre", tamano: 12, color: .secondaryLabel)
        let textos = UIStackView(arrangedSubviews: [nombre, nota])
        textos.axis = .vertical
        textos.spacing = 2
        let fila = UIStackView(arrangedSubviews: [avatar, textos])
        fila.spacing = 10
        fila.alignment = .center

        [caja, fila].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        contenedor.addSubview(caja)
        caja.addSubview(fila)
        NSLayoutConstraint.activate([
            caja.leadingAnchor.constraint(equalTo: contenedor.leadingAnchor, constant: 20),
            caja.trailingAnchor.constraint(equalTo: contenedor.trailingAnchor, constant: -20),
            caja.topAnchor.constraint(equalTo: contenedor.topAnchor, constant: 12),
            caja.bottomAnchor.constraint(equalTo: contenedor.bottomAnchor, constant: -4),
            fila.leadingAnchor.constraint(equalTo: caja.leadingAnchor, constant: 12),
            fila.trailingAnchor.constraint(equalTo: caja.trailingAnchor, constant: -12),
            fila.centerYAnchor.constraint(equalTo: caja.centerYAnchor)
        ])
        return contenedor
    }

    // ⑥ Registrar venta
    private func pieRegistrar() -> UIView {
        let contenedor = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 80))
        let boton = Estilo.botonPrincipal("Registrar venta")
        boton.addTarget(self, action: #selector(registrar), for: .touchUpInside)
        boton.translatesAutoresizingMaskIntoConstraints = false
        contenedor.addSubview(boton)
        NSLayoutConstraint.activate([
            boton.leadingAnchor.constraint(equalTo: contenedor.leadingAnchor, constant: 20),
            boton.trailingAnchor.constraint(equalTo: contenedor.trailingAnchor, constant: -20),
            boton.topAnchor.constraint(equalTo: contenedor.topAnchor, constant: 8)
        ])
        return contenedor
    }

    // MARK: - Cálculo

    private var categoria: Categoria { cliente?.categoria ?? .regular }

    private var calculo: CalculoVenta {
        return CalculoVenta(precio: producto?.precio ?? 0, cantidad: cantidad, categoria: categoria)
    }

    @objc private func cambioStepper() {
        cantidad = Int(stepper.value)
        campoCantidad.text = "\(cantidad)"
        recalcular()
    }

    @objc private func cambioCampo() {
        cantidad = max(Int(campoCantidad.text ?? "") ?? 0, 0)
        stepper.value = Double(max(cantidad, 1))
        recalcular()
    }

    @objc private func cerrarTeclado() {
        view.endEditing(true)
    }

    private func recalcular() {
        tableView.reloadSections(IndexSet(integer: 1), with: .none)
    }

    // MARK: - Tabla

    override func numberOfSections(in tableView: UITableView) -> Int { 2 }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 3 : 4
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 1 ? "Resumen (calculado)" : nil
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = UITableViewCell(style: .value1, reuseIdentifier: nil)
        celda.selectionStyle = .none

        if indexPath.section == 0 {
            switch indexPath.row {
            case 0: // ② Cliente
                celda.textLabel?.text = "Cliente"
                celda.detailTextLabel?.text = cliente.map { "\($0.nombre ?? "") (\($0.categoria.rawValue))" } ?? "Elegir"
                celda.accessoryType = .disclosureIndicator
                celda.selectionStyle = .default
            case 1: // ③ Producto
                celda.textLabel?.text = "Producto"
                celda.detailTextLabel?.text = producto?.nombre ?? "Elegir"
                celda.accessoryType = .disclosureIndicator
                celda.selectionStyle = .default
            default: // ④ Cantidad con stepper y stock disponible
                let texto = NSMutableAttributedString(string: "Cantidad ")
                if let p = producto {
                    texto.append(NSAttributedString(string: "(stock \(p.stock))", attributes: [
                        .font: UIFont.systemFont(ofSize: 13), .foregroundColor: UIColor.secondaryLabel
                    ]))
                }
                celda.textLabel?.attributedText = texto
                let control = UIStackView(arrangedSubviews: [campoCantidad, stepper])
                control.spacing = 6
                control.alignment = .center
                control.frame = CGRect(x: 0, y: 0, width: 150, height: 34)
                celda.accessoryView = control
            }
        } else {
            // ⑤ Resumen calculado
            let c = calculo
            switch indexPath.row {
            case 0:
                celda.textLabel?.text = "Subtotal"
                celda.detailTextLabel?.text = Formato.soles(c.subtotal)
            case 1:
                let pct = Int(categoria.porcentajeDescuento * 100)
                celda.textLabel?.text = categoria == .vip ? "Descuento VIP \(pct)%" : "Descuento (\(categoria.rawValue) 0%)"
                celda.detailTextLabel?.text = "− " + Formato.soles(c.descuento)
            case 2:
                celda.textLabel?.text = "IGV 18%"
                celda.detailTextLabel?.text = Formato.soles(c.igv)
            default:
                celda.textLabel?.text = "Total"
                celda.textLabel?.font = .systemFont(ofSize: 17, weight: .bold)
                celda.detailTextLabel?.text = Formato.soles(c.total)
                celda.detailTextLabel?.font = .systemFont(ofSize: 17, weight: .bold)
                celda.detailTextLabel?.textColor = .label
            }
        }
        return celda
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard indexPath.section == 0 else { return }

        if indexPath.row == 0 {
            let request: NSFetchRequest<Cliente> = Cliente.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(key: "nombre", ascending: true)]
            let lista = BaseDeDatos.buscar(request)
            let opciones = lista.map { ($0.nombre ?? "", "\($0.categoria.rawValue) · \($0.documento ?? "")") }
            abrirSeleccion("Cliente", opciones) { [weak self] i in self?.cliente = lista[i] }
        } else if indexPath.row == 1 {
            let request: NSFetchRequest<Producto> = Producto.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(key: "nombre", ascending: true)]
            let lista = BaseDeDatos.buscar(request)
            let opciones = lista.map { ($0.nombre ?? "", "\(Formato.soles($0.precio)) · stock \($0.stock)") }
            abrirSeleccion("Producto", opciones) { [weak self] i in self?.producto = lista[i] }
        } else {
            campoCantidad.becomeFirstResponder()
        }
    }

    private func abrirSeleccion(_ titulo: String, _ opciones: [(String, String)], alElegir: @escaping (Int) -> Void) {
        let vc = SeleccionViewController(titulo: titulo, opciones: opciones) { [weak self] indice in
            alElegir(indice)
            self?.tableView.reloadData()
        }
        navigationController?.pushViewController(vc, animated: true)
    }

    // MARK: - Registrar (CREATE + baja de stock)

    @objc private func registrar() {
        view.endEditing(true)
        guard let cliente = cliente, let producto = producto else {
            mostrarAlerta("Faltan datos", "Elige un cliente y un producto.")
            return
        }
        guard cantidad >= 1 else {
            mostrarAlerta("Cantidad no válida", "La cantidad debe ser al menos 1.")
            return
        }
        // Stock: si la cantidad supera el stock, no se registra
        if Int64(cantidad) > producto.stock {
            mostrarAlerta("Stock insuficiente", "Solo hay \(producto.stock) unidades de \(producto.nombre ?? "este producto"). La venta no se registró.")
            return
        }

        let c = calculo
        let venta = Venta(context: BaseDeDatos.contexto)
        venta.fecha = Date()
        venta.cantidad = Int64(cantidad)
        venta.precioUnitario = producto.precio
        venta.descuento = c.descuento
        venta.igv = c.igv
        venta.total = c.total
        venta.anulada = false
        venta.vendedor = Sesion.shared.usuario   // relación venta ▸ vendedor
        venta.cliente = cliente                  // relación venta ▸ cliente
        venta.producto = producto                // relación venta ▸ producto
        producto.stock -= Int64(cantidad)        // baja el stock

        if BaseDeDatos.guardar() {
            let mensaje = "Total \(Formato.soles(c.total)) · stock de \(producto.nombre ?? ""): \(producto.stock)"
            mostrarAlerta("Venta registrada", mensaje) { [weak self] in self?.limpiar() }
        } else {
            mostrarAlerta("Error", "No se pudo registrar la venta.")
        }
    }

    private func limpiar() {
        cliente = nil
        producto = nil
        cantidad = 1
        stepper.value = 1
        campoCantidad.text = "1"
        tableView.reloadData()
    }
}

// Lista simple para elegir cliente o producto
class SeleccionViewController: UITableViewController {
    private let opciones: [(String, String)]
    private let alElegir: (Int) -> Void

    init(titulo: String, opciones: [(String, String)], alElegir: @escaping (Int) -> Void) {
        self.opciones = opciones
        self.alElegir = alElegir
        super.init(style: .insetGrouped)
        title = titulo
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) no se usa") }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return opciones.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        celda.textLabel?.text = opciones[indexPath.row].0
        celda.detailTextLabel?.text = opciones[indexPath.row].1
        celda.detailTextLabel?.textColor = .secondaryLabel
        return celda
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        alElegir(indexPath.row)
        navigationController?.popViewController(animated: true)
    }
}
