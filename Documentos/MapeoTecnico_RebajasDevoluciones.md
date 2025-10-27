# Mapeo Técnico - Módulo de Rebajas y Devoluciones

**Proyecto:** Sistema de Nóminas - Módulo de Rebajas y Devoluciones
**Tecnología:** PowerBuilder 12.5 y SQL Server
**Fecha:** Octubre 2025
**Versión:** 1.0
**Autor:** Analista de Sistemas – Cristian Fernández

---

## Tabla de Contenidos

1. [Introducción](#introducción)
2. [Mapeo de Tablas SQL](#mapeo-de-tablas-sql)
3. [Mapeo de DataWindows](#mapeo-de-datawindows)
4. [Mapeo de DataStores](#mapeo-de-datastores)
5. [Mapeo de Ventanas](#mapeo-de-ventanas)
6. [Mapeo de Funcionalidades](#mapeo-de-funcionalidades)
7. [Mapeo de Validaciones](#mapeo-de-validaciones)
8. [Mapeo de Estados y Flujos](#mapeo-de-estados-y-flujos)
9. [Variables Globales](#variables-globales)
10. [Puntos de Integración](#puntos-de-integración)

---

## Introducción

Este documento establece la correspondencia entre:
- **Documento de Requerimientos:** `CAFP_Documento_Requerimientos_Rebajas_Devoluciones_v02.md`
- **Implementación Técnica:** Código fuente en PowerBuilder 12.5

**Propósito:** Servir como referencia rápida para entender dónde está implementado cada requerimiento funcional en el código.

---

## Mapeo de Tablas SQL

### Tabla: PR_RebajaDevolucionCab (Cabecera)

| Campo en Documento (Línea 428-444) | Campo en SQL | Script | Tipo | Observaciones |
|-------------------------------------|--------------|--------|------|---------------|
| `id_rebaja_devolucion` | `IdRebajaDevolucion` | `03. CreateTable_PR_RebajaDevolucionCab.sql:4` | `INT IDENTITY(1,1)` | PK, auto-incremental |
| `periodo` | `Periodo` | `03. CreateTable_PR_RebajaDevolucionCab.sql:5` | `CHAR(8)` | Formato: YYYYMMDD |
| `codigo_planilla` | `TipoPlanilla` | `03. CreateTable_PR_RebajaDevolucionCab.sql:6` | `CHAR(2)` | FK a PR_TipoPlanilla |
| `codigo_proceso` | `TipoProceso` | `03. CreateTable_PR_RebajaDevolucionCab.sql:7` | `CHAR(3)` | FK a PR_TipoProceso |
| `codigo_trabajador` | `Empleado` | `03. CreateTable_PR_RebajaDevolucionCab.sql:8` | `INT` | FK a PersonaMast |
| `tipo` | `TipoRegistro` | `03. CreateTable_PR_RebajaDevolucionCab.sql:9` | `CHAR(1)` | 'R'=REBAJA, 'D'=DEVOLUCIÓN |
| `estado` | `Estado` | `03. CreateTable_PR_RebajaDevolucionCab.sql:10` | `CHAR(1)` | T/C/R/D/A (ver tabla estados) |
| `dias_trabajados_original` | `DiasTrabajadosOriginal` | `03. CreateTable_PR_RebajaDevolucionCab.sql:14` | `INT` | Para recálculo proporcional |
| `dias_trabajados_nuevo` | ❌ NO EXISTE | - | - | No se graba, es temporal en UI |
| `modo_recalculo` | ❌ NO EXISTE | - | - | Opcional (no implementado) |
| `sustento_general` | `DescripcionTramite` | `03. CreateTable_PR_RebajaDevolucionCab.sql:11` | `VARCHAR(500)` | Sustento del TRAMITE |
| `archivo_pdf` | `ArchivoPDFTramite` | `03. CreateTable_PR_RebajaDevolucionCab.sql:12` | `VARCHAR(255)` | Ruta del PDF |
| `fecha_registro` | `FechaCreacion` | `03. CreateTable_PR_RebajaDevolucionCab.sql:17` | `DATETIME` | Auditoría de creación |
| `usuario_registro` | `UsuarioCreacion` | `03. CreateTable_PR_RebajaDevolucionCab.sql:18` | `CHAR(20)` | Usuario que creó |
| `fecha_modificacion` | `UltimaFechaModif` | `03. CreateTable_PR_RebajaDevolucionCab.sql:45` | `DATETIME` | Auditoría última modificación |
| `usuario_modificacion` | `UltimoUsuario` | `03. CreateTable_PR_RebajaDevolucionCab.sql:44` | `CHAR(20)` | Último usuario que modificó |

**Campos adicionales de estados (según flujo):**

| Estado | Campos | Script Líneas |
|--------|--------|---------------|
| CONSOLIDADA (Rebajas) | `FechaConsolidacion`, `UsuarioConsolidacion`, `DescripcionConsolidada` | `03. CreateTable_PR_RebajaDevolucionCab.sql:21-23` |
| CON RECTIFICATORIA (Devoluciones) | `FechaRectificatoria`, `UsuarioRectificatoria`, `DescripcionRectificatoria`, `ArchivoPDFRectificatoria` | `03. CreateTable_PR_RebajaDevolucionCab.sql:26-29` |
| CON DEVOLUCION (Devoluciones) | `FechaDevolucion`, `UsuarioDevolucion`, `DescripcionDevolucion`, `ArchivoPDFDevolucion` | `03. CreateTable_PR_RebajaDevolucionCab.sql:32-35` |
| ANULADA | `FechaAnulacion`, `UsuarioAnulacion`, `DescripcionAnulacion`, `ArchivoPDFAnulacion` | `03. CreateTable_PR_RebajaDevolucionCab.sql:38-41` |

### Tabla: PR_RebajaDevolucionDet (Detalle)

| Campo en Documento (Línea 447-453) | Campo en SQL | Script | Tipo | Observaciones |
|-------------------------------------|--------------|--------|------|---------------|
| `id_rebaja_devolucion` | `IdRebajaDevolucion` | `04. Create_PR_RebajaDevolucionDet.sql:2` | `INT` | PK, FK a Cabecera |
| `codigo_concepto` | `Concepto` | `04. Create_PR_RebajaDevolucionDet.sql:3` | `CHAR(4)` | PK, FK a PR_Concepto |
| `grupo_concepto` | ❌ NO EXISTE | - | - | Opcional (no implementado) |
| `monto_dice` | `MontoOriginal` | `04. Create_PR_RebajaDevolucionDet.sql:4` | `MONEY` | Monto de la planilla original |
| `monto_debe_decir` | `MontoFinal` | `04. Create_PR_RebajaDevolucionDet.sql:6` | `MONEY` | Monto corregido |
| `diferencia` | `MontoAjuste` | `04. Create_PR_RebajaDevolucionDet.sql:5` | `MONEY` | MontoFinal - MontoOriginal |
| `fue_recalculado` | ❌ NO EXISTE | - | - | Opcional (no implementado) |
| - | `Observacion` | `04. Create_PR_RebajaDevolucionDet.sql:7` | `VARCHAR(255)` | Campo adicional |

### Tabla: PR_PlanillaPeriodo_Rebaja_Devolucion (Períodos)

| Campo en Documento (Línea 456-460) | Campo en SQL | Script | Tipo | Observaciones |
|-------------------------------------|--------------|--------|------|---------------|
| `año` | `anio` | `01. CreateTable_PeriodosDevoluacionesRebajas.sql:7` | `INT` | Año del período |
| `periodo` | `periodo` | `01. CreateTable_PeriodosDevoluacionesRebajas.sql:6` | `VARCHAR(7)` | Formato: YYYY-MM |
| `estado` | `estado` | `01. CreateTable_PeriodosDevoluacionesRebajas.sql:8` | `VARCHAR(20)` | PROCESO / CERRADO |
| `fecha_cierre` | `fecha_cierre` | `01. CreateTable_PeriodosDevoluacionesRebajas.sql:9` | `DATETIME` | Fecha de cierre del período |
| `usuario_cierre` | `usuario_cierre` | `01. CreateTable_PeriodosDevoluacionesRebajas.sql:10` | `VARCHAR(20)` | Usuario que cerró |

### Tabla: PR_ConjuntoDetalle (Maestra de Grupos)

| Campo | Descripción | Observaciones |
|-------|-------------|---------------|
| `Conjunto` | Código del conjunto (ej: "CONREBDEV") | Debe existir registro con "CONREBDEV" |
| `Concepto` | Código del concepto que pertenece al conjunto | Conceptos que se recalculan proporcionalmente |

**⚠️ IMPORTANTE:** Esta tabla debe tener datos para el conjunto "CONREBDEV" con todos los conceptos que se recalculan proporcionalmente por días trabajados.

---

## Mapeo de DataWindows

### dw_pr_rebaja_devolucion_cab (Cabecera)

**Archivo:** `CodigoFuenteTexto/Datawindows/dw_pr_rebaja_devolucion_cab.txt`

| Requerimiento | Implementación | Línea | Observaciones |
|---------------|----------------|-------|---------------|
| Mostrar datos del trabajador | SQL con JOIN a `PersonaMast` | 95 | `emp.NombreCompleto` |
| Mostrar tipo de planilla | SQL con JOIN a `PR_TipoPlanilla` | 94 | `tpla.Descripcion` |
| Mostrar tipo de proceso | SQL con JOIN a `PR_TipoProceso` | 93 | `tpro.Descripcion` |
| Convertir código tipo registro | CASE en SQL | 53-57 | 'R' → 'REBAJA', 'D' → 'DEVOLUCION' |
| Convertir código estado | CASE en SQL | 59-66 | T/C/R/D/A → Texto descriptivo |
| Campo días trabajados originales | Column `diastrabajadosoriginal` | 143 | No editable (protected) |
| Campo días a recalcular | Column `diasrecalcular` | 141 | Editable, temporal (no se graba) |
| Botón adjuntar PDF | Button `b_adjuntar` | 135 | Abre diálogo de archivo |
| Botón recalcular | Button `b_recalcular` | 140 | Ejecuta recálculo proporcional |
| Botón ver PDF | Button `b_ver_pdf` | 163 | Abre PDF con aplicación predeterminada |
| Campo descripción sustento | MultiLineEdit `descripciontramite` | 137 | Mínimo 20 caracteres |
| Campo archivo PDF | Edit `archivopdftramite` | 138 | Ruta completa del archivo |

### dw_pr_rebaja_devolucion_det (Detalle)

**Archivo:** `CodigoFuenteTexto/Datawindows/dw_pr_rebaja_devolucion_det.txt`

| Requerimiento | Implementación | Línea | Observaciones |
|---------------|----------------|-------|---------------|
| Mostrar código concepto | Column `concepto` | 33 | No editable |
| Mostrar descripción concepto | Column `descripcion` | 34 | SQL JOIN con PR_Concepto |
| Mostrar monto DICE | Column `montooriginal` | 35 | No editable, formato: #,##0.00 |
| Editar monto DEBE DECIR | Column `montofinal` | 36 | ✅ EDITABLE (tabsequence=10) |
| Calcular diferencia | Column `montoajuste` | 37 | Calculado automáticamente |
| Sumar total DICE | Compute `cf_total_montooriginal` | 27 | En band=summary |
| Sumar total DEBE DECIR | Compute `cf_total_montofinal` | 26 | En band=summary |
| Sumar total diferencias | Compute `cf_total_montoajuste` | 25 | En band=summary |
| Ordenar por tipo y orden | ORDER BY en SQL | 23 | `TipoConcepto, Planillaorden` |

---

## Mapeo de DataStores

### 1. d_consulta_conceptos_planilla

**Archivo:** `CodigoFuenteTexto/Datawindows/d_consulta_conceptos_planilla.txt`

| Requerimiento Doc (Línea 189-267) | Implementación | Línea | Observaciones |
|------------------------------------|----------------|-------|---------------|
| Cargar conceptos de planilla del empleado | SQL de retrieve | 13-28 | Consulta `PR_PlanillaEmpleadoConcepto` |
| Parámetros: periodo, planilla, proceso, empleado | Arguments | 28 | 4 parámetros |
| Filtrar solo conceptos con monto | WHERE `Monto <> 0` | 27 | Excluye conceptos en cero |
| Filtrar solo IN, DE, PA | WHERE `TipoConcepto IN ('IN','DE','PA')` | 26 | Ingresos, Descuentos, Aportes |
| Usar función en código | `wf_cargar_conceptos_planilla()` | w_pr_rebaja_devolucion_add.txt:189 | Llamada desde ventana |

### 2. d_consulta_dias_trabajados

**Archivo:** `CodigoFuenteTexto/Datawindows/d_consulta_dias_trabajados.txt`

| Requerimiento Doc (Línea 269-307) | Implementación | Línea | Observaciones |
|------------------------------------|----------------|-------|---------------|
| Obtener días trabajados del empleado | SQL de retrieve | 9-14 | Consulta `PR_PlanillaEmpleado` |
| Parámetros: periodo, planilla, proceso, empleado | Arguments | 14 | 4 parámetros |
| Retornar DiasTrabajados | Column `diastrabajados` | 7 | Tipo LONG |
| Usar función en código | `wf_obtener_dias_trabajados()` | w_pr_rebaja_devolucion_add.txt:269 | Retorna 0 si no encuentra |

### 3. d_verificar_periodo_estado

**Archivo:** `CodigoFuenteTexto/Datawindows/d_verificar_periodo_estado.txt`

| Requerimiento Doc (Línea 309-378) | Implementación | Línea | Observaciones |
|------------------------------------|----------------|-------|---------------|
| Verificar estado del período | SQL de retrieve | 9-11 | Consulta `PR_PlanillaPeriodo_Rebaja_Devolucion` |
| Parámetro: periodo | Argument | 11 | Formato YYYY-MM |
| Determinar REBAJA (PROCESO) | Función retorna 1 | w_pr_rebaja_devolucion_add.txt:365 | Si estado = 'PROCESO' |
| Determinar DEVOLUCIÓN (CERRADO) | Función retorna 2 | w_pr_rebaja_devolucion_add.txt:368 | Si estado = 'CERRADO' |
| Usar función en código | `wf_validar_periodo_estado()` | w_pr_rebaja_devolucion_add.txt:309 | Valida y determina tipo |

### 4. d_verificar_rebaja_existente

**Archivo:** `CodigoFuenteTexto/Datawindows/d_verificar_rebaja_existente.txt`

| Requerimiento Doc (Línea 381-434) | Implementación | Línea | Observaciones |
|------------------------------------|----------------|-------|---------------|
| No duplicar ajustes en trámite | WHERE `Estado IN ('T','C')` | 16 | Solo TRAMITE y CONSOLIDADA |
| Parámetros: periodo, planilla, proceso, empleado | Arguments | 16 | 4 parámetros |
| Retornar ID si existe | Column `idrebajadevolucion` | 7 | Para editar registro existente |
| Usar en validación | `wf_validar_rebaja_existente()` | w_pr_rebaja_devolucion_add.txt:381 | Impide duplicados |
| Usar en modo automático | Event `open` | w_pr_rebaja_devolucion_add.txt:1013 | NUEVO vs EDITAR |

### 5. d_verificar_grupo_conrebdev

**Archivo:** `CodigoFuenteTexto/Datawindows/d_verificar_grupo_conrebdev.txt`

| Requerimiento Doc (Línea 462-473) | Implementación | Línea | Observaciones |
|------------------------------------|----------------|-------|---------------|
| Verificar si concepto es recalculable | SQL de retrieve | 9-12 | Consulta `PR_ConjuntoDetalle` |
| Parámetros: conjunto, concepto | Arguments | 12 | 2 parámetros |
| Retorna TRUE si existe fila | Función verifica rowcount | w_pr_rebaja_devolucion_add.txt:556 | Si rowcount > 0 |
| Usar función en código | `wf_concepto_en_grupo()` | w_pr_rebaja_devolucion_add.txt:532 | Usado en recálculo |

---

## Mapeo de Ventanas

### w_pr_rebaja_devolucion_add (Ventana Principal)

**Archivo:** `CodigoFuenteTexto/windows/w_pr_rebaja_devolucion_add.txt`

| Requerimiento | Función/Evento | Línea | Observaciones |
|---------------|----------------|-------|---------------|
| **FUNCIONES PRINCIPALES** ||||
| Crear nuevo registro | `wf_crear_nuevo()` | 718-781 | Modo NUEVO |
| Cargar registro existente | `wf_cargar_existente()` | 140-187 | Modo EDITAR |
| Cargar conceptos de planilla | `wf_cargar_conceptos_planilla()` | 189-267 | Inicializa detalle |
| Obtener días trabajados | `wf_obtener_dias_trabajados()` | 269-307 | Para recálculo |
| Validar estado de período | `wf_validar_periodo_estado()` | 309-378 | R vs D |
| Validar rebaja existente | `wf_validar_rebaja_existente()` | 381-434 | No duplicar |
| **RECÁLCULO PROPORCIONAL** ||||
| Recalcular conceptos | `wf_recalcular_conceptos()` | 437-530 | Regla de tres |
| Verificar grupo CONREBDEV | `wf_concepto_en_grupo()` | 532-562 | Filtrar conceptos |
| Calcular monto ajuste | `wf_calcular_montoajuste()` | 564-588 | MontoFinal - MontoOriginal |
| **GRABAR** ||||
| Grabar cabecera y detalle | `wf_grabar()` | 590-716 | Validaciones + Update |
| **CAMBIOS DE ESTADO** ||||
| Anular registro | `cb_anular::clicked` | 1310-1414 | Solo desde TRAMITE |
| Registrar rectificatoria | `cb_rectificatoria::clicked` | 1432-1536 | Solo DEVOLUCIONES T→R |
| Registrar devolución final | `cb_devolucion::clicked` | 1554-1658 | Solo DEVOLUCIONES R→D |
| **CONTROL DE BOTONES** ||||
| Controlar visibilidad botones | `wf_controlar_botones_estado()` | 783-927 | Por tipo y estado |
| **EVENTOS** ||||
| Inicializar ventana | `event open` | 954-1050 | NUEVO vs EDITAR automático |
| Clic en botones del DW | `dw_1::buttonclicked` | 1195-1292 | Adjuntar, Recalcular, Ver PDF |
| Cambio en monto final | `dw_3::itemchanged` | 1079-1113 | Valida DEBE DECIR < DICE |

### w_pr_rebaja_devolucion_sustento (Ventana de Sustento)

**Archivo:** `CodigoFuenteTexto/windows/w_pr_rebaja_devolucion_sustento.txt`

| Requerimiento | Función/Evento | Línea | Observaciones |
|---------------|----------------|-------|---------------|
| Validar sustento | `wf_validar()` | 51-103 | Mínimo 20 chars O PDF |
| Inicializar ventana | `event open` | 135-164 | Recibe título y mensaje |
| Adjuntar PDF | `cb_adjuntar::clicked` | 215-246 | Valida extensión .PDF |
| Aceptar y retornar | `cb_aceptar::clicked` | 265-284 | Retorna descripción y PDF |
| Cancelar | `cb_cancelar::clicked` | 303-305 | Cierra sin retornar |

---

## Mapeo de Funcionalidades

### 1. Determinación Automática: REBAJA vs DEVOLUCIÓN

**Documento:** Líneas 36-55

| Requerimiento | Implementación | Ubicación |
|---------------|----------------|-----------|
| Si período en PROCESO → REBAJA | `wf_validar_periodo_estado()` retorna 1 | w_pr_rebaja_devolucion_add.txt:365 |
| Si período CERRADO → DEVOLUCIÓN | `wf_validar_periodo_estado()` retorna 2 | w_pr_rebaja_devolucion_add.txt:368 |
| Asignar tipo automáticamente | `ls_tiporegistro = "R"` o `"D"` | w_pr_rebaja_devolucion_add.txt:751-753 |
| Mostrar tipo en UI | Column `descripciontiporegistro` con CASE | dw_pr_rebaja_devolucion_cab.txt:53-57 |

### 2. Recálculo Proporcional por Días Trabajados

**Documento:** Líneas 94-189

| Requerimiento | Implementación | Ubicación |
|---------------|----------------|-----------|
| **Fórmula: Nuevo Monto = Monto Original × (Días Nuevos / Días Originales)** |||
| Validar días nuevos ≤ días originales | Validación en `wf_recalcular_conceptos()` | w_pr_rebaja_devolucion_add.txt:485-492 |
| Aplicar regla de tres | `ldc_montofinal_nuevo = ldc_montooriginal * (al_diasnuevos / ll_diasoriginales)` | w_pr_rebaja_devolucion_add.txt:508 |
| Filtrar solo conceptos CONREBDEV | `wf_concepto_en_grupo(ls_concepto, "CONREBDEV")` | w_pr_rebaja_devolucion_add.txt:502 |
| Actualizar MontoFinal | `dw_3.SetItem(ll_i, "montofinal", ldc_montofinal_nuevo)` | w_pr_rebaja_devolucion_add.txt:510 |
| Recalcular MontoAjuste | `wf_calcular_montoajuste()` | w_pr_rebaja_devolucion_add.txt:517 |
| Mostrar resumen | MessageBox con total recalculados | w_pr_rebaja_devolucion_add.txt:520-526 |
| **UI** |||
| Mostrar días originales | Column `diastrabajadosoriginal` (protected) | dw_pr_rebaja_devolucion_cab.txt:143 |
| Campo para ingresar días nuevos | Column `diasrecalcular` (editable) | dw_pr_rebaja_devolucion_cab.txt:141 |
| Botón Recalcular | Button `b_recalcular` | dw_pr_rebaja_devolucion_cab.txt:140 |
| Evento clic botón | `dw_1::buttonclicked` → `wf_recalcular_conceptos()` | w_pr_rebaja_devolucion_add.txt:1238-1266 |

### 3. Validación: DEBE DECIR siempre menor que DICE

**Documento:** Líneas 205-217

| Requerimiento | Implementación | Ubicación |
|---------------|----------------|-----------|
| Validar al cambiar MontoFinal | Event `dw_3::itemchanged` | w_pr_rebaja_devolucion_add.txt:1079-1113 |
| Si MontoFinal > MontoOriginal | `IF ldc_montofinal > ldc_montooriginal THEN` | w_pr_rebaja_devolucion_add.txt:1095 |
| Rechazar cambio | `RETURN 1` | w_pr_rebaja_devolucion_add.txt:1102 |
| Mensaje de error | MessageBox explicativo | w_pr_rebaja_devolucion_add.txt:1096-1101 |

### 4. Sustento Obligatorio

**Documento:** Líneas 219-225

| Requerimiento | Implementación | Ubicación |
|---------------|----------------|-----------|
| Descripción ≥ 20 chars O archivo PDF | Validación en `wf_grabar()` | w_pr_rebaja_devolucion_add.txt:630-652 |
| Obtener descripción | `ls_descripcion = Trim(dw_1.GetItemString(1, "descripciontramite"))` | w_pr_rebaja_devolucion_add.txt:634 |
| Obtener archivo PDF | `ls_archivopdf = Trim(dw_1.GetItemString(1, "archivopdftramite"))` | w_pr_rebaja_devolucion_add.txt:635 |
| Validar longitud descripción | `li_len_descripcion < 20` | w_pr_rebaja_devolucion_add.txt:643 |
| Validar existencia PDF | `IsNull(ls_archivopdf) OR Len(ls_archivopdf) = 0` | w_pr_rebaja_devolucion_add.txt:643 |
| Mensaje de error | MessageBox con instrucciones claras | w_pr_rebaja_devolucion_add.txt:644-650 |
| **Ventana de sustento para cambios de estado** |||
| Ventana modal | `w_pr_rebaja_devolucion_sustento` | w_pr_rebaja_devolucion_sustento.txt |
| Validación en ventana | `wf_validar()` | w_pr_rebaja_devolucion_sustento.txt:51-103 |
| Usar en Anular | `OpenWithParm(w_pr_rebaja_devolucion_sustento, lstr_param)` | w_pr_rebaja_devolucion_add.txt:1364 |
| Usar en Rectificatoria | Idem | w_pr_rebaja_devolucion_add.txt:1486 |
| Usar en Devolución | Idem | w_pr_rebaja_devolucion_add.txt:1608 |

### 5. Modo Automático: NUEVO vs EDITAR

**Documento:** Líneas 967-1046 (implementación)

| Requerimiento | Implementación | Ubicación |
|---------------|----------------|-----------|
| Al abrir ventana | Event `open` | w_pr_rebaja_devolucion_add.txt:954 |
| Verificar registro existente | `d_verificar_rebaja_existente` | w_pr_rebaja_devolucion_add.txt:1015 |
| Si existe → Modo EDITAR | `This.Tag = "EDITAR"` + `wf_cargar_existente()` | w_pr_rebaja_devolucion_add.txt:1025-1027 |
| Si NO existe → Modo NUEVO | `This.Tag = "NUEVO"` + `wf_crear_nuevo()` | w_pr_rebaja_devolucion_add.txt:1038-1040 |
| Controlar botones según modo | `wf_controlar_botones_estado()` | w_pr_rebaja_devolucion_add.txt:797-803 |

---

## Mapeo de Validaciones

### Validaciones de Negocio

| # | Requerimiento (Doc Línea) | Implementación | Ubicación | Error/Mensaje |
|---|---------------------------|----------------|-----------|---------------|
| 1 | Debe marcar al menos un concepto (196-198) | Validar total ajuste ≠ 0 | w_pr_rebaja_devolucion_add.txt:618-628 | "No se ha aplicado ningún ajuste" |
| 2 | Si marca concepto, llenar DEBE DECIR (199-202) | Validación implícita al calcular total | w_pr_rebaja_devolucion_add.txt:618-628 | Incluido en validación #1 |
| 3 | DEBE DECIR < DICE (203-217) | Event `dw_3::itemchanged` | w_pr_rebaja_devolucion_add.txt:1095-1102 | "No se puede aumentar un concepto" |
| 4 | Sustento obligatorio (219-225) | En `wf_grabar()` | w_pr_rebaja_devolucion_add.txt:643-652 | "Debe ingresar un sustento..." |
| 5 | No duplicar ajustes (229-230) | `wf_validar_rebaja_existente()` | w_pr_rebaja_devolucion_add.txt:406-427 | "Ya existe una ... en trámite" |
| 6 | Período debe existir (231-234) | `wf_validar_periodo_estado()` | w_pr_rebaja_devolucion_add.txt:349-355 | "El período ... no existe" |
| 7 | Días nuevos ≤ días originales (146-149) | En `wf_recalcular_conceptos()` | w_pr_rebaja_devolucion_add.txt:485-492 | "deben ser menores o iguales" |
| 8 | Debe haber conceptos CONREBDEV (150-153) | Contador de recalculados | w_pr_rebaja_devolucion_add.txt:511 | Se muestra en resumen |

### Validaciones de Estado

| Validación | Implementación | Ubicación |
|------------|----------------|-----------|
| Solo anular desde TRAMITE | `IF ls_estado <> "T" THEN` | w_pr_rebaja_devolucion_add.txt:1339-1345 |
| Solo rectificar DEVOLUCIONES en TRAMITE | `IF ls_tiporegistro <> "D" OR ls_estado <> "T"` | w_pr_rebaja_devolucion_add.txt:1453-1468 |
| Solo registrar devolución desde CON RECTIFICATORIA | `IF ls_tiporegistro <> "D" OR ls_estado <> "R"` | w_pr_rebaja_devolucion_add.txt:1575-1590 |

---

## Mapeo de Estados y Flujos

### Estados de REBAJAS (TipoRegistro = 'R')

**Documento:** Líneas 239-256

| Estado Código | Estado Nombre | Doc Línea | Transiciones Permitidas | Implementación Control |
|---------------|---------------|-----------|-------------------------|------------------------|
| T | TRAMITE | 242-246 | → C (automático), → A (manual) | w_pr_rebaja_devolucion_add.txt:839-846 |
| C | CONSOLIDADA | 248-252 | (Estado final para periodo) | w_pr_rebaja_devolucion_add.txt:848-854 |
| A | ANULADA | 254-256 | (Estado final) | w_pr_rebaja_devolucion_add.txt:856-862 |

**Flujo de botones (REBAJAS):**

| Estado Actual | Botón Grabar | Botón Anular | Botón Rectificatoria | Botón Devolución |
|---------------|--------------|--------------|----------------------|------------------|
| T (TRAMITE) | ✅ Visible/Habilitado | ✅ Visible/Habilitado | ❌ Oculto | ❌ Oculto |
| C (CONSOLIDADA) | ❌ Oculto | ❌ Oculto | ❌ Oculto | ❌ Oculto |
| A (ANULADA) | ❌ Oculto | ❌ Oculto | ❌ Oculto | ❌ Oculto |

### Estados de DEVOLUCIONES (TipoRegistro = 'D')

**Documento:** Líneas 258-282

| Estado Código | Estado Nombre | Doc Línea | Transiciones Permitidas | Implementación Control |
|---------------|---------------|-----------|-------------------------|------------------------|
| T | TRAMITE | 259-263 | → R (manual), → A (manual) | w_pr_rebaja_devolucion_add.txt:881-890 |
| R | CON RECTIFICATORIA | 265-271 | → D (manual) | w_pr_rebaja_devolucion_add.txt:892-900 |
| D | CON DEVOLUCION | 273-279 | (Estado final) | w_pr_rebaja_devolucion_add.txt:902-908 |
| A | ANULADA | 281-282 | (Estado final) | w_pr_rebaja_devolucion_add.txt:910-916 |

**Flujo de botones (DEVOLUCIONES):**

| Estado Actual | Botón Grabar | Botón Anular | Botón Rectificatoria | Botón Devolución |
|---------------|--------------|--------------|----------------------|------------------|
| T (TRAMITE) | ✅ Visible/Habilitado | ✅ Visible/Habilitado | ✅ Visible/Habilitado | ❌ Oculto |
| R (CON RECTIFICATORIA) | ❌ Oculto | ❌ Oculto | ❌ Oculto | ✅ Visible/Habilitado |
| D (CON DEVOLUCION) | ❌ Oculto | ❌ Oculto | ❌ Oculto | ❌ Oculto |
| A (ANULADA) | ❌ Oculto | ❌ Oculto | ❌ Oculto | ❌ Oculto |

### Consolidación de Período

**Documento:** Líneas 285-296

| Requerimiento | Implementación | Ubicación |
|---------------|----------------|-----------|
| Cambiar estado período PROCESO → CERRADO | `wf_cerrar_periodo()` | w_pr_rebaja_devolucion_add.txt:48-97 |
| Todas las rebajas T → C | ⚠️ NO IMPLEMENTADO | Debe agregarse en `wf_cerrar_periodo()` |
| Generar PDF consolidado | ⚠️ NO IMPLEMENTADO | Pendiente |
| Guardar fecha de cierre | `dw_1.SetItem(ll_row, "fecha_cierre", ldt_ahora)` | w_pr_rebaja_devolucion_add.txt:84 |

⚠️ **PENDIENTE:** La función `wf_cerrar_periodo()` existe pero NO cambia el estado de las rebajas T→C automáticamente.

---

## Variables Globales

### str_global.gv_userid

| Uso | Ubicación | Campo Destino |
|-----|-----------|---------------|
| UsuarioCreacion al crear | w_pr_rebaja_devolucion_add.txt:765 | `PR_RebajaDevolucionCab.UsuarioCreacion` |
| UltimoUsuario al grabar | w_pr_rebaja_devolucion_add.txt:667 | `PR_RebajaDevolucionCab.UltimoUsuario` |
| UsuarioAnulacion al anular | w_pr_rebaja_devolucion_add.txt:1386 | `PR_RebajaDevolucionCab.UsuarioAnulacion` |
| UsuarioRectificatoria | w_pr_rebaja_devolucion_add.txt:1508 | `PR_RebajaDevolucionCab.UsuarioRectificatoria` |
| UsuarioDevolucion | w_pr_rebaja_devolucion_add.txt:1630 | `PR_RebajaDevolucionCab.UsuarioDevolucion` |

---

## Puntos de Integración

### 1. Integración con Módulo de Planillas

| Tabla Origen | Propósito | Uso en Código |
|--------------|-----------|---------------|
| `PR_PlanillaEmpleado` | Obtener días trabajados | DataStore `d_consulta_dias_trabajados` |
| `PR_PlanillaEmpleadoConcepto` | Obtener conceptos y montos de la boleta | DataStore `d_consulta_conceptos_planilla` |
| `PR_TipoPlanilla` | Descripción del tipo de planilla | JOIN en `dw_pr_rebaja_devolucion_cab` |
| `PR_TipoProceso` | Descripción del tipo de proceso | JOIN en `dw_pr_rebaja_devolucion_cab` |

### 2. Integración con Módulo de Personal

| Tabla Origen | Propósito | Uso en Código |
|--------------|-----------|---------------|
| `PersonaMast` | Datos del trabajador (nombre completo) | JOIN en `dw_pr_rebaja_devolucion_cab` |

### 3. Integración con Maestro de Conceptos

| Tabla Origen | Propósito | Uso en Código |
|--------------|-----------|---------------|
| `PR_Concepto` | Descripción y orden de conceptos | JOINs en DataWindows y DataStores |
| `PR_TipoConcepto` | Filtrar IN/DE/PA | DataStore `d_consulta_conceptos_planilla` |
| `PR_ConjuntoDetalle` | Identificar conceptos recalculables | DataStore `d_verificar_grupo_conrebdev` |

### 4. Llamada desde Ventana Principal (Pendiente de implementar)

**Requerimiento:** El usuario debe poder acceder desde el menú de nóminas o desde la consulta de boletas.

**Parámetros esperados al abrir la ventana:**

```powerscript
str_pass lstr_param

lstr_param.s[1] = as_periodo        // Ej: "20251031" o "2025-10"
lstr_param.s[2] = as_tipoplanilla   // Ej: "01"
lstr_param.s[3] = as_tipoproceso    // Ej: "001"
lstr_param.s[4] = String(al_empleado) // Ej: "12345"
lstr_param.s[5] = as_nombreempleado // Ej: "PEREZ GOMEZ, JUAN"

OpenWithParm(w_pr_rebaja_devolucion_add, lstr_param)
```

**Ubicación en código:** `w_pr_rebaja_devolucion_add::open`, línea 989-996

---

## Checklist de Implementación

### ✅ Completado

- [x] Tablas SQL creadas
- [x] DataWindows de cabecera y detalle
- [x] DataStores para consultas
- [x] Ventana principal con toda la lógica
- [x] Ventana de sustento
- [x] Validación DEBE DECIR < DICE
- [x] Recálculo proporcional por días
- [x] Sustento obligatorio
- [x] Control de botones por estado
- [x] Modo automático NUEVO/EDITAR
- [x] Flujo de estados (REBAJA y DEVOLUCIÓN)
- [x] Auditoría completa (usuario y fecha)

### ⚠️ Pendiente/Verificar

- [ ] **CRÍTICO:** Verificar que `PR_ConjuntoDetalle` tenga datos para "CONREBDEV"
- [ ] **IMPORTANTE:** Implementar cambio automático de rebajas T→C al cerrar período
- [ ] Opcional: Agregar campo `grupo_concepto` a PR_RebajaDevolucionDet
- [ ] Opcional: Agregar campo `fue_recalculado` a PR_RebajaDevolucionDet
- [ ] Opcional: Generar PDF consolidado al cerrar período

### 📝 Queries de Verificación

```sql
-- Verificar conjunto CONREBDEV
SELECT * FROM PR_ConjuntoDetalle
WHERE Conjunto = 'CONREBDEV'
ORDER BY Concepto

-- Verificar períodos creados
SELECT * FROM PR_PlanillaPeriodo_Rebaja_Devolucion
ORDER BY anio DESC, periodo DESC

-- Verificar estructura de rebajas/devoluciones
SELECT TOP 10
    rd.IdRebajaDevolucion,
    rd.Periodo,
    rd.TipoRegistro,
    rd.Estado,
    rd.TotalMonto,
    emp.NombreCompleto
FROM PR_RebajaDevolucionCab rd
INNER JOIN PersonaMast emp ON rd.Empleado = emp.persona
ORDER BY rd.FechaCreacion DESC
```

---

## Glosario de Códigos

### Tipo de Registro (TipoRegistro)

| Código | Descripción |
|--------|-------------|
| R | REBAJA (período en PROCESO) |
| D | DEVOLUCIÓN (período CERRADO) |

### Estados (Estado)

| Código | Descripción | Aplica a |
|--------|-------------|----------|
| T | TRAMITE | Ambos |
| C | CONSOLIDADA | Solo REBAJAS |
| R | CON RECTIFICATORIA | Solo DEVOLUCIONES |
| D | CON DEVOLUCION | Solo DEVOLUCIONES |
| A | ANULADA | Ambos |

### Estados de Período

| Código | Descripción |
|--------|-------------|
| PROCESO | Período abierto, se pueden hacer REBAJAS |
| CERRADO | Período cerrado, solo se pueden hacer DEVOLUCIONES |

### Tipos de Concepto (TipoConcepto)

| Código | Descripción | Se incluye en Rebajas/Devoluciones |
|--------|-------------|-----------------------------------|
| IN | Ingresos | ✅ SÍ |
| DE | Descuentos | ✅ SÍ |
| PA | Aportes del empleador | ✅ SÍ |
| Otros | Otros tipos | ❌ NO |

---

## Notas Técnicas Adicionales

### 1. Formato de Período

El sistema maneja dos formatos de período:

- **En tablas de planilla:** `CHAR(8)` formato `YYYYMMDD` (ej: "20251031")
- **En tabla de períodos:** `VARCHAR(7)` formato `YYYY-MM` (ej: "2025-10")

La función `wf_validar_periodo_estado()` convierte automáticamente entre formatos (líneas 320-333).

### 2. Manejo de Transacciones

- **Grabar:** COMMIT si OK, ROLLBACK si error (w_pr_rebaja_devolucion_add.txt:704)
- **Anular:** COMMIT si OK, ROLLBACK si error (w_pr_rebaja_devolucion_add.txt:1396)
- **Rectificatoria:** COMMIT si OK, ROLLBACK si error (w_pr_rebaja_devolucion_add.txt:1518)
- **Devolución:** COMMIT si OK, ROLLBACK si error (w_pr_rebaja_devolucion_add.txt:1640)

### 3. Cascada de Eliminación

La tabla `PR_RebajaDevolucionDet` tiene `ON DELETE CASCADE`, por lo que al eliminar una cabecera se eliminan automáticamente sus detalles.

**Script:** `04. Create_PR_RebajaDevolucionDet.sql:19`

### 4. Índices Creados

**En PR_RebajaDevolucionCab:**
- `IX_RebajaDevCab_Periodo_Empleado` - Para búsquedas por período y empleado
- `IX_RebajaDevCab_Estado` - Para filtrar por estado
- `IX_RebajaDevCab_TipoRegistro` - Para filtrar por tipo

**En PR_RebajaDevolucionDet:**
- `IX_RebajaDevDet_Concepto` - Para búsquedas por concepto

---

## Historial de Cambios

| Versión | Fecha | Autor | Cambios |
|---------|-------|-------|---------|
| 1.0 | 2025-10-27 | Cristian Fernández | Documento inicial de mapeo técnico |

---

**Fin del Documento de Mapeo Técnico**
