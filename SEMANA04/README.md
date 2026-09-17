# 🚇 Sistema de Consulta - Metro de Lima

Aplicación de consola desarrollada en **Swift** que permite a los usuarios consultar e interactuar con la información sobre las estaciones, líneas y conexiones del sistema de transporte de Lima (Línea 1, Línea 2 y Metropolitano).

---

## 📋 Requerimientos Funcionales

El proyecto satisface los siguientes requerimientos funcionales:

### 1. Carga e Inicialización de Datos
* **RF01 - Carga de la red de transporte:** Cargar de forma automática la base de datos local con las estaciones de la Línea 1, Línea 2 y el Metropolitano, detallando disponibilidad, accesibilidad (ascensores), alertas de construcción e interconexiones.
* **RF02 - Mapeo de destinos populares:** Asociar lugares de interés de la ciudad (como el *Estadio Nacional*) con su estación de transporte pública más cercana o idónea.

### 2. Búsqueda y Consultas
* **RF03 - Búsqueda interactiva por nombre:** Permitir buscar estaciones mediante coincidencias parciales de texto, soportando variaciones en mayúsculas y minúsculas (case-insensitive).
* **RF04 - Detalle de estación:** Mostrar la ficha de información técnica de la estación seleccionada, indicando:
  * Línea a la que pertenece
  * Estado actual (*Operativa* / *En construcción*)
  * Disponibilidad de ascensor
  * Avisos especiales o advertencias
  * Conexiones o transbordos con otras líneas
* **RF05 - Recomendación por lugar de destino:** Sugerir la estación correcta al ingresar el nombre de un lugar de interés popular registrado.
* **RF06 - Filtrado y ordenamiento por línea:** Generar un reporte con todas las estaciones pertenecientes a una línea específica, listadas en orden alfabético y mostrando su estado operativo.

### 3. Interfaz y Experiencia de Usuario
* **RF07 - Menú interactivo por CLI:** Proveer una navegación mediante menú numérico en bucle continuo hasta que el usuario decida salir.
* **RF08 - Manejo de errores y mensajes de estado:** Notificar claramente al usuario en caso de ingresar opciones inválidas, realizar búsquedas sin coincidencias o consultar destinos no registrados.

---

## 🏗️ Modelo de Datos

El programa implementa las siguientes estructuras principales:

* **`Conexion`**: Representa un punto de transferencia entre la estación actual y otra línea/estación.
* **`Estacion`**: Modelo central que almacena el nombre, línea, estado operativo, presencia de ascensor, array de `Conexion` y advertencias de servicio.
* **`diccionarioEstaciones`**: Diccionario llave-valor (`[String: Estacion]`) para búsquedas rápidas por nombre o identificador.
* **`destinosPopulares`**: Mapeo (`[String: String]`) entre nombres de lugares y claves de estaciones recomendadas.

---

## 💻 Instrucciones de Ejecución

### Requisitos previos
* Tener instalado el compilador o Toolchain de **Swift** (v5.0 o superior).

### Pasos para ejecutar
1. Clona o descarga el archivo fuente (por ejemplo, `main.swift`).
2. Abre la terminal en el directorio del proyecto.
3. Ejecuta el archivo directamente con el siguiente comando:

```bash
swift main.swift
```

---

## 📌 Ejemplo de Uso

```text
=== SISTEMA DE METRO LIMA ===
1. Buscar una estación
2. Consultar cómo llegar a un destino
3. Ver estaciones por línea
4. Salir
Elige una opción: 1

Ingresa el nombre de la estación: Central

========================================
🚇 ESTACIÓN: Central (MET)
📍 Línea: Metropolitano
🛠️ Estado: Operativa
🛗 Ascensor: Sí
⚠️ Info: Conectará mediante túnel con L2.
========================================
```