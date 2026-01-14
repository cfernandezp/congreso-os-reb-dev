-- ============================================================================
-- SCRIPT UNIFICADO: Inserción completa del Reporte 076
-- Descripción: Bienes Muebles por Usuario (basado en reporte 011)
-- Módulo: Activos Fijos (FA)
-- Fecha: 14/01/2026
-- ============================================================================

USE testing5
GO

PRINT '============================================================================'
PRINT 'INICIO: Inserción del Reporte 076 - Bienes Muebles por Usuario'
PRINT '============================================================================'
PRINT ''

-- ============================================================================
-- 1. INSERT en SY_Reporte
-- ============================================================================
PRINT '1. Insertando en SY_Reporte...'

INSERT INTO [dbo].[SY_Reporte]
(
    [AplicacionCodigo],
    [ReporteCodigo],
    [DescripcionLocal],
    [DescripcionIngles],
    [Topico],
    [PeriodoImplementacion],
    [VentanaObjeto],
    [ParametrosFlag],
    [FormatoDefaultFlag],
    [DescripcionData],
    [Comentarios],
    [Restricciones],
    [Estado],
    [UltimoUsuario],
    [UltimaFechaModif],
    [ReporteStandardFlag]
)
VALUES
(
    'FA',                                    -- AplicacionCodigo: Activos Fijos
    '076',                                   -- ReporteCodigo
    'Bienes Muebles por Usuario',            -- DescripcionLocal (igual al 011)
    NULL,                                    -- DescripcionIngles
    '003',                                   -- Topico (igual al 011)
    '202601',                                -- PeriodoImplementacion
    'w_fa_rep_076_activos_empleados',        -- VentanaObjeto
    'N',                                     -- ParametrosFlag
    'P',                                     -- FormatoDefaultFlag
    NULL,                                    -- DescripcionData
    'Muestra los datos relacionados a los activos asignados por usuario',  -- Comentarios (igual al 011)
    NULL,                                    -- Restricciones
    'A',                                     -- Estado: Activo
    'ROYAL',                                 -- UltimoUsuario
    GETDATE(),                               -- UltimaFechaModif
    'N'                                      -- ReporteStandardFlag
)

IF @@ERROR = 0
    PRINT '   OK - Registro insertado en SY_Reporte'
ELSE
    PRINT '   ERROR - No se pudo insertar en SY_Reporte'
GO

-- ============================================================================
-- 2. INSERT en SY_ReporteEmpresa
-- ============================================================================
PRINT ''
PRINT '2. Insertando en SY_ReporteEmpresa...'

INSERT INTO [dbo].[SY_ReporteEmpresa]
(
    [AplicacionCodigo],
    [ReporteCodigo],
    [Empresa]
)
VALUES
(
    'FA',      -- AplicacionCodigo
    '076',     -- ReporteCodigo
    'ROYAL'    -- Empresa
)

IF @@ERROR = 0
    PRINT '   OK - Registro insertado en SY_ReporteEmpresa'
ELSE
    PRINT '   ERROR - No se pudo insertar en SY_ReporteEmpresa'
GO

-- ============================================================================
-- 3. INSERT en SeguridadAutorizacionReporte
-- ============================================================================
PRINT ''
PRINT '3. Insertando en SeguridadAutorizacionReporte...'

INSERT INTO [dbo].[SeguridadAutorizacionReporte]
(
    [Usuario],
    [AplicacionCodigo],
    [ReporteCodigo],
    [Disponible],
    [Ultimafechamodif],
    [Ultimousuario],
    [CampoData]
)
VALUES
(
    'ADMIN',
    'FA',
    '076',
    'S',
    GETDATE(),
    'ROYAL',
    NULL
),
(
    'PAT-CONGEN',
    'FA',
    '076',
    'S',
    GETDATE(),
    'ROYAL',
    NULL
),
(
    'PAT-CONREP',
    'FA',
    '076',
    'S',
    GETDATE(),
    'ROYAL',
    NULL
),
(
    'PAT-CPAGEN',
    'FA',
    '076',
    'S',
    GETDATE(),
    'ROYAL',
    NULL
),
(
    'PAT-OPEGEN',
    'FA',
    '076',
    'S',
    GETDATE(),
    'ROYAL',
    NULL
),
(
    'ROYAL',
    'FA',
    '076',
    'S',
    GETDATE(),
    'ROYAL',
    NULL
)

IF @@ERROR = 0
    PRINT '   OK - 6 usuarios insertados en SeguridadAutorizacionReporte'
ELSE
    PRINT '   ERROR - No se pudieron insertar usuarios en SeguridadAutorizacionReporte'
GO

PRINT ''
PRINT '============================================================================'
PRINT 'FIN: Inserción del Reporte 076 completada'
PRINT '============================================================================'
