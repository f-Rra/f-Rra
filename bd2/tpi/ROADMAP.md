# Roadmap — TPI Base de Datos 2
**Sistema:** Recetario de empresa de provisión de servicios de almuerzos  
**Entrega PASO 3:** 22 de junio de 2026  
**Entrega PASO 4:** 29 de junio de 2026  

---

## ✅ Hecho
- [x] Descripción del sistema
- [x] Diagrama Entidad-Relación (DER) en drawdb.app
- [x] Documento .docx base para entrega

---

## Semana 1 — 20 al 26 de mayo
> Cerrar PASO 3 y sentar las bases del proyecto

### Moodle
- [ ] Insertar imagen del DER en el .docx
- [ ] Publicar minuta + solicitud de cursado individual en el foro (PASO 2)
- [ ] Subir entrega PASO 3 (descripción + DER)

### GitHub
- [ ] Crear repositorio `TPI-BD2-Recetario`
- [ ] Estructura de carpetas inicial:
```
TPI-BD2-Recetario/
├── Scripts/
│   ├── Creacion.sql
│   ├── Datos.sql
│   ├── Vistas/
│   ├── StoredProcedures/
│   └── Triggers/
├── App/
│   └── (proyecto WinForms — más adelante)
└── README.md
```

### SQL — Creacion.sql
Crear las tablas en el siguiente orden (respetando dependencias entre FK):

1. `Clasificaciones`
2. `Unidades`
3. `Usuarios`
4. `Proveedores`
5. `Equipo`
6. `Ingredientes`
7. `Recetas`
8. `PrecioxIngrediente`
9. `IngredientesxRecetas`
10. `Procedimientos`
11. `Comandas`
12. `Modificaciones`
13. `Costos`
14. `MovimientosStock`

Cada tabla debe incluir:
- PK con `IDENTITY(1,1)`
- FK con `FOREIGN KEY REFERENCES`
- Restricciones `NOT NULL` / `NULL` según corresponda
- `DEFAULT` donde aplica (Activo = 1, Rendimiento = 100, StockActual = 0)
- Nomenclatura de constraints: `PK_Tabla`, `FK_Tabla_TablaReferenciada`

### SQL — Datos.sql
Insertar datos de prueba suficientes para probar todas las funcionalidades:
- 3-4 clasificaciones (Entrada, Plato Principal, Postre, Decoración)
- 4-5 unidades (kg, g, L, ml, unidad)
- 2 usuarios (1 líder de cocina, 1 admin)
- 3 proveedores
- 5-6 integrantes de equipo (1-2 por sector)
- 10+ ingredientes
- 5+ recetas con sus ingredientes y procedimientos
- Precios vigentes por ingrediente/proveedor
- Movimientos de stock de ejemplo
- 2-3 comandas con modificaciones

---

## Semana 2 — 27 de mayo al 2 de junio
> Vistas

### Vista_Comanda.sql
Vista para el personal de cocina. Muestra los ingredientes de una receta en formato legible.  
**No incluye:** costos, costo unitario, incidencia.  
**Incluye:** nombre de receta, clasificación, nombre del ingrediente, cantidad, unidad de display (abreviatura).

```sql
-- Columnas esperadas:
-- NombreReceta, Clasificacion, NombreIngrediente, Cantidad, Unidad
```

### Vista_CostoReceta.sql
Vista para administración. Muestra el detalle de costos de cada receta con los precios vigentes.  
**Incluye:** nombre de receta, nombre del ingrediente, cantidad bruta, unidad, costo unitario, costo total por ingrediente, costo total de la receta.

```sql
-- Columnas esperadas:
-- NombreReceta, NombreIngrediente, CantBruta, Unidad, CostoUnitario, CostoIngrediente, CostoTotalReceta
```

### Vista_StockCritico.sql
Vista para el dashboard administrativo. Lista los ingredientes cuyo stock actual está por debajo del mínimo.  
**Incluye:** código del ingrediente, descripción, stock actual, stock mínimo, unidad, diferencia.

```sql
-- Columnas esperadas:
-- Codigo, Descripcion, StockActual, StockMinimo, Unidad, Diferencia
```

### Minuta
- [ ] Publicar minuta de avance semanal en el foro

---

## Semana 3 — 3 al 9 de junio
> Stored Procedures

### SP_RegistrarComanda.sql
Registra la ejecución de una receta.  
**Parámetros:** `@IdReceta`, `@Porciones`, `@IdUsuario`  
**Lógica:**
1. Buscar el integrante del equipo cuyo `IdClasificacion` coincide con el de la receta
2. Insertar en `Comandas` con el `IdIntegrante` encontrado
3. Retornar el `IdComanda` generado

```sql
-- sp_RegistrarComanda @IdReceta INT, @Porciones INT, @IdUsuario BIGINT
```

### SP_CalcularCostoReceta.sql
Calcula el costo de una receta con los precios vigentes y guarda el resultado en `Costos`.  
**Parámetros:** `@IdReceta`, `@Porciones`, `@IdUsuario`  
**Lógica:**
1. Para cada ingrediente de la receta, obtener el precio más reciente de `PrecioxIngrediente`
2. Calcular `CostoIngrediente = CantBruta * PrecioUnitario`
3. Sumar todos los costos → `CostoTotal`
4. Calcular `CostoUnitario = CostoTotal / @Porciones`
5. Insertar en `Costos`

```sql
-- sp_CalcularCostoReceta @IdReceta INT, @Porciones INT, @IdUsuario BIGINT
```

### SP_EscalarReceta.sql
Devuelve las cantidades de ingredientes ajustadas a una cantidad de comensales dada.  
**Parámetros:** `@IdReceta`, `@Comensales`  
**Lógica:**
1. Obtener los ingredientes de la receta con sus cantidades base (`PorcionesBase`)
2. Calcular `CantidadAjustada = (CantNeta / PorcionesBase) * @Comensales`
3. Retornar el resultado como SELECT (no inserta nada)

```sql
-- sp_EscalarReceta @IdReceta INT, @Comensales INT
```

### Minuta
- [ ] Publicar minuta de avance semanal en el foro

---

## Semana 4 — 10 al 16 de junio
> Triggers + Estructura base WinForms

### TRG_ActualizarStockMovimiento.sql
Se dispara después de un INSERT en `MovimientosStock`.  
**Lógica:**
- Si `Tipo = 'entrada'` → sumar `Cantidad` al `StockActual` del ingrediente
- Si `Tipo = 'salida'` → restar `Cantidad` al `StockActual` del ingrediente
- Si `Tipo = 'ajuste'` → reemplazar directamente el `StockActual`

```sql
-- AFTER INSERT ON MovimientosStock
```

### TRG_ActualizarStockModificacion.sql
Se dispara después de un INSERT en `Modificaciones`.  
**Lógica:**
- Si hay `IdIngredienteOriginal` (sustitución o eliminación) → reponer ese stock
- Si hay `IdIngredienteReemplazo` (sustitución o adición) → descontar ese stock

```sql
-- AFTER INSERT ON Modificaciones
```

### WinForms — Estructura base
Crear proyecto C# WinForms con arquitectura de 3 capas:

```
App/
├── Dominio/
│   ├── Receta.cs
│   ├── Ingrediente.cs
│   ├── Proveedor.cs
│   ├── Usuario.cs
│   ├── Equipo.cs
│   ├── Comanda.cs
│   ├── Modificacion.cs
│   ├── Costo.cs
│   └── MovimientoStock.cs
│
├── Negocio/
│   ├── AccesoDatos.cs
│   ├── NegocioException.cs
│   ├── RecetaNegocio.cs
│   ├── IngredienteNegocio.cs
│   ├── ProveedorNegocio.cs
│   ├── UsuarioNegocio.cs
│   ├── ComandaNegocio.cs
│   ├── StockNegocio.cs
│   ├── CostoNegocio.cs
│   └── Mappers/
│       ├── RecetaMapper.cs
│       ├── IngredienteMapper.cs
│       └── (etc.)
│
└── Presentacion/
    ├── frmLogin.cs
    ├── frmPrincipal.cs
    ├── UserControls/
    │   ├── ucDashboardCocina.cs
    │   ├── ucDashboardAdmin.cs
    │   ├── ucRecetas.cs
    │   ├── ucIngredientes.cs
    │   ├── ucProveedores.cs
    │   └── ucStock.cs
    ├── Gestores/
    │   └── GestorNavegacion.cs
    └── Helpers/
        ├── MensajesUI.cs
        └── GeneradorPDF.cs   ← iTextSharp para la comanda
```

### Minuta
- [ ] Publicar minuta de avance semanal en el foro

---

## Semana 5 — 17 al 23 de junio
> WinForms — Pantallas principales

### Pantallas a completar

**frmLogin**
- Validar usuario y contraseña contra la BD
- Redirigir según `Rol` (cocina → `ucDashboardCocina`, admin → `ucDashboardAdmin`)

**ucDashboardCocina**
- Listar recetas del día filtradas por clasificación del usuario
- Selección múltiple de recetas
- Input de comensales
- Botón imprimir → llama a `sp_EscalarReceta` → genera PDF con iTextSharp
- Botón registrar comanda → llama a `sp_RegistrarComanda`
- Formulario para registrar modificaciones (sustituciones/adiciones)

**ucDashboardAdmin**
- Alertas de stock crítico (usando `Vista_StockCritico`)
- Acceso rápido: registrar entrada de mercadería, calcular costo de receta
- Historial de últimos movimientos de stock

**ucRecetas**
- ABM completo de recetas
- Gestión de ingredientes por receta (IngredientesxRecetas)
- Gestión de pasos del procedimiento

### Documento
- [ ] Actualizar .docx con capturas de la aplicación
- [ ] Agregar sección de scripts (vistas, SPs, triggers) al documento

---

## Semana 6 — 24 al 29 de junio
> Cierre y entrega final

### WinForms — Pantallas restantes
- `ucIngredientes` — ABM de ingredientes
- `ucProveedores` — ABM de proveedores + precios
- `ucStock` — Registrar movimientos, ver historial

### Documento final
- [ ] Completar todas las secciones del documento Word:
  - Descripción del sistema
  - DER (imagen)
  - Scripts SQL (creación, datos, vistas, SPs, triggers)
  - Capturas de la aplicación
  - Conclusiones
- [ ] Exportar a PDF

### Video demostrativo
Cubrir en el video:
1. Login con ambos perfiles (líder de cocina y admin)
2. Flujo completo de comanda: seleccionar receta → ingresar comensales → imprimir PDF
3. Registrar una modificación (sustitución de ingrediente)
4. Dashboard admin: alerta de stock crítico
5. Calcular costo de una receta
6. Registrar entrada de mercadería y ver cómo se actualiza el stock (trigger en acción)

### Entrega
- [ ] Subir todo al repositorio GitHub (organizado por carpetas)
- [ ] Publicar minuta de conclusión en el foro
- [ ] Subir PDF final al campus (PASO 4)

---

## Referencias técnicas

| Archivo | Descripción |
|---|---|
| `Creacion.sql` | CREATE TABLE de las 14 tablas en orden |
| `Datos.sql` | Datos de prueba |
| `Vista_Comanda.sql` | Vista sin costos para cocina |
| `Vista_CostoReceta.sql` | Vista con costos para admin |
| `Vista_StockCritico.sql` | Ingredientes bajo el mínimo |
| `SP_RegistrarComanda.sql` | Registra comanda + asigna integrante |
| `SP_CalcularCostoReceta.sql` | Calcula y guarda costo con precios vigentes |
| `SP_EscalarReceta.sql` | Escala cantidades a N comensales |
| `TRG_ActualizarStockMovimiento.sql` | Actualiza stock tras movimiento |
| `TRG_ActualizarStockModificacion.sql` | Actualiza stock tras modificación |
