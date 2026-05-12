
## Prompt para la IA

Actúa como un mentor y arquitecto de software experto para guiarme en la creación de Aura, una aplicación profesional de gestión para una florería y centro de jardinería. El objetivo es desarrollar una solución multiplataforma (Android, Web y Windows) utilizando Flutter y Firebase. Restricción absoluta: No utilices el paquete "provider" para la gestión del estado; en su lugar, organiza el proyecto de forma limpia mediante servicios o lógica nativa que sea fácil de entender para un principiante.

No generes el código todavía. Necesito que primero redactes un documento de planificación maestro, sumamente detallado y extenso en formato Markdown, que incluya los siguientes puntos:

1. Estructura de Carpetas y Documentos:

Define y explica minuciosamente cómo organizar el proyecto en VS Code. Detalla el propósito de cada carpeta (ej. models/, views/, services/, widgets/). La estructura debe ser tan clara que un desarrollador junior pueda navegar el proyecto de Aura sin confusiones y entender dónde se procesan los datos y dónde se dibuja la interfaz. Incluye una representación visual de la jerarquía de carpetas.

2. Identidad Visual (Paleta Lila/Morada) y UX:

Diseña una propuesta visual elegante para Aura utilizando tonos lilas, lavandas y morados profundos. Aplica la regla de contraste: texto negro sobre fondos claros y texto blanco sobre fondos oscuros. Explica cómo aplicar estos colores en botones de acción, encabezados y estados de selección para que la app luzca profesional y moderna.

3. Arquitectura de Datos en Firestore (Tablas y Campos):

Detalla la estructura (tambien incluye ejemplo visual en formato tabla)de la base de datos NoSQL de forma exhaustiva. Define las siguientes colecciones con sus campos específicos:

Articulos (Flores/Plantas): ID, nombre, descripción, precio, stock, categoría_id, y imagen_url (vinculada a GitHub).

Categorias: ID, nombre_categoria, descripción y color_identificador.

Clientes: ID, nombre_completo, teléfono, correo y fecha_registro.

Empleados: ID, nombre, puesto, correo y nivel_acceso (rol).

Ventas: ID, cliente_id, empleado_id, fecha, total, estado y un sub-listado de articulos_vendidos.

Proveedores: ID, nombre_empresa, contacto, teléfono y RFC.

Facturas: ID, venta_id, numero_factura, fecha_emision y estado_pago.

4. Integración con Firebase y Gestión de Imágenes desde GitHub:

Explica detalladamente para principiantes cómo conectar la app con Firebase. Describe el método técnico para que las imágenes de los productos se carguen mediante URLs alojadas en un repositorio de GitHub, explicando cómo guardar ese enlace en Firestore para que la app lo consuma dinámicamente sin ocupar espacio de almacenamiento en Firebase Storage.

5. Dependencias Críticas (pubspec.yaml):

Presenta una lista detallada de las librerías necesarias, explicando para qué sirve cada una (ej. cloud_firestore para datos, firebase_auth para usuarios, cached_network_image para las fotos de GitHub, intl para fechas y monedas).

6. Plan de Desarrollo Paso a Paso (Fases Detalladas):

Divide el proyecto en fases lógicas y extensas (Preparación, Autenticación, Inventario, Ventas y Facturación). Para cada fase, brinda instrucciones narrativas profundas sobre:

Fase de Base de Datos: Cómo mapear los objetos de la florería a documentos JSON.

Fase de UI: Cómo diseñar la jerarquía de widgets para las tarjetas de flores y los formularios de venta.

Fase de Servicios: Cómo crear funciones que descuenten stock automáticamente al confirmar una venta.

7. Recomendaciones de Nivel Senior:

Brinda consejos sobre optimización de imágenes externas, manejo de errores en la conexión y trucos de arquitectura para que el proyecto sea escalable y fácil de mantener.

Asegúrate de que este documento sea una hoja de ruta total, con pasos largos y bien explicados que no omitan ninguna funcionalidad, garantizando que el proyecto Aura sea un éxito absoluto desde la planificación. No incluyas bloques de código, solo la explicación detallada de los procesos.

## Lizet Alejandra Silva Martinez 6J
