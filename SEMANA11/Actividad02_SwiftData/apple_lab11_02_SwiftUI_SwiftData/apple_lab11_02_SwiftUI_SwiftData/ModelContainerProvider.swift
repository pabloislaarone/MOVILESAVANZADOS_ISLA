import Foundation
import SwiftData

@MainActor // Garantiza que esta clase se ejecute en el hilo principal (UI-safe)
class ModelContainerProvider {
    // Patrón Singleton: compartimos una única instancia del contenedor en toda la app
    static let shared = ModelContainerProvider()

    let container: ModelContainer // Contenedor principal de SwiftData

    private init() {
        // Esquema: las clases modelo que queremos persistir
        let schema = Schema([Alumno.self])

        do {
            // Dónde y cómo se guardará la base de datos SQLite
            let config = ModelConfiguration(
                "AlumnosData",
                schema: schema,
                url: FileManager.default
                    .urls(for: .applicationSupportDirectory, in: .userDomainMask)
                    .first!
                    .appendingPathComponent("AlumnosData.sqlite")
            )

            // Para ver dónde quedó el archivo
            print("Base de datos SQLite en: \(config.url.path)")

            container = try ModelContainer(for: schema, configurations: [config])
        } catch {
            fatalError("Error al inicializar ModelContainer: \(error)")
        }
    }
}
