import UIKit

// Sesión: un único objeto compartido que recuerda al usuario conectado mientras la app está abierta
final class Sesion {
    static let shared = Sesion()
    private init() {}

    var usuario: Usuario?

    var esSupervisor: Bool { usuario?.esSupervisor ?? false }

    func iniciar(_ usuario: Usuario) {
        self.usuario = usuario
        Navegacion.irALaApp()
    }

    func cerrar() {
        usuario = nil
        Navegacion.irAlLogin()
    }
}

// Cambia la pantalla raíz de la ventana: login <-> pestañas del rol
enum Navegacion {

    private static var ventana: UIWindow? {
        let escena = UIApplication.shared.connectedScenes.first as? UIWindowScene
        return (escena?.delegate as? SceneDelegate)?.window
    }

    static func irAlLogin() {
        cambiarRaiz(UINavigationController(rootViewController: LoginViewController()))
    }

    static func irALaApp() {
        guard let usuario = Sesion.shared.usuario else { return }
        cambiarRaiz(MainTabBarController(usuario: usuario))
    }

    private static func cambiarRaiz(_ vc: UIViewController) {
        guard let ventana = ventana else { return }
        ventana.rootViewController = vc
        UIView.transition(with: ventana, duration: 0.3, options: .transitionCrossDissolve, animations: nil)
    }
}
