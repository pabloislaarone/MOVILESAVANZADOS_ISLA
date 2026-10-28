# Prompts utilizados
Semana 10 · Tema de análisis: Boleta de pago

## Herramienta de IA utilizada
Claude

## Prompt (estructura CTRFE)

**Contexto:**
Soy estudiante de Programación en Móviles Avanzado, semana 10. Trabajo en equipo de dos: uno explica el Excel y el otro la app. El tema es la boleta de pago peruana (art. 19 del D.S. 001-98-TR) con tres bloques: remuneraciones, retenciones/descuentos y aportaciones del empleador, más el neto.

**Tarea:**
1. App SwiftUI de una sola pantalla (formulario arriba, boleta abajo al pulsar Calcular), usando solo Text, VStack, HStack, @State, TextField, Picker, Button y ScrollView.
2. Modelo separado de la vista: structs para los datos, una clase `Boleta` que calcula, un diccionario con las tasas de cada AFP y un array con los conceptos.
3. Reglas: sueldo computable = básico ÷ 30 × días; asignación familiar 10% de la RMV (S/ 1,230) si tiene hijos; valor hora = básico ÷ 30 ÷ 8; horas extras ×1.25 y ×1.35; ONP 13% o AFP (fondo, comisión y seguro) sobre el total de remuneraciones; adelantos; neto; EsSalud 9% a cargo del empleador.
4. Excel con hojas Parámetros, Boleta, Casos y Explicación, con fórmulas visibles y cada fórmula explicada en palabras con un ejemplo.

**Restricciones:**
- Los parámetros van en un solo lugar (constantes en Swift, hoja Parámetros en Excel).
- Cada concepto se redondea a 2 decimales y luego se suman.
- Validaciones: sueldo > 0, días entre 1 y 30, horas y adelantos ≥ 0; si algo falla, mensaje claro y no se calcula.
- La pantalla dice "Boleta de ejemplo"; datos de personas y empresa ficticios.

**Formato:**
Archivos `.swift` completos, un `.xlsx` y las respuestas de análisis en Markdown.

**Ejemplo / validación:**
App y Excel deben dar lo mismo al centavo en los 4 casos: caso 1 → neto 2,175.00; caso 2 → 1,516.41; caso 3 → 2,631.73; caso 4 lo revisa el docente.

## Qué se ajustó a mano
- Se usó `Decimal` en vez de `Double` para que el redondeo a 2 decimales sea igual al `ROUND` de Excel (con `Double`, 43.9155 podía quedar en 43.91).
- El valor hora no se redondea porque es un paso intermedio; así se hace en la app y en el Excel.
