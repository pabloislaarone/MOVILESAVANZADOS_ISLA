import SwiftUI
import SwiftData

// UPDATE: editar un alumno existente.
// @Bindable permite enlazar los campos directamente a las propiedades del objeto @Model.
// SwiftData detecta el cambio y lo guarda solo.
struct EditarAlumnoView: View {
    @Bindable var alumno: Alumno
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Datos del Alumno")) {
                    TextField("Apellido", text: $alumno.apellido)
                    TextField("Nombre", text: $alumno.nombre)
                    TextField("DNI", text: $alumno.dni)
                        .keyboardType(.numberPad)
                }
            }
            .navigationTitle("Editar Alumno")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Listo") {
                        dismiss()
                    }
                }
            }
        }
    }
}
