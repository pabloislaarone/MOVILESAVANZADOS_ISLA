import UIKit
import UIKit.UIGestureRecognizerSubclass

// Piezas visuales que se repiten en varias pantallas

// MARK: - Etiqueta con relleno (para "VIP", "40 u.", "Anulada", etc.)

final class EtiquetaColor: UILabel {
    private let relleno = UIEdgeInsets(top: 2, left: 7, bottom: 2, right: 7)

    convenience init(texto: String = "", color: UIColor = .systemGray) {
        self.init(frame: .zero)
        font = .systemFont(ofSize: 11, weight: .semibold)
        textColor = .white
        layer.cornerRadius = 8
        layer.masksToBounds = true
        textAlignment = .center
        setContentHuggingPriority(.required, for: .horizontal)
        setContentCompressionResistancePriority(.required, for: .horizontal)
        configurar(texto: texto, color: color)
    }

    func configurar(texto: String, color: UIColor) {
        text = texto
        backgroundColor = color
        isHidden = texto.isEmpty
    }

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: relleno))
    }

    override var intrinsicContentSize: CGSize {
        let s = super.intrinsicContentSize
        return CGSize(width: s.width + relleno.left + relleno.right, height: s.height + relleno.top + relleno.bottom)
    }
}

// MARK: - Avatar con iniciales

final class AvatarView: UILabel {
    convenience init(tamano: CGFloat = 36) {
        self.init(frame: .zero)
        textAlignment = .center
        textColor = .white
        font = .systemFont(ofSize: tamano * 0.38, weight: .bold)
        layer.cornerRadius = tamano * 0.28
        layer.masksToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: tamano).isActive = true
        heightAnchor.constraint(equalToConstant: tamano).isActive = true
    }

    func configurar(nombre: String) {
        text = Estilo.iniciales(nombre)
        backgroundColor = Estilo.colorPara(nombre)
    }
}

// MARK: - Chips horizontales (categorías o vendedores)

final class ChipsView: UIScrollView {
    private let fila = UIStackView()
    private var botones: [UIButton] = []
    private(set) var seleccionado = 0
    var alCambiar: ((Int) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        showsHorizontalScrollIndicator = false
        fila.axis = .horizontal
        fila.spacing = 8
        fila.translatesAutoresizingMaskIntoConstraints = false
        addSubview(fila)
        NSLayoutConstraint.activate([
            fila.leadingAnchor.constraint(equalTo: contentLayoutGuide.leadingAnchor, constant: 16),
            fila.trailingAnchor.constraint(equalTo: contentLayoutGuide.trailingAnchor, constant: -16),
            fila.topAnchor.constraint(equalTo: contentLayoutGuide.topAnchor),
            fila.bottomAnchor.constraint(equalTo: contentLayoutGuide.bottomAnchor),
            fila.heightAnchor.constraint(equalTo: frameLayoutGuide.heightAnchor),
            heightAnchor.constraint(equalToConstant: 32)
        ])
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) no se usa") }

    func configurar(opciones: [String], seleccionado: Int) {
        botones.forEach { $0.removeFromSuperview() }
        botones = opciones.enumerated().map { indice, titulo in
            let boton = UIButton(type: .system)
            boton.setTitle(titulo, for: .normal)
            boton.titleLabel?.font = .systemFont(ofSize: 13, weight: .medium)
            boton.contentEdgeInsets = UIEdgeInsets(top: 6, left: 14, bottom: 6, right: 14)
            boton.layer.cornerRadius = 15
            boton.tag = indice
            boton.addTarget(self, action: #selector(tocar(_:)), for: .touchUpInside)
            fila.addArrangedSubview(boton)
            return boton
        }
        self.seleccionado = min(seleccionado, max(opciones.count - 1, 0))
        pintar()
    }

    @objc private func tocar(_ boton: UIButton) {
        seleccionado = boton.tag
        pintar()
        alCambiar?(seleccionado)
    }

    private func pintar() {
        for boton in botones {
            let activo = boton.tag == seleccionado
            boton.backgroundColor = activo ? .systemBlue : .secondarySystemGroupedBackground
            boton.setTitleColor(activo ? .white : .label, for: .normal)
            boton.isSelected = activo
        }
    }
}

// MARK: - Funciones de ayuda

enum Estilo {

    static func iniciales(_ nombre: String) -> String {
        let palabras = nombre.split(separator: " ").filter { !$0.isEmpty }
        let letras = palabras.prefix(2).compactMap { $0.first }.map { String($0) }
        return letras.joined().uppercased()
    }

    static func colorPara(_ texto: String) -> UIColor {
        let colores: [UIColor] = [.systemBlue, .systemPurple, .systemTeal, .systemIndigo, .systemPink, .systemOrange, .systemGreen]
        let suma = texto.unicodeScalars.reduce(0) { $0 + Int($1.value) }
        return colores[suma % colores.count]
    }

    static func colorStock(_ stock: Int64) -> UIColor {
        if stock > 10 { return .systemGreen }
        if stock >= 6 { return .systemOrange }
        return .systemRed
    }

    // Tarjeta blanca con un título pequeño en mayúsculas y un campo de texto (login y registro)
    static func campoTarjeta(titulo: String, placeholder: String, id: String, seguro: Bool = false) -> (UIView, UITextField) {
        let tarjeta = UIView()
        tarjeta.backgroundColor = .secondarySystemGroupedBackground
        tarjeta.layer.cornerRadius = 12

        let etiqueta = UILabel()
        etiqueta.text = titulo.uppercased()
        etiqueta.font = .systemFont(ofSize: 11, weight: .medium)
        etiqueta.textColor = .secondaryLabel

        let campo = UITextField()
        campo.placeholder = placeholder
        campo.isSecureTextEntry = seguro
        campo.autocapitalizationType = .none
        campo.autocorrectionType = .no
        campo.font = .systemFont(ofSize: 16)
        campo.accessibilityIdentifier = id
        campo.returnKeyType = .done
        campo.addAction(UIAction { _ in }, for: .editingDidEndOnExit) // la tecla Listo cierra el teclado
        // Sin autollenado de contraseñas: así iOS no ofrece "Guardar contraseña" (es una práctica)
        campo.textContentType = .oneTimeCode

        let pila = UIStackView(arrangedSubviews: [etiqueta, campo])
        pila.axis = .vertical
        pila.spacing = 4
        pila.translatesAutoresizingMaskIntoConstraints = false
        tarjeta.addSubview(pila)
        NSLayoutConstraint.activate([
            pila.leadingAnchor.constraint(equalTo: tarjeta.leadingAnchor, constant: 14),
            pila.trailingAnchor.constraint(equalTo: tarjeta.trailingAnchor, constant: -14),
            pila.topAnchor.constraint(equalTo: tarjeta.topAnchor, constant: 10),
            pila.bottomAnchor.constraint(equalTo: tarjeta.bottomAnchor, constant: -10)
        ])
        return (tarjeta, campo)
    }

    static func botonPrincipal(_ titulo: String) -> UIButton {
        let boton = UIButton(type: .system)
        boton.setTitle(titulo, for: .normal)
        boton.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        boton.backgroundColor = .systemBlue
        boton.setTitleColor(.white, for: .normal)
        boton.layer.cornerRadius = 12
        boton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return boton
    }

    // Tarjeta genérica (Resumen e indicadores)
    static func tarjeta() -> UIView {
        let v = UIView()
        v.backgroundColor = .secondarySystemGroupedBackground
        v.layer.cornerRadius = 14
        return v
    }

    static func texto(_ valor: String, tamano: CGFloat = 15, peso: UIFont.Weight = .regular, color: UIColor = .label) -> UILabel {
        let l = UILabel()
        l.text = valor
        l.font = .systemFont(ofSize: tamano, weight: peso)
        l.textColor = color
        l.numberOfLines = 0
        return l
    }
}

// Toque fuera de los campos para ocultar el teclado.
// Si el toque cae sobre un control (un campo o un botón), el gesto no hace nada:
// así tocar otro campo no le quita el foco.
final class ToqueFuera: UITapGestureRecognizer {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        if touches.first?.view is UIControl {
            state = .failed
            return
        }
        super.touchesBegan(touches, with: event)
    }
}

extension UIViewController {
    func ocultarTecladoAlTocarFuera() {
        let toque = ToqueFuera(target: view, action: #selector(UIView.endEditing(_:)))
        toque.cancelsTouchesInView = false
        view.addGestureRecognizer(toque)
    }

    func mostrarAlerta(_ titulo: String, _ mensaje: String, alCerrar: (() -> Void)? = nil) {
        let alerta = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
        alerta.addAction(UIAlertAction(title: "OK", style: .default) { _ in alCerrar?() })
        present(alerta, animated: true)
    }
}

// Pie de tabla con una nota en gris (por ejemplo, "Solo aparecen las ventas de este vendedor.")
func notaPie(_ texto: String) -> UIView {
    let contenedor = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 44))
    let l = Estilo.texto(texto, tamano: 12, color: .secondaryLabel)
    l.translatesAutoresizingMaskIntoConstraints = false
    contenedor.addSubview(l)
    NSLayoutConstraint.activate([
        l.leadingAnchor.constraint(equalTo: contenedor.leadingAnchor, constant: 20),
        l.trailingAnchor.constraint(equalTo: contenedor.trailingAnchor, constant: -20),
        l.topAnchor.constraint(equalTo: contenedor.topAnchor, constant: 8)
    ])
    return contenedor
}
