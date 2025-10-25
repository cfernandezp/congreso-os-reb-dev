__Documento de Requerimientos - ACTUALIZADO__

Módulo de Rebajas y Devoluciones

Sistema: Nóminas - Módulo de Rebajas y Devoluciones  
Tecnología: PowerBuilder 12.5 y SQL Server  
Fecha: Octubre 2025  
Autor: Analista de Sistemas – Cristian Fernández
Versión: 02

---

## CAMBIOS EN ESTA VERSIÓN

1. **Eliminadas secciones de diseño de ventanas** - El diseño UI se definirá en otra fase
2. **Nueva funcionalidad: Recálculo por días trabajados** - Permite ajustar automáticamente todos los conceptos del grupo CONREBDEV basándose en una nueva cantidad de días trabajados

---

## Tabla de Contenidos

1. [¿Qué son las Rebajas y Devoluciones?](#qué-son-las-rebajas-y-devoluciones)
2. [¿Cuándo usar cada una?](#cuándo-usar-cada-una)
3. [Proceso de Registro](#proceso-de-registro)
4. [Nueva Funcionalidad: Recálculo por Días Trabajados](#nueva-funcionalidad-recálculo-por-días-trabajados)
5. [Validaciones Importantes](#validaciones-importantes)
6. [Estados de los Registros](#estados-de-los-registros)
7. [Consolidación de Periodo](#consolidación-de-periodo)

---

## ¿Qué son las Rebajas y Devoluciones?

Son ajustes que se hacen cuando descubrimos que un trabajador cobró más de lo que debía en su boleta.

**REBAJA**: El periodo todavía está en PROCESO (no se pagaron tributos a SUNAT). Se corrige en este mismo periodo.

**DEVOLUCIÓN**: El periodo ya está CERRADO (ya se pagaron tributos). Hay que hacer una rectificatoria ante SUNAT.

---

## ¿Cuándo usar cada una?

### REBAJA
- El periodo está en estado PROCESO
- Todavía no se cerró el periodo
- Todavía no se generó el PLAME
- Se puede corregir sin ir a SUNAT

### DEVOLUCIÓN
- El periodo ya está CERRADO
- Ya se generó y presentó el PLAME
- Ya se pagaron los tributos a SUNAT
- Hay que hacer rectificatoria ante SUNAT

---

## Proceso de Registro

### Acceso al Sistema

1. El usuario ingresa al menú de Rebajas y Devoluciones
2. Ve una lista de boletas del periodo seleccionado
3. Puede filtrar por:
   - Trabajador (DNI o apellido)
   - Planilla
   - Proceso
4. Existe un botón adicional al final de cada fila para acceder al ajuste de esa boleta

### Carga de Datos de Cabecera

Al hacer clic en el botón de "Rebajas" o "Devoluciones" de una boleta, el sistema:

**Carga automáticamente:**
- Periodo
- Planilla  
- Proceso
- Datos del trabajador (código, nombres, apellidos, DNI, etc.)
- **Días trabajados** (nuevo campo importante para la funcionalidad de recálculo)
- Tipo de ajuste (REBAJA o DEVOLUCIÓN) - calculado según el estado del periodo

**Muestra:**
- Todos los conceptos de esa boleta en una grilla editable
- Cada concepto tiene:
  - Checkbox (para marcar si se va a ajustar)
  - Código del concepto
  - Nombre del concepto  
  - Monto DICE (actual, no editable)
  - Monto DEBE DECIR (correcto, editable si checkbox está marcado)
  - Grupo del concepto (para identificar si pertenece a CONREBDEV)

---

## Nueva Funcionalidad: Recálculo por Días Trabajados

### Descripción

Permite ajustar automáticamente el monto de TODOS los conceptos que pertenecen al grupo CONREBDEV cuando hay un cambio en los días trabajados. Esto es útil cuando el error no fue en el cálculo individual de cada concepto, sino en la cantidad de días trabajados considerados.

### Cómo Funciona

1. **Al cargar la boleta**, el sistema muestra el campo "Días Trabajados" con el valor original de la planilla
   
2. **El usuario puede activar el modo "Recalcular"**, que:
   - Habilita un campo para ingresar los nuevos días trabajados
   - Valida que los nuevos días sean menores o iguales a los días originales
   - Al confirmar, aplica automáticamente la regla de tres simple a TODOS los conceptos del grupo CONREBDEV

3. **Fórmula de recálculo** (Regla de tres simple):
   ```
   Nuevo Monto = Monto Original × (Días Nuevos / Días Originales)
   ```

4. **El sistema actualiza automáticamente**:
   - Marca el checkbox de cada concepto CONREBDEV
   - Calcula y llena el campo "DEBE DECIR" para cada concepto
   - Muestra un resumen del ajuste aplicado

### Ejemplo Detallado

**Situación inicial:**
- Planilla cabecera: Días Trabajados = 30
- Conceptos del grupo CONREBDEV en la planilla:
  - 001 - Remuneración Básica: S/ 3,000.00
  - 015 - Asignación Familiar: S/ 102.50  
  - 030 - Bonificación: S/ 600.00
  - 045 - Gratificación: S/ 1,500.00

**Usuario realiza recálculo con 20 días trabajados:**

El sistema aplica la regla de tres:
- Factor = 20 / 30 = 0.6667

**Resultados automáticos:**

| Código | Concepto | DICE | DEBE DECIR | Diferencia |
|--------|----------|------|------------|-----------|
| 001 | Remuneración Básica | S/ 3,000.00 | S/ 2,000.00 | S/ -1,000.00 |
| 015 | Asignación Familiar | S/ 102.50 | S/ 68.33 | S/ -34.17 |
| 030 | Bonificación | S/ 600.00 | S/ 400.00 | S/ -200.00 |
| 045 | Gratificación | S/ 1,500.00 | S/ 1,000.00 | S/ -500.00 |

**Total diferencia:** S/ -1,734.17

### Validaciones del Recálculo

1. **Días nuevos ≤ Días originales**
   - No se puede aumentar días, solo reducir
   - Mensaje: "Los días a recalcular (X) deben ser menores o iguales a los días trabajados originales (Y)"

2. **Debe haber al menos un concepto CONREBDEV en la planilla**
   - Si no hay conceptos del grupo, no se permite recalcular
   - Mensaje: "No hay conceptos del grupo CONREBDEV en esta planilla para recalcular"

3. **Confirmación antes de aplicar**
   - El sistema muestra una vista previa de todos los cambios
   - Usuario debe confirmar antes de que se apliquen los nuevos montos
   - Mensaje: "Se van a recalcular X conceptos. ¿Desea continuar?"

### Casos de Uso del Recálculo

**Caso 1: Error en días de descanso médico**
- Trabajador tuvo 5 días de descanso médico que no fueron descontados
- Original: 30 días → Debe ser: 25 días
- Recálculo afecta todos los conceptos CONREBDEV proporcionalmente

**Caso 2: Días de suspensión no registrados**  
- Trabajador tuvo suspensión de 10 días
- Original: 30 días → Debe ser: 20 días
- Recálculo ajusta automáticamente todos los montos

**Caso 3: Ingreso tardío en el mes**
- Trabajador ingresó el día 15
- Original: 30 días → Debe ser: 15 días  
- Recálculo proporcional de todos los conceptos

### Importante: Conceptos NO Afectados

**El recálculo SOLO afecta conceptos del grupo CONREBDEV**

**NO se recalculan:**
- Conceptos de otros grupos (descuentos, aportes, etc.)
- Conceptos que no están marcados como parte de CONREBDEV en el maestro

Por ejemplo, si la planilla tiene:
- 001 - Remuneración (CONREBDEV) → **SÍ se recalcula**
- 201 - ONP 13% (DESCUENTOS) → **NO se recalcula**  
- 301 - ESSALUD (APORTES) → **NO se recalcula**

---

## Validaciones Importantes

### Al momento de marcar y llenar

#### Regla 1: Debe marcar al menos un concepto
No tiene sentido abrir la ventana y no marcar nada. Si no marca ningún checkbox y le da GRABAR, el sistema dice:
> "Debe seleccionar al menos un concepto para aplicar rebaja o devolución"

#### Regla 2: Si marca un concepto, debe llenar el DEBE DECIR
Si marca el checkbox pero deja el campo DEBE DECIR vacío, el sistema no lo deja grabar:
> "Debe ingresar el monto DEBE DECIR para el concepto seleccionado"

#### Regla 3: El DEBE DECIR siempre debe ser MENOR que el DICE
Esta es la regla más importante. Estamos hablando de rebajas y devoluciones, o sea, estamos corrigiendo porque cobramos de más. El nuevo monto SIEMPRE tiene que ser menor al original.

**Ejemplo válido:**
- Monto original (DICE): S/ 500.00
- Monto corregido (DEBE DECIR): S/ 450.00 ✓

**Ejemplo NO válido:**
- Monto original (DICE): S/ 500.00
- Monto corregido (DEBE DECIR): S/ 550.00 ✗

Si el usuario intenta poner un monto mayor, el sistema le dice:
> "El monto DEBE DECIR debe ser menor al monto original. No se puede aumentar un concepto, solo rebajarlo"

#### Regla 4: Siempre debe haber sustento
No se puede grabar sin explicar por qué se está haciendo el ajuste. El usuario tiene que escribir algo en el campo de descripción O adjuntar un PDF O ambas cosas.

Si no pone nada, el sistema dice:
> "Debe ingresar un sustento textual o adjuntar un archivo PDF"

La descripción además tiene que tener un mínimo de caracteres (digamos 20) para evitar que pongan cosas como "error" o "ok".

### Otras validaciones

#### No duplicar ajustes
No puede haber dos ajustes en estado TRAMITE para el mismo concepto de la misma boleta.

#### Validar que el periodo exista
Antes de grabar, el sistema verifica que el periodo esté registrado en la tabla de periodos. Si no existe, pide que primero lo creen.

**Nota importante:** Los años deben estar pre-cargados desde 2020, todos con estado inicial PROCESO.

---

## Estados de los Registros

### Para las REBAJAS

#### TRAMITE
- Estado inicial
- La rebaja está registrada pero no se aplicó
- Se puede modificar o anular sin problemas

#### CONSOLIDADA
- Cuando se cierra el periodo (fin de mes), todas las rebajas en TRAMITE pasan a CONSOLIDADAS
- Ya no se pueden modificar ni anular  
- Se consideran aplicadas y se usan para generar el archivo PLAME

#### ANULADA
- Si nos equivocamos al registrar una rebaja en TRAMITE, podemos anularla
- Una rebaja anulada ya no se va a aplicar nunca
- Queda en el sistema como histórico

### Para las DEVOLUCIONES

#### TRAMITE
- Estado inicial
- La devolución está registrada pero no se hizo nada
- Se puede modificar o anular

#### CON RECTIFICATORIA
- El área contable ya presentó el PDT PLAME rectificado ante SUNAT
- Cuando hacen esto, actualizan el registro poniendo:
  - Fecha de presentación
  - Número de orden
  - Observaciones adicionales
- El sistema cambia automáticamente el estado

#### CON DEVOLUCION
- SUNAT ya procesó todo y devolvió el dinero
- El área contable actualiza el registro con:
  - Fecha de devolución
  - Número de nota de crédito  
  - Observaciones finales
- Este es el estado final, ya no se puede modificar nada

#### ANULADA
- Si cancelamos el proceso (solo se puede hacer desde TRAMITE)

---

## Consolidación de Periodo

Al final de cada mes, el responsable (Sr. Nery o quien corresponda) tiene que cerrar el periodo. Esto hace varias cosas:

1. Cambia el estado del periodo de PROCESO a CERRADO
2. Todas las rebajas que están en TRÁMITE pasan a CONSOLIDADAS
3. Se genera el cuadro consolidado (PDF) con las firmas correspondientes
4. Se guarda la fecha de cierre

**Importante:** Después de esto ya no se pueden hacer más rebajas para ese periodo, solo devoluciones.

Es importante que esto se haga después de revisar bien todas las rebajas, porque una vez consolidadas ya no se pueden modificar.

---

## Ejemplos de Uso

### Ejemplo 1: Rebaja por error en asignación familiar

**Situación:**
Juan Pérez tiene en su boleta S/ 102.50 de asignación familiar, pero en realidad debería tener S/ 93.00 porque tiene 1 hijo, no 2. Esto se detecta antes de pagar los tributos a SUNAT (el periodo está abierto).

**Pasos:**
1. El usuario busca la boleta de Juan Pérez del periodo 2025-09
2. Le da click al botón "Rebajas/Devoluciones"  
3. En la ventana que se abre, ve: **Tipo: REBAJA** (porque el periodo está en PROCESO)
4. En la grilla busca la fila de "Asignación Familiar"
5. Marca el checkbox de esa fila
6. En la columna DEBE DECIR escribe: 93.00
7. El sistema muestra automáticamente:
   - DICE: S/ 102.50
   - DEBE DECIR: S/ 93.00
   - Diferencia: S/ 9.50
8. Abajo en el sustento escribe: "Error en el número de hijos cargados. Según ficha familiar actualizada corresponde 1 hijo, no 2 hijos"
9. Adjunta el archivo: Ficha_familiar_Juan_Perez.pdf
10. Le da GRABAR
11. El sistema guarda la rebaja en estado TRAMITE
12. Al final del mes, cuando se cierre el periodo, la rebaja pasará a CONSOLIDADA y se aplicará en el PLAME

### Ejemplo 2: Devolución por error en gratificación

**Situación:**
María López tiene en su boleta de agosto S/ 5,000 de gratificación, pero debería ser S/ 4,500 porque tuvo días de descanso médico. El problema es que ya pasó el mes, ya se pagaron los tributos a SUNAT. Ahora necesitamos recuperar ese dinero.

**Pasos:**
1. El usuario busca la boleta de María López del periodo 2025-08
2. Le da click al botón "Rebajas/Devoluciones"
3. En la ventana que se abre, ve: **Tipo: DEVOLUCIÓN** (porque el periodo ya está CERRADO)
4. En la grilla busca la fila de "Gratificación"
5. Marca el checkbox
6. En DEBE DECIR escribe: 4,500.00
7. En el sustento escribe: "Gratificación calculada con días de descanso médico subsidiado que no corresponden al pago de gratificación"
8. Adjunta: Certificado_medico_Maria_Lopez.pdf
9. Le da GRABAR
10. El sistema guarda la devolución en estado TRAMITE
11. Después de esto, el área contable tiene que hacer todo el proceso de rectificatoria ante SUNAT
12. Cuando presenten el PDT rectificado, actualizan el registro y el estado cambia a CON RECTIFICATORIA
13. Cuando SUNAT devuelva la plata, vuelven a actualizar y el estado cambia a CON DEVOLUCION

### Ejemplo 3: Varios conceptos a la vez

A veces el error no es solo en un concepto, sino en varios. El sistema permite marcar varios checkboxes a la vez.

**Situación:**
En la boleta de Pedro Sánchez hay errores en 3 conceptos diferentes.

**Pasos:**
1. Busca la boleta de Pedro Sánchez
2. Abre la ventana de rebajas/devoluciones  
3. Marca 3 checkboxes:
   - Asignación Familiar: DICE 102.50 → DEBE DECIR 93.00
   - Bonificación: DICE 500.00 → DEBE DECIR 450.00
   - Horas Extras: DICE 350.00 → DEBE DECIR 280.00
4. Escribe un sustento general que explique los 3 errores
5. Adjunta la documentación
6. Graba
7. El sistema va a crear 3 registros separados, uno por cada concepto, pero todos con el mismo sustento y el mismo documento adjunto

La ventaja es que después podemos hacer seguimiento individual de cada ajuste.

### Ejemplo 4: Uso de la funcionalidad de Recálculo

**Situación:**
Roberto Díaz tuvo una suspensión de 10 días por motivos disciplinarios que no fueron registrados en su planilla. Su planilla se generó con 30 días trabajados cuando debieron ser 20 días.

**Pasos:**
1. Busca la boleta de Roberto Díaz del periodo actual
2. Le da click al botón "Rebajas/Devoluciones"
3. Ve que la planilla tiene los siguientes conceptos CONREBDEV:
   - 001 - Remuneración: S/ 4,500.00
   - 015 - Asignación Familiar: S/ 102.50
   - 030 - Bonificación: S/ 900.00
4. En lugar de calcular manualmente cada concepto, activa la opción "Recalcular"
5. Ve que Días Trabajados original = 30
6. Ingresa Días Trabajados nuevo = 20  
7. El sistema muestra una vista previa:
   - 001 - Remuneración: DICE S/ 4,500.00 → DEBE DECIR S/ 3,000.00
   - 015 - Asignación Familiar: DICE S/ 102.50 → DEBE DECIR S/ 68.33
   - 030 - Bonificación: DICE S/ 900.00 → DEBE DECIR S/ 600.00
   - Total diferencia: S/ -1,834.17
8. Confirma el recálculo
9. El sistema marca automáticamente los 3 conceptos y llena los campos DEBE DECIR
10. Escribe el sustento: "Suspensión disciplinaria de 10 días del 11/10 al 20/10 según resolución de gerencia"
11. Adjunta: Resolucion_suspension_Roberto_Diaz.pdf
12. Le da GRABAR
13. El sistema guarda los 3 ajustes en estado TRAMITE

**Ventaja:** En lugar de calcular manualmente los 3 conceptos, el recálculo lo hace automáticamente con una regla de tres simple, ahorrando tiempo y evitando errores de cálculo.

---

## Cálculos automáticos

- Cuando el usuario cambia el DEBE DECIR, el sistema calcula automáticamente la diferencia
- Abajo debe aparecer el total acumulado de todas las diferencias
- En el modo Recálculo, todos los montos se calculan automáticamente

---

## Mensajes claros

Los mensajes de error tienen que explicar bien qué está mal y cómo corregirlo.

**NO:** "Error en el dato"

**SÍ:** "El monto DEBE DECIR (S/ 550) debe ser menor al monto DICE (S/ 500)"

---

## Preguntas pendientes

1. ¿Hay un límite de cuánto se puede rebajar? ¿O se puede rebajar hasta cero?
2. ¿El archivo PDF es obligatorio siempre o solo en ciertos casos?
3. ¿Cuánto tiempo se pueden modificar las rebajas en TRAMITE? ¿Hasta cuándo?
4. ¿El recálculo debe permitir también aumentar días o solo disminuir?
5. ¿Qué pasa con los conceptos que dependen de otros (como las retenciones)?

---

## Notas Técnicas

### Tablas principales

**nom_rebaja_devolucion_cab** (Cabecera)
- id_rebaja_devolucion
- periodo
- codigo_planilla  
- codigo_proceso
- codigo_trabajador
- tipo (R=Rebaja, D=Devolución)
- estado (T=Tramite, C=Consolidada, R=Con Rectificatoria, D=Con Devolucion, A=Anulada)
- fecha_registro
- usuario_registro
- dias_trabajados_original (nuevo campo)
- dias_trabajados_nuevo (nuevo campo, opcional)
- modo_recalculo (nuevo campo, S/N para indicar si se usó recálculo)
- sustento_general
- archivo_pdf
- fecha_modificacion
- usuario_modificacion

**nom_rebaja_devolucion_det** (Detalle)
- id_rebaja_devolucion
- codigo_concepto
- grupo_concepto (nuevo campo para identificar CONREBDEV)
- monto_dice
- monto_debe_decir
- diferencia
- fue_recalculado (nuevo campo, S/N para indicar si vino del recálculo automático)

**nom_periodo_estado**
- año
- periodo
- estado (P=Proceso, C=Cerrado)
- fecha_cierre
- usuario_cierre

### Grupo de conceptos CONREBDEV

Debe existir una tabla maestra de conceptos donde se identifica qué conceptos pertenecen al grupo CONREBDEV. Este grupo incluye típicamente:
- Remuneración básica
- Asignaciones
- Bonificaciones  
- Gratificaciones
- Horas extras
- Otros conceptos de haberes que se calculan proporcionalmente a días trabajados

**IMPORTANTE:** Los descuentos, retenciones y aportes del empleador NO pertenecen a este grupo y NO deben ser recalculados automáticamente.

---

__Fin del documento__
