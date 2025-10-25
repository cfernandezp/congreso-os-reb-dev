# PLAN DE TESTING - Módulo Rebajas y Devoluciones
## Ventana: w_pr_rebaja_devolucion_add

---

## PREREQUISITOS PARA TESTING

### 1. Datos de Prueba Necesarios
Antes de comenzar, asegúrate de tener:

- **Un período en estado PROCESO** (ej: "2024-10")
- **Un período en estado CERRADO** (ej: "2024-09")
- **Un empleado con conceptos en planilla** (ej: empleado 12345)
- **TipoPlanilla válido** (ej: "RE" = Regular)
- **TipoProceso válido** (ej: "NOR" = Normal)
- **Conjunto de conceptos configurado** (ej: "PRECONESP" con concepto "0051")

### 2. Verificar Tablas Base
```sql
-- Verificar que existan períodos configurados
SELECT * FROM PR_PlanillaPeriodo_Rebaja_Devolucion

-- Verificar empleado con conceptos
SELECT * FROM PR_PlanillaEmpleadoConcepto
WHERE Empleado = 12345 AND Periodo = '2024-10'

-- Verificar días trabajados
SELECT * FROM PR_PlanillaEmpleado
WHERE Empleado = 12345 AND Periodo = '2024-10'

-- Verificar conjunto de conceptos
SELECT * FROM PR_ConjuntoDetalle WHERE Conjunto = 'PRECONESP'
```

---

## CASOS DE PRUEBA

### **CASO 1: Crear Nueva REBAJA (Período en PROCESO)**

**Objetivo:** Verificar que se puede crear una nueva rebaja cuando el período está en proceso.

**Pasos:**
1. Abrir ventana con estos parámetros:
   ```powerbuilder
   str_pass str_pass
   str_pass.s[1] = "2024-10"  // Período en PROCESO
   str_pass.s[2] = "RE"       // TipoPlanilla
   str_pass.s[3] = "NOR"      // TipoProceso
   str_pass.s[4] = "12345"    // Empleado
   str_pass.s[5] = "NOMBRE DEL EMPLEADO"  // Nombre
   str_pass.s[6] = "30"       // DiasTrabajados
   OpenWithParm(w_pr_rebaja_devolucion_add, str_pass)
   ```

2. Observar la carga inicial

**Resultados Esperados:**
- ✅ Ventana abre sin errores
- ✅ Título: "Nueva Rebaja/Devolución - Empleado: 12345 - Periodo: 2024-10"
- ✅ dw_2 (cabecera) tiene 1 fila con:
  - TipoRegistro = 'R' (REBAJA)
  - Estado = 'T' (TRAMITE)
  - Periodo, TipoPlanilla, TipoProceso, Empleado correctos
  - DiasTrabajadosOriginal > 0
- ✅ dw_3 (detalle) muestra todos los conceptos del empleado
- ✅ MontoOriginal = MontoFinal (inicialmente iguales)
- ✅ MontoAjuste = 0 (inicialmente)
- ✅ Mensaje: "Se cargaron X conceptos... Días trabajados: Y"

**Validaciones:**
- ❌ Si no hay conceptos: mensaje "No se encontraron conceptos para el empleado"
- ❌ Si período no existe: mensaje "El período no existe en la tabla"

---

### **CASO 2: Crear Nueva DEVOLUCIÓN (Período CERRADO)**

**Objetivo:** Verificar que se puede crear una devolución cuando el período está cerrado.

**Pasos:**
1. Abrir ventana con período CERRADO:
   ```powerbuilder
   lst_param.as_periodo = "2024-09"  // Período CERRADO
   lst_param.as_tipoplanilla = "RE"
   lst_param.as_tipoproceso = "NOR"
   lst_param.al_empleado = 12345
   lst_param.as_modo = "NUEVO"
   ```

**Resultados Esperados:**
- ✅ TipoRegistro = 'D' (DEVOLUCIÓN)
- ✅ Todo lo demás igual que CASO 1

---

### **CASO 3: Modificar MontoFinal Manualmente**

**Objetivo:** Verificar que el cálculo automático de MontoAjuste funciona.

**Pasos:**
1. Crear nueva rebaja (CASO 1)
2. En dw_3, seleccionar una fila
3. Modificar el campo "Debe Decir" (montofinal):
   - Si Dice = 1000.00, cambiar a 1200.00
4. Presionar Tab o Enter

**Resultados Esperados:**
- ✅ MontoAjuste se calcula automáticamente = 200.00 (1200 - 1000)
- ✅ Si cambias a 800.00: MontoAjuste = -200.00

---

### **CASO 4: Recálculo Proporcional de Conceptos**

**Objetivo:** Verificar que el recálculo proporcional funciona correctamente.

**Pasos:**
1. Crear nueva rebaja (CASO 1)
2. Anotar días trabajados originales (ej: 30 días)
3. Anotar MontoOriginal de conceptos del grupo PRECONESP (ej: concepto 0051 = 3000.00)
4. Llamar a la función de recálculo:
   ```powerbuilder
   // Supongamos que hay un botón "Recalcular" en la ventana
   // o llamar directamente a:
   wf_recalcular_conceptos(25, "PRECONESP")  // 25 días nuevos
   ```

**Resultados Esperados:**
- ✅ Mensaje: "Recálculo completado: Días originales: 30, Días nuevos: 25, Conceptos recalculados: X"
- ✅ Conceptos del grupo PRECONESP se recalculan:
  - Nuevo MontoFinal = 3000 × (25/30) = 2500.00
- ✅ Conceptos que NO están en PRECONESP NO cambian
- ✅ MontoAjuste se actualiza automáticamente para todos
- ✅ Si días nuevos = días originales: mensaje "No es necesario recalcular"

**Fórmula Verificación:**
```
MontoFinal_Nuevo = MontoOriginal × (DiasNuevos / DiasOriginales)
```

---

### **CASO 5: Grabar Nueva Rebaja/Devolución**

**Objetivo:** Verificar que se graba correctamente en la base de datos.

**Pasos:**
1. Crear nueva rebaja (CASO 1)
2. Modificar algunos MontoFinal
3. Llamar a wf_grabar() (debe haber un botón "Grabar" en la ventana)

**Resultados Esperados:**
- ✅ Cabecera se graba en PR_RebajaDevolucionCab:
  - IdRebajaDevolucion > 0 (generado automáticamente)
  - TotalMonto = suma de todos los MontoAjuste
  - FechaCreacion = fecha actual
  - UsuarioCreacion = usuario actual
- ✅ Detalle se graba en PR_RebajaDevolucionDet:
  - Todas las filas tienen IdRebajaDevolucion asignado
  - Se graban TODOS los conceptos (incluso con MontoAjuste = 0)
- ✅ Mensaje: "Rebaja/Devolución grabada exitosamente. ID: X, Total Ajuste: Y"
- ✅ COMMIT ejecutado (datos persisten en BD)
- ✅ Modo cambia de "NUEVO" a "EDITAR"

**Validación en BD:**
```sql
-- Verificar cabecera
SELECT * FROM PR_RebajaDevolucionCab
WHERE IdRebajaDevolucion = [ID_GENERADO]

-- Verificar detalle
SELECT * FROM PR_RebajaDevolucionDet
WHERE IdRebajaDevolucion = [ID_GENERADO]

-- Verificar suma
SELECT SUM(MontoAjuste) FROM PR_RebajaDevolucionDet
WHERE IdRebajaDevolucion = [ID_GENERADO]
-- Debe coincidir con TotalMonto de cabecera
```

---

### **CASO 6: Editar Rebaja/Devolución Existente**

**Objetivo:** Verificar que se puede editar un registro existente.

**Pasos:**
1. Primero crear y grabar una rebaja (CASO 5)
2. Cerrar la ventana
3. Volver a abrir en modo EDITAR:
   ```powerbuilder
   lst_param.as_modo = "EDITAR"
   lst_param.al_idrebajadevolucion = [ID_GENERADO_EN_CASO_5]
   ```

**Resultados Esperados:**
- ✅ Ventana abre sin errores
- ✅ Título: "Editar Rebaja/Devolución - ID: X - Empleado: Y - Periodo: Z"
- ✅ Cabecera carga correctamente
- ✅ Detalle carga todos los conceptos
- ✅ Valores coinciden con lo grabado anteriormente
- ✅ Se puede modificar MontoFinal
- ✅ Al grabar, hace UPDATE (no INSERT)

---

### **CASO 7: Validación - Rebaja Duplicada**

**Objetivo:** Verificar que no se puede crear rebaja duplicada.

**Pasos:**
1. Crear y grabar una rebaja para empleado 12345, período 2024-10 (CASO 5)
2. Sin cerrar, intentar crear OTRA rebaja con mismos parámetros:
   ```powerbuilder
   lst_param.as_periodo = "2024-10"
   lst_param.al_empleado = 12345
   lst_param.as_modo = "NUEVO"
   ```

**Resultados Esperados:**
- ❌ Ventana NO abre
- ❌ Mensaje: "Ya existe una REBAJA en trámite para este empleado: ID: X, Estado: T"
- ❌ Mensaje: "Debe consolidar o anular el registro existente antes de crear uno nuevo"

---

### **CASO 8: Validación - Editar Registro NO Editable**

**Objetivo:** Verificar que no se puede editar un registro consolidado/anulado.

**Pasos:**
1. En BD, cambiar manualmente un registro a estado 'A' (ANULADA):
   ```sql
   UPDATE PR_RebajaDevolucionCab
   SET Estado = 'A'
   WHERE IdRebajaDevolucion = [ID]
   ```
2. Intentar abrir en modo EDITAR

**Resultados Esperados:**
- ❌ Ventana NO abre
- ❌ Mensaje: "Este registro no puede ser modificado. Estado actual: A"

**Estados Editables:** Solo 'T' (TRAMITE) y 'C' (CONSOLIDADA)
**Estados NO Editables:** 'R' (CON RECTIFICATORIA), 'D' (CON DEVOLUCION), 'A' (ANULADA)

---

### **CASO 9: Validación - Período Inválido**

**Objetivo:** Verificar validación de período.

**Pasos:**
1. Intentar abrir con período inexistente:
   ```powerbuilder
   lst_param.as_periodo = "9999-99"
   lst_param.as_modo = "NUEVO"
   ```

**Resultados Esperados:**
- ❌ Ventana NO abre
- ❌ Mensaje: "El período 9999-99 no existe en la tabla PR_PlanillaPeriodo_Rebaja_Devolucion"

---

### **CASO 10: Validación - Parámetros Incompletos**

**Objetivo:** Verificar validación de parámetros obligatorios.

**Pasos:**
1. Intentar abrir sin parámetros:
   ```powerbuilder
   Open(w_pr_rebaja_devolucion_add)  // Sin parámetros
   ```

**Resultados Esperados:**
- ❌ Ventana cierra inmediatamente
- ❌ Mensaje: "No se recibieron los parámetros necesarios"

---

### **CASO 11: Cálculo de Total en Cabecera**

**Objetivo:** Verificar que TotalMonto se calcula correctamente.

**Pasos:**
1. Crear nueva rebaja
2. Modificar varios MontoFinal para generar ajustes:
   - Concepto 1: MontoAjuste = 100.00
   - Concepto 2: MontoAjuste = -50.00
   - Concepto 3: MontoAjuste = 200.00
3. Grabar

**Resultados Esperados:**
- ✅ TotalMonto en cabecera = 250.00 (100 - 50 + 200)
- ✅ En BD, PR_RebajaDevolucionCab.TotalMonto = 250.00

---

### **CASO 12: Verificar Campos de Auditoría**

**Objetivo:** Verificar que se registran correctamente campos de auditoría.

**Pasos:**
1. Crear y grabar nueva rebaja
2. Consultar BD

**Resultados Esperados:**
```sql
SELECT
    FechaCreacion,
    UsuarioCreacion,
    UltimoUsuario,
    UltimaFechaModif
FROM PR_RebajaDevolucionCab
WHERE IdRebajaDevolucion = [ID]
```
- ✅ FechaCreacion tiene fecha/hora del momento de creación
- ✅ UsuarioCreacion tiene el usuario actual
- ✅ UltimoUsuario tiene el usuario actual
- ✅ UltimaFechaModif tiene fecha/hora actual

---

### **CASO 13: DataWindow con INNER JOIN y Update**

**Objetivo:** Verificar que el update funciona con INNER JOIN en detalle.

**Pasos:**
1. Crear nueva rebaja
2. Verificar que la columna "Descripcion" muestra correctamente (viene del JOIN)
3. Modificar MontoFinal
4. Grabar

**Resultados Esperados:**
- ✅ Columna Descripcion muestra nombre del concepto
- ✅ Update() funciona correctamente
- ✅ Solo se actualizan campos de PR_RebajaDevolucionDet
- ✅ Descripcion NO se intenta actualizar (updatewhereclause=no)

---

### **CASO 14: Transacción y ROLLBACK**

**Objetivo:** Verificar manejo de transacciones ante errores.

**Preparación:** Crear un error forzado (ej: constraint violation)

**Pasos:**
1. Crear nueva rebaja
2. Forzar un error (ej: modificar estructura de tabla temporalmente)
3. Intentar grabar

**Resultados Esperados:**
- ❌ Mensaje de error con SQLErrText
- ✅ ROLLBACK ejecutado
- ✅ Datos NO persisten en BD
- ✅ Ventana queda abierta para correcciones

---

## CHECKLIST COMPLETO

Marca cada caso después de probarlo:

```
☐ CASO 1: Crear Nueva REBAJA
☐ CASO 2: Crear Nueva DEVOLUCIÓN
☐ CASO 3: Modificar MontoFinal
☐ CASO 4: Recálculo Proporcional
☐ CASO 5: Grabar Nueva
☐ CASO 6: Editar Existente
☐ CASO 7: Validación Duplicada
☐ CASO 8: Validación Estado
☐ CASO 9: Validación Período
☐ CASO 10: Validación Parámetros
☐ CASO 11: Cálculo Total
☐ CASO 12: Campos Auditoría
☐ CASO 13: DataWindow INNER JOIN
☐ CASO 14: Transacción ROLLBACK
```

---

## DATOS DE PRUEBA SUGERIDOS

### Conjunto 1: Caso Exitoso Completo
```
Periodo: 2024-10 (PROCESO)
TipoPlanilla: RE
TipoProceso: NOR
Empleado: 12345
Días Trabajados: 30
Conceptos esperados: >= 5
```

### Conjunto 2: Para Testing de Devolución
```
Periodo: 2024-09 (CERRADO)
TipoPlanilla: RE
TipoProceso: NOR
Empleado: 12345
```

### Conjunto 3: Para Recálculo
```
Conjunto: PRECONESP
Concepto en grupo: 0051
Días originales: 30
Días nuevos: 25
MontoOriginal esperado: 3000.00
MontoFinal esperado: 2500.00 (3000 * 25/30)
```

---

## NOTAS IMPORTANTES

1. **Orden de Testing:** Ejecutar casos en orden secuencial (1-14)

2. **Limpieza entre pruebas:**
   ```sql
   -- Si necesitas limpiar datos de prueba
   DELETE FROM PR_RebajaDevolucionDet WHERE IdRebajaDevolucion = [ID]
   DELETE FROM PR_RebajaDevolucionCab WHERE IdRebajaDevolucion = [ID]
   ```

3. **Backup antes de testing:**
   ```sql
   -- Backup de tablas
   SELECT * INTO PR_RebajaDevolucionCab_BKP FROM PR_RebajaDevolucionCab
   SELECT * INTO PR_RebajaDevolucionDet_BKP FROM PR_RebajaDevolucionDet
   ```

4. **Funciones NO probadas aquí (testing futuro):**
   - wf_cerrar_periodo() - No implementada para esta ventana
   - wf_position() - No aplica para este modo de ventana
   - Consolidación de rebaja
   - Anulación de rebaja
   - Generación de rectificatoria

---

## REPORTE DE ERRORES

Para cada error encontrado, documentar:

```
CASO: [Número]
DESCRIPCIÓN: [Qué pasó]
ESPERADO: [Qué debería pasar]
PASOS PARA REPRODUCIR:
1. ...
2. ...
SQL EJECUTADO: [Si aplica]
MENSAJE ERROR: [Si aplica]
SCREENSHOT: [Si es posible]
```

---

## FIRMA DE APROBACIÓN

```
Tester: ___________________
Fecha: ____________________
Casos Exitosos: ___/14
Casos Fallidos: ___/14
Estado: ☐ APROBADO  ☐ RECHAZADO  ☐ CON OBSERVACIONES
```
