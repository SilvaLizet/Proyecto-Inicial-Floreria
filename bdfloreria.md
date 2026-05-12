Aquí tienes el modelo entidad-relación para el proyecto **Floeria** (florería). Las 8 entidades principales y su lógica:
<img width="678" height="590" alt="image" src="https://github.com/user-attachments/assets/8e389bdb-365c-4eea-b4a1-61fc81af1253" />

**Núcleo del negocio**
- `CLIENTE` → registra a quienes compran arreglos y flores
- `PEDIDO` → el corazón de la operación; conecta al cliente con lo que compra y quién lo atiende
- `DETALLE_PEDIDO` → desglosa cada producto dentro de un pedido (tabla puente)
- `PRODUCTO` → catálogo de flores, arreglos y plantas

**Soporte operativo**
- `CATEGORIA` → organiza productos (rosas, orquídeas, arreglos fúnebres, etc.)
- `PROVEEDOR` → proveedores de flores y materiales
- `EMPLEADO` → floristas y vendedores que gestionan pedidos
- `PAGO` → registro de cobros por pedido (permite pagos parciales o múltiples métodos)

Algunas consideraciones adicionales según el negocio:

- Si manejan **entregas a domicilio**, convendría agregar una entidad `ENVIO` con dirección, repartidor y horario.
- Si tienen **diseños personalizados**, se puede agregar `ARREGLO` como entidad separada de productos simples.
- El campo `temporada` en `PRODUCTO` es útil para flores de disponibilidad limitada (tulipanes en primavera, nochebuenas en diciembre).

**Las entidades con sus atributos y tipo en forma de tabla para cada una de las entidades**
**Tablas**
<img width="595" height="540" alt="image" src="https://github.com/user-attachments/assets/3f2d2aca-1b0e-4217-9211-58c605ae3afe" />
<img width="600" height="546" alt="image" src="https://github.com/user-attachments/assets/4fe57478-d155-4496-8735-fa68aa38a1eb" />
<img width="594" height="624" alt="image" src="https://github.com/user-attachments/assets/9910241f-c8e8-4a2f-bbf1-a6b04dab669a" />
<img width="588" height="287" alt="image" src="https://github.com/user-attachments/assets/cf8be0ef-57a6-4d29-8495-5b25549d099a" />
Ahí tienes las 8 entidades con todos sus atributos, tipos de dato y restricciones. Algunos puntos a destacar:

- `DECIMAL(10,2)` se usa en todos los campos monetarios para manejar correctamente los centavos sin errores de punto flotante.
- Los campos `estado` en `PEDIDO` y `PAGO` usan `ENUM` para restringir los valores permitidos directamente desde el motor de base de datos.
- `precio_unitario` se guarda en `DETALLE_PEDIDO` además de en `PRODUCTO` para preservar el precio histórico al momento de la venta, ya que el precio del producto puede cambiar.
- Los campos `email` de `CLIENTE` y `EMPLEADO` llevan restricción `UNIQUE` para evitar duplicados.

**De acuerdo a tu respuesta anterior puedes generar un script en sql para descargar con el nombre bdfloreria para las 10 relaciones**
