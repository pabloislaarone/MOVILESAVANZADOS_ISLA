import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        // El nombre debe coincidir con el archivo Ventas.xcdatamodeld
        let container = NSPersistentContainer(name: "Ventas")

        // Con -reiniciar se borra el archivo SQLite antes de abrirlo (base limpia para las pruebas)
        if ProcessInfo.processInfo.arguments.contains("-reiniciar") {
            let url = NSPersistentContainer.defaultDirectoryURL().appendingPathComponent("Ventas.sqlite")
            for sufijo in ["", "-wal", "-shm"] {
                try? FileManager.default.removeItem(at: URL(fileURLWithPath: url.path + sufijo))
            }
        }

        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
            print("Base de datos SQLite en: \(storeDescription.url?.path ?? "sin ruta")")
        })
        return container
    }()
}
