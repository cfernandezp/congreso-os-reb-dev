-- ============================================================================
-- SCRIPT UNIFICADO: Inserción completa del Reporte 556
-- Descripción: Inserta el reporte de Rebajas y Devoluciones en todas las tablas
-- Módulo: Planilla (PR)
-- Fecha: 12/11/2025
-- ============================================================================

USE testing5
GO

PRINT '============================================================================'
PRINT 'INICIO: Inserción del Reporte 556 - Rebajas y Devoluciones'
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
    'PR',                                    -- AplicacionCodigo: Planilla
    '556',                                   -- ReporteCodigo
    'Reporte de Rebajas',               -- DescripcionLocal
    'Discount Report',                  -- DescripcionIngles
    '002',                                   -- Topico
    '202511',                                -- PeriodoImplementacion
    'w_pr_rep_556_reporte_rebajas',          -- VentanaObjeto 
    'N',                                     -- ParametrosFlag
    'P',                                     -- FormatoDefaultFlag
    NULL,                                    -- DescripcionData
    NULL,                                    -- Comentarios
    NULL,                                    -- Restricciones
    'A',                                     -- Estado: Activo
    'ROYAL',                                 -- UltimoUsuario
    GETDATE(),                               -- UltimaFechaModif
    NULL                                     -- ReporteStandardFlag
),
(
    'PR',                                    -- AplicacionCodigo: Planilla
    '557',                                   -- ReporteCodigo
    'Consolidado de Rebajas',               -- DescripcionLocal
    'Discount Summary',                  -- DescripcionIngles
    '002',                                   -- Topico
    '202511',                                -- PeriodoImplementacion
    'w_pr_rep_557_consolidado_rebajas',          -- VentanaObjeto 
    'N',                                     -- ParametrosFlag
    'P',                                     -- FormatoDefaultFlag
    NULL,                                    -- DescripcionData
    NULL,                                    -- Comentarios
    NULL,                                    -- Restricciones
    'A',                                     -- Estado: Activo
    'ROYAL',                                 -- UltimoUsuario
    GETDATE(),                               -- UltimaFechaModif
    NULL                                     -- ReporteStandardFlag
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
    'PR',      -- AplicacionCodigo
    '556',     -- ReporteCodigo
    'ROYAL'    -- Empresa
),
(
    'PR',      -- AplicacionCodigo
    '557',     -- ReporteCodigo
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
--556
(
    'NOM-CONREP',    
    'PR',
    '556',
    'S',
    GETDATE(),
    'ROYAL',
    NULL
),
(
    'NOM-REMGEN',   
    'PR',
    '556',
    'S',
    GETDATE(),
    'ROYAL',
    NULL
),
(
    'NOM-TESGEN',    
    'PR',
    '556',
    'S',
    GETDATE(),
    'ROYAL',
    NULL
),
(
    'ROYAL',         
    'PR',
    '556',
    'S',
    GETDATE(),
    'ROYAL',
    NULL
),
--557
(
    'NOM-CONREP',    
    'PR',
    '557',
    'S',
    GETDATE(),
    'ROYAL',
    NULL
),
(
    'NOM-REMGEN',   
    'PR',
    '557',
    'S',
    GETDATE(),
    'ROYAL',
    NULL
),
(
    'NOM-TESGEN',    
    'PR',
    '557',
    'S',
    GETDATE(),
    'ROYAL',
    NULL
),
(
    'ROYAL',         
    'PR',
    '557',
    'S',
    GETDATE(),
    'ROYAL',
    NULL
)

IF @@ERROR = 0
    PRINT '   OK - 4 usuarios insertados en SeguridadAutorizacionReporte'
ELSE
    PRINT '   ERROR - No se pudieron insertar usuarios en SeguridadAutorizacionReporte'
GO


