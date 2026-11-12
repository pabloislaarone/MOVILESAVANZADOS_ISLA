import UIKit
import CoreData

// A6 · Mis ventas (vendedor) y A7 · Ventas del equipo (supervisor)
// Ambas pantallas usan la misma clase; cambia el modo.
class VentasViewController: UITableViewController, UISearchResultsUpdating {

    enum Modo { case mias, equipo }

    private let modo: Modo
    private var ventas: [Venta] = []
    private var vendedores: [Usuario] = []

    private let periodo = UISegmentedControl(items: ["Todas", "Hoy", "Mes"])
    private let chipsVendedor = ChipsView()
    private let buscador = UISearchController(searchResultsController: nil)
    private let indicadorHoy = UILabel()
    private let detalleHoy = UILabel()
    private let indicadorMes = UILabel()
    private let detalleMes = UILabel()

    init(modo: Modo) {
        self.modo = modo
        super.init(style: .insetGrouped)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) no se usa") }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = modo == .mias ? "Mis ventas" : "Ventas del equipo"
        navigationItem.rightBarButtonItem = botonIniciales()
        tableView.register(VentaCelda.self, forCellReuseIdentifier: "venta")

        // ③ Búsqueda por cliente
        buscador.searchResultsUpdater = self
        buscador.obscuresBackgroundDuringPresentation = false
        buscador.searchBar.placeholder = "Buscar por cliente"
        navigationItem.searchController = buscador
        navigationItem.hidesSearchBarWhenScrolling = false

        // ② Segmented Todas / Hoy / Mes
        periodo.selectedSegmentIndex = Periodo.hoy.rawValue
        periodo.addTarget(self, action: #selector(cargar), for: .valueChanged)

        chipsVendedor.alCambiar = { [weak self] _ in self?.cargar() }

        tableView.tableHeaderView = construirCabecera()
        tableView.tableFooterView = notaPie(modo == .mias
            ? "Solo aparecen las ventas de este vendedor."
            : "El nombre del vendedor se lee de la relación venta ▸ vendedor.")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if modo == .equipo {
            vendedores = Usuario.vendedores()
            let nombres = ["Todos"] + vendedores.map { $0.nombre ?? "" }
            chipsVendedor.configurar(opciones: nombres, seleccionado: chipsVendedor.seleccionado)
        }
        cargar()
    }

    // Botón de la barra con las iniciales del usuario de la sesión
    private func botonIniciales() -> UIBarButtonItem {
        let etiqueta = UILabel()
        etiqueta.text = Estilo.iniciales(Sesion.shared.usuario?.nombre ?? "")
        etiqueta.font = .systemFont(ofSize: 13, weight: .semibold)
        etiqueta.textColor = .systemBlue
        return UIBarButtonItem(customView: etiqueta)
    }

    private func construirCabecera() -> UIView {
        var piezas: [UIView] = []

        if modo == .mias {
            // ① Indicadores propios: hoy y mes
            let fila = UIStackView(arrangedSubviews: [
                tarjetaIndicador("Hoy", indicadorHoy, detalleHoy),
                tarjetaIndicador("Mes", indicadorMes, detalleMes)
            ])
            fila.spacing = 12
            fila.distribution = .fillEqually
            piezas.append(fila)
        }
        piezas.append(periodo)
        if modo == .equipo {
            piezas.append(chipsVendedor) // ① Chips por vendedor
        }

        let pila = UIStackView(arrangedSubviews: piezas)
        pila.axis = .vertical
        pila.spacing = 12
        pila.translatesAutoresizingMaskIntoConstraints = false

        let alto: CGFloat = modo == .mias ? 136 : 92
        let contenedor = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: alto))
        contenedor.addSubview(pila)
        NSLayoutConstraint.activate([
            pila.leadingAnchor.constraint(equalTo: contenedor.leadingAnchor, constant: 20),
            pila.trailingAnchor.constraint(equalTo: contenedor.trailingAnchor, constant: -20),
            pila.topAnchor.constraint(equalTo: contenedor.topAnchor, constant: 8)
        ])
        if modo == .equipo {
            // los chips van de borde a borde
            chipsVendedor.translatesAutoresizingMaskIntoConstraints = false
        }
        return contenedor
    }

    private func tarjetaIndicador(_ titulo: String, _ valor: UILabel, _ detalle: UILabel) -> UIView {
        let tarjeta = Estilo.tarjeta()
        let t = Estilo.texto(titulo, tamano: 12, color: .secondaryLabel)
        valor.font = .systemFont(ofSize: 20, weight: .bold)
        detalle.font = .systemFont(ofSize: 11)
        detalle.textColor = .secondaryLabel
        let pila = UIStackView(arrangedSubviews: [t, valor, detalle])
        pila.axis = .vertical
        pila.spacing = 2
        pila.translatesAutoresizingMaskIntoConstraints = false
        tarjeta.addSubview(pila)
        NSLayoutConstraint.activate([
            pila.leadingAnchor.constraint(equalTo: tarjeta.leadingAnchor, constant: 12),
            pila.trailingAnchor.constraint(equalTo: tarjeta.trailingAnchor, constant: -12),
            pila.topAnchor.constraint(equalTo: tarjeta.topAnchor, constant: 10),
            pila.bottomAnchor.constraint(equalTo: tarjeta.bottomAnchor, constant: -10)
        ])
        return tarjeta
    }

    // MARK: - Fetch con NSPredicate (vendedor, fechas, relación y búsqueda)

    @objc private func cargar() {
        let request: NSFetchRequest<Venta> = Venta.fetchRequest()
        var filtros: [NSPredicate] = []

        // Visibilidad: el vendedor solo ve sus ventas
        if modo == .mias, let usuario = Sesion.shared.usuario {
            filtros.append(NSPredicate(format: "vendedor == %@", usuario))
        }
        // Filtro por vendedor (chip) en Ventas del equipo
        if modo == .equipo, chipsVendedor.seleccionado > 0, let elegido = vendedores[safe: chipsVendedor.seleccionado - 1] {
            filtros.append(NSPredicate(format: "vendedor == %@", elegido))
        }
        // Periodo: Hoy o Mes
        if let desde = Periodo(rawValue: periodo.selectedSegmentIndex)?.desde {
            filtros.append(NSPredicate(format: "fecha >= %@", desde as NSDate))
        }
        // Búsqueda por cliente (recorre la relación venta ▸ cliente)
        let texto = buscador.searchBar.text ?? ""
        if !texto.isEmpty {
            filtros.append(NSPredicate(format: "cliente.nombre CONTAINS[cd] %@", texto))
        }

        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: filtros)
        request.sortDescriptors = [NSSortDescriptor(key: "fecha", ascending: false)]
        ventas = BaseDeDatos.buscar(request)

        if modo == .mias { actualizarIndicadores() }
        tableView.reloadData()
    }

    private func actualizarIndicadores() {
        guard let usuario = Sesion.shared.usuario else { return }
        for (periodoIndicador, valor, detalle) in [(Periodo.hoy, indicadorHoy, detalleHoy), (Periodo.mes, indicadorMes, detalleMes)] {
            let request: NSFetchRequest<Venta> = Venta.fetchRequest()
            request.predicate = NSPredicate(format: "vendedor == %@ AND anulada == NO AND fecha >= %@", usuario, periodoIndicador.desde! as NSDate)
            let lista = BaseDeDatos.buscar(request)
            valor.text = Formato.soles(lista.reduce(0) { $0 + $1.total })
            detalle.text = "\(lista.count) venta" + (lista.count == 1 ? "" : "s")
        }
    }

    func updateSearchResults(for searchController: UISearchController) {
        cargar()
    }

    // MARK: - Tabla

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ventas.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "venta", for: indexPath) as! VentaCelda
        celda.configurar(ventas[indexPath.row], mostrarVendedor: modo == .equipo)
        celda.selectionStyle = .none
        return celda
    }

    // ③ Deslizar para Anular: solo supervisor y solo ventas no anuladas
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard modo == .equipo, Sesion.shared.esSupervisor else { return nil }
        let venta = ventas[indexPath.row]
        guard !venta.anulada else { return nil }
        let anular = UIContextualAction(style: .destructive, title: "Anular") { [weak self] _, _, terminado in
            self?.pedirMotivo(venta)
            terminado(true)
        }
        let config = UISwipeActionsConfiguration(actions: [anular])
        config.performsFirstActionWithFullSwipe = false
        return config
    }

    // A8 · Alerta de anulación con motivo obligatorio
    private func pedirMotivo(_ venta: Venta) {
        let resumen = "\(venta.cliente?.nombre ?? "") · \(venta.producto?.nombre ?? "") × \(venta.cantidad) · \(Formato.soles(venta.total))"
        let alerta = UIAlertController(title: "Anular venta",
                                       message: "\(resumen)\nEl stock se devolverá (+\(venta.cantidad)).",
                                       preferredStyle: .alert)
        alerta.addTextField {
            $0.placeholder = "Motivo (obligatorio)"
            $0.accessibilityIdentifier = "motivo"
            $0.autocapitalizationType = .sentences
        }

        let accionAnular = UIAlertAction(title: "Anular", style: .destructive) { [weak self] _ in
            let motivo = (alerta.textFields?.first?.text ?? "").trimmingCharacters(in: .whitespaces)
            self?.anular(venta, motivo: motivo)
        }
        accionAnular.isEnabled = false // deshabilitado mientras el motivo esté vacío

        alerta.textFields?.first?.addAction(UIAction { _ in
            let texto = (alerta.textFields?.first?.text ?? "").trimmingCharacters(in: .whitespaces)
            accionAnular.isEnabled = !texto.isEmpty
        }, for: .editingChanged)

        alerta.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        alerta.addAction(accionAnular)
        present(alerta, animated: true)
    }

    // Anular: marca la venta, guarda el motivo y devuelve el stock
    private func anular(_ venta: Venta, motivo: String) {
        guard !motivo.isEmpty else { return }
        venta.anulada = true
        venta.motivoAnulacion = motivo
        if let producto = venta.producto {
            producto.stock += venta.cantidad
        }
        BaseDeDatos.guardar()
        cargar()
    }
}

// Fila de venta: ④ venta propia (check) · ⑤ venta anulada (tachada, con etiqueta) · ② nombre del vendedor
final class VentaCelda: UITableViewCell {
    private let icono = UIImageView()
    private let avatar = AvatarView(tamano: 34)
    private let cliente = Estilo.texto("", tamano: 15, peso: .semibold)
    private let detalle = Estilo.texto("", tamano: 12, color: .secondaryLabel)
    private let etiquetaAnulada = EtiquetaColor(texto: "Anulada", color: .systemRed)
    private let motivo = Estilo.texto("", tamano: 11, color: .systemRed)
    private let total = Estilo.texto("", tamano: 15, peso: .semibold)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        icono.contentMode = .scaleAspectFit
        icono.translatesAutoresizingMaskIntoConstraints = false
        icono.widthAnchor.constraint(equalToConstant: 30).isActive = true
        icono.heightAnchor.constraint(equalToConstant: 30).isActive = true
        cliente.numberOfLines = 1
        detalle.numberOfLines = 1
        motivo.numberOfLines = 1

        let filaAnulada = UIStackView(arrangedSubviews: [etiquetaAnulada, motivo])
        filaAnulada.spacing = 6
        filaAnulada.alignment = .center
        let textos = UIStackView(arrangedSubviews: [cliente, detalle, filaAnulada])
        textos.axis = .vertical
        textos.spacing = 2
        textos.alignment = .leading
        let fila = UIStackView(arrangedSubviews: [icono, avatar, textos, total])
        fila.spacing = 10
        fila.alignment = .center
        textos.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        total.setContentCompressionResistancePriority(.required, for: .horizontal)
        total.setContentHuggingPriority(.required, for: .horizontal)
        fila.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(fila)
        NSLayoutConstraint.activate([
            fila.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 14),
            fila.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -14),
            fila.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 9),
            fila.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -9)
        ])
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) no se usa") }

    func configurar(_ venta: Venta, mostrarVendedor: Bool) {
        let nombreCliente = venta.cliente?.nombre ?? ""
        let producto = "\(venta.producto?.nombre ?? "") × \(venta.cantidad)"

        if mostrarVendedor {
            // A7: avatar del cliente y "Vendedor · Producto × n" (relación venta ▸ vendedor)
            icono.isHidden = true
            avatar.isHidden = false
            avatar.configurar(nombre: nombreCliente)
            let primerNombre = venta.vendedor?.nombre?.split(separator: " ").first.map(String.init) ?? ""
            detalle.text = "\(primerNombre) · \(producto)"
        } else {
            // A6: check verde o x roja y "dd/MM · Producto × n"
            icono.isHidden = false
            avatar.isHidden = true
            let simbolo = venta.anulada ? "xmark.square.fill" : "checkmark.square.fill"
            icono.image = UIImage(systemName: simbolo)
            icono.tintColor = venta.anulada ? .systemRed : .systemGreen
            detalle.text = "\(Formato.diaMes(venta.fecha)) · \(producto)"
        }

        let textoTotal = Formato.soles(venta.total)
        if venta.anulada {
            let tachado: [NSAttributedString.Key: Any] = [.strikethroughStyle: NSUnderlineStyle.single.rawValue, .foregroundColor: UIColor.secondaryLabel]
            cliente.attributedText = NSAttributedString(string: nombreCliente, attributes: tachado)
            total.attributedText = NSAttributedString(string: textoTotal, attributes: tachado)
            etiquetaAnulada.isHidden = false
            motivo.text = venta.motivoAnulacion
            motivo.isHidden = false
        } else {
            cliente.attributedText = nil
            cliente.text = nombreCliente
            cliente.textColor = .label
            total.attributedText = nil
            total.text = textoTotal
            total.textColor = .label
            etiquetaAnulada.isHidden = true
            motivo.isHidden = true
        }
    }
}
