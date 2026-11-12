import UIKit
import CoreData

// A9 · Resumen del supervisor (todo sale de fetch requests sobre ventas no anuladas)
class ResumenViewController: UIViewController {

    private let pila = UIStackView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        navigationItem.title = ""

        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        pila.axis = .vertical
        pila.spacing = 14
        pila.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scroll)
        scroll.addSubview(pila)
        NSLayoutConstraint.activate([
            scroll.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scroll.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scroll.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scroll.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            pila.leadingAnchor.constraint(equalTo: scroll.frameLayoutGuide.leadingAnchor, constant: 16),
            pila.trailingAnchor.constraint(equalTo: scroll.frameLayoutGuide.trailingAnchor, constant: -16),
            pila.topAnchor.constraint(equalTo: scroll.contentLayoutGuide.topAnchor, constant: 4),
            pila.bottomAnchor.constraint(equalTo: scroll.contentLayoutGuide.bottomAnchor, constant: -16)
        ])
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        construir()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }

    // MARK: - Consultas

    private func totalVendido(desde: Date, hasta: Date) -> Double {
        let request: NSFetchRequest<Venta> = Venta.fetchRequest()
        request.predicate = NSPredicate(format: "anulada == NO AND fecha >= %@ AND fecha < %@", desde as NSDate, hasta as NSDate)
        return redondear(BaseDeDatos.buscar(request).reduce(0) { $0 + $1.total })
    }

    private func ventasDelMes() -> [Venta] {
        let request: NSFetchRequest<Venta> = Venta.fetchRequest()
        request.predicate = NSPredicate(format: "anulada == NO AND fecha >= %@", Periodo.mes.desde! as NSDate)
        return BaseDeDatos.buscar(request)
    }

    private func productosStockBajo() -> [Producto] {
        let request: NSFetchRequest<Producto> = Producto.fetchRequest()
        request.predicate = NSPredicate(format: "stock <= %@", NSNumber(value: Reglas.stockBajo))
        request.sortDescriptors = [NSSortDescriptor(key: "stock", ascending: true)]
        return BaseDeDatos.buscar(request)
    }

    // MARK: - Pantalla

    private func construir() {
        pila.arrangedSubviews.forEach { $0.removeFromSuperview() }
        let cal = Calendar.current
        let hoy = cal.startOfDay(for: Date())
        let manana = cal.date(byAdding: .day, value: 1, to: hoy)!
        let ayer = cal.date(byAdding: .day, value: -1, to: hoy)!

        // ① Saludo con nombre y rol
        let usuario = Sesion.shared.usuario
        let fecha = Estilo.texto(Formato.fechaLarga(Date()), tamano: 13, color: .secondaryLabel)
        let primerNombre = usuario?.nombre?.split(separator: " ").first.map(String.init) ?? ""
        let saludo = Estilo.texto("Hola, \(primerNombre)", tamano: 28, peso: .bold)
        let rol = EtiquetaColor(texto: usuario?.rol ?? "", color: .systemPurple)
        let filaSaludo = UIStackView(arrangedSubviews: [saludo, rol])
        filaSaludo.alignment = .center
        saludo.setContentHuggingPriority(.defaultLow, for: .horizontal)
        let cabecera = UIStackView(arrangedSubviews: [fecha, filaSaludo])
        cabecera.axis = .vertical
        cabecera.spacing = 2
        pila.addArrangedSubview(cabecera)

        // ② Indicadores con comparación contra el día anterior
        let vendidoHoy = totalVendido(desde: hoy, hasta: manana)
        let vendidoAyer = totalVendido(desde: ayer, hasta: hoy)
        let comparacion: (String, UIColor)
        if vendidoAyer > 0 {
            let cambio = (vendidoHoy - vendidoAyer) / vendidoAyer * 100
            comparacion = (String(format: "%@ %.0f%% vs ayer", cambio >= 0 ? "▲" : "▼", abs(cambio)), cambio >= 0 ? .systemGreen : .systemRed)
        } else {
            comparacion = ("Sin ventas ayer", .secondaryLabel)
        }
        let igvMes = redondear(ventasDelMes().reduce(0) { $0 + $1.igv })
        let filaIndicadores = UIStackView(arrangedSubviews: [
            indicador("Vendido hoy", Formato.soles(vendidoHoy), comparacion.0, comparacion.1),
            indicador("IGV del mes", Formato.soles(igvMes), "18 % de las ventas del mes", .secondaryLabel)
        ])
        filaIndicadores.spacing = 12
        filaIndicadores.distribution = .fillEqually
        pila.addArrangedSubview(filaIndicadores)

        // ③ Gráfico de barras de los últimos 7 días
        var valores: [Double] = []
        var etiquetas: [String] = []
        let letras = ["D", "L", "M", "X", "J", "V", "S"] // domingo = 1 en Calendar
        for dias in (0...6).reversed() {
            let inicio = cal.date(byAdding: .day, value: -dias, to: hoy)!
            let fin = cal.date(byAdding: .day, value: 1, to: inicio)!
            valores.append(totalVendido(desde: inicio, hasta: fin))
            etiquetas.append(letras[cal.component(.weekday, from: inicio) - 1])
        }
        let barras = BarrasView(valores: valores, etiquetas: etiquetas)
        barras.heightAnchor.constraint(equalToConstant: 130).isActive = true
        pila.addArrangedSubview(seccion("Ventas de los últimos 7 días (S/)", [barras]))

        // ④ Ranking de vendedores del mes (relación venta ▸ vendedor)
        var porVendedor: [String: Double] = [:]
        for venta in ventasDelMes() {
            porVendedor[venta.vendedor?.nombre ?? "Sin vendedor", default: 0] += venta.total
        }
        let ranking = porVendedor.sorted { $0.value > $1.value }
        let maximo = ranking.first?.value ?? 1
        let filasRanking: [UIView] = ranking.isEmpty
            ? [Estilo.texto("Aún no hay ventas este mes.", tamano: 13, color: .secondaryLabel)]
            : ranking.map { filaRanking($0.key, $0.value, maximo) }
        pila.addArrangedSubview(seccion("Ranking de vendedores (mes)", filasRanking))

        // ⑤ Productos con stock bajo
        let bajos = productosStockBajo()
        let filasStock: [UIView] = bajos.isEmpty
            ? [Estilo.texto("Ningún producto con stock bajo.", tamano: 13, color: .secondaryLabel)]
            : bajos.map { filaStock($0) }
        pila.addArrangedSubview(seccion("Stock bajo (≤ \(Reglas.stockBajo))", filasStock))
    }

    private func indicador(_ titulo: String, _ valor: String, _ nota: String, _ colorNota: UIColor) -> UIView {
        let tarjeta = Estilo.tarjeta()
        let t = Estilo.texto(titulo, tamano: 12, color: .secondaryLabel)
        let v = Estilo.texto(valor, tamano: 21, peso: .bold)
        v.adjustsFontSizeToFitWidth = true
        v.numberOfLines = 1
        let n = Estilo.texto(nota, tamano: 11, peso: .medium, color: colorNota)
        let p = UIStackView(arrangedSubviews: [t, v, n])
        p.axis = .vertical
        p.spacing = 3
        incrustar(p, en: tarjeta)
        return tarjeta
    }

    private func seccion(_ titulo: String, _ contenido: [UIView]) -> UIView {
        let tarjeta = Estilo.tarjeta()
        let p = UIStackView(arrangedSubviews: [Estilo.texto(titulo, tamano: 12, color: .secondaryLabel)] + contenido)
        p.axis = .vertical
        p.spacing = 10
        incrustar(p, en: tarjeta)
        return tarjeta
    }

    private func filaRanking(_ nombre: String, _ monto: Double, _ maximo: Double) -> UIView {
        let texto = NSMutableAttributedString(string: nombre, attributes: [.font: UIFont.systemFont(ofSize: 14, weight: .semibold)])
        texto.append(NSAttributedString(string: " · \(Formato.soles(monto))", attributes: [.font: UIFont.systemFont(ofSize: 13), .foregroundColor: UIColor.secondaryLabel]))
        let etiqueta = UILabel()
        etiqueta.attributedText = texto
        let barra = UIProgressView(progressViewStyle: .default)
        barra.progress = Float(maximo > 0 ? monto / maximo : 0)
        let p = UIStackView(arrangedSubviews: [etiqueta, barra])
        p.axis = .vertical
        p.spacing = 6
        return p
    }

    private func filaStock(_ producto: Producto) -> UIView {
        let texto = Estilo.texto("\(producto.nombre ?? "") · \(producto.stock) u.", tamano: 14, peso: .semibold)
        let etiqueta = EtiquetaColor(texto: "Reponer", color: .systemRed)
        let fila = UIStackView(arrangedSubviews: [texto, etiqueta])
        fila.alignment = .center
        texto.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return fila
    }

    private func incrustar(_ contenido: UIView, en tarjeta: UIView) {
        contenido.translatesAutoresizingMaskIntoConstraints = false
        tarjeta.addSubview(contenido)
        NSLayoutConstraint.activate([
            contenido.leadingAnchor.constraint(equalTo: tarjeta.leadingAnchor, constant: 14),
            contenido.trailingAnchor.constraint(equalTo: tarjeta.trailingAnchor, constant: -14),
            contenido.topAnchor.constraint(equalTo: tarjeta.topAnchor, constant: 12),
            contenido.bottomAnchor.constraint(equalTo: tarjeta.bottomAnchor, constant: -12)
        ])
    }
}

// Gráfico de barras simple dibujado a mano (el último día, hoy, va resaltado)
final class BarrasView: UIView {
    private let valores: [Double]
    private let etiquetas: [String]

    init(valores: [Double], etiquetas: [String]) {
        self.valores = valores
        self.etiquetas = etiquetas
        super.init(frame: .zero)
        backgroundColor = .clear
        isAccessibilityElement = true
        accessibilityLabel = "Gráfico de ventas de los últimos 7 días"
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) no se usa") }

    override func draw(_ rect: CGRect) {
        let maximo = max(valores.max() ?? 0, 1)
        let altoEtiqueta: CGFloat = 16
        let altoDisponible = rect.height - altoEtiqueta - 4
        let ancho = rect.width / CGFloat(valores.count)
        let anchoBarra = ancho * 0.6

        for (i, valor) in valores.enumerated() {
            let alto = max(CGFloat(valor / maximo) * altoDisponible, valor > 0 ? 3 : 1)
            let x = CGFloat(i) * ancho + (ancho - anchoBarra) / 2
            let barra = UIBezierPath(roundedRect: CGRect(x: x, y: altoDisponible - alto, width: anchoBarra, height: alto), cornerRadius: 4)
            let esHoy = i == valores.count - 1
            (esHoy ? UIColor.systemBlue : UIColor.systemBlue.withAlphaComponent(0.25)).setFill()
            barra.fill()

            let atributos: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 11), .foregroundColor: UIColor.secondaryLabel]
            let texto = etiquetas[i] as NSString
            let tamano = texto.size(withAttributes: atributos)
            texto.draw(at: CGPoint(x: CGFloat(i) * ancho + (ancho - tamano.width) / 2, y: rect.height - altoEtiqueta), withAttributes: atributos)
        }
    }
}
