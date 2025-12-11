-- ============================================================================
-- SCRIPT CONSOLIDADO: Sistema de Rebajas y Devoluciones
-- Descripción: Script unificado que ejecuta secuencialmente la creación de
--              tablas e inserción de datos para el módulo de Rebajas y Devoluciones
-- Fecha: 27/10/2025
-- ============================================================================

USE testing5
GO

-- ============================================================================
-- 01. CREAR TABLA: PR_PlanillaPeriodo_Rebaja_Devolucion
-- ============================================================================
PRINT '01. Creando tabla PR_PlanillaPeriodo_Rebaja_Devolucion...'
GO

--DROP TABLE PR_PlanillaPeriodo_Rebaja_Devolucion
CREATE TABLE PR_PlanillaPeriodo_Rebaja_Devolucion(
    periodo_id INT PRIMARY KEY IDENTITY(1,1),
    periodo VARCHAR(7) NOT NULL,  -- Formato: YYYY-MM
    anio INT NOT NULL,
    estado VARCHAR(20) NOT NULL,  -- PROCESO, CERRADO
    fecha_cierre DATETIME,
    usuario_cierre VARCHAR(20),
    fecha_creacion DATETIME NOT NULL,
    usuario_creacion VARCHAR(20) NOT NULL,
    fecha_modificacion DATETIME,
    usuario_modificacion VARCHAR(20),

    -- Índices para mejorar el rendimiento
    INDEX idx_periodo (periodo),
    INDEX idx_anio (anio),
    INDEX idx_estado (estado)
);

-- Restricción de verificación para el estado
ALTER TABLE PR_PlanillaPeriodo_Rebaja_Devolucion
ADD CONSTRAINT chk_estado
CHECK (estado IN ('PROCESO', 'CERRADO'));

PRINT 'Tabla PR_PlanillaPeriodo_Rebaja_Devolucion creada exitosamente.'
GO

-- ============================================================================
-- 02. INSERTAR DATOS: Periodos desde 2020 hasta 2099
-- ============================================================================
PRINT '02. Insertando periodos desde 2020 hasta 2099...'
GO

-- INSERT de periodos desde 2020 hasta 2099 con estado según la fecha actual
DECLARE @anio INT = 2020;
DECLARE @mes INT;
DECLARE @periodo VARCHAR(7);
DECLARE @fecha_actual DATETIME = GETDATE();
DECLARE @anio_actual INT = YEAR(@fecha_actual);
DECLARE @mes_actual INT = MONTH(@fecha_actual);
DECLARE @estado VARCHAR(20);
DECLARE @fecha_cierre DATETIME;

WHILE @anio <= 2099
BEGIN
    SET @mes = 1;

    WHILE @mes <= 12
    BEGIN
        -- Formato del periodo: YYYY-MM
        SET @periodo = CAST(@anio AS VARCHAR(4)) + '-' + RIGHT('0' + CAST(@mes AS VARCHAR(2)), 2);

        -- Determinar estado: CERRADO si el periodo ya pasó, PROCESO si es actual o futuro
        IF (@anio < @anio_actual) OR (@anio = @anio_actual AND @mes < @mes_actual)
        BEGIN
            SET @estado = 'CERRADO';
            -- Fecha de cierre: último día del mes a las 23:59:59
            SET @fecha_cierre = DATEADD(SECOND, -1, DATEADD(MONTH, 1, CAST(@periodo + '-01' AS DATETIME)));
        END
        ELSE
        BEGIN
            SET @estado = 'PROCESO';
            SET @fecha_cierre = NULL;
        END

        INSERT INTO PR_PlanillaPeriodo_Rebaja_Devolucion
            (periodo, anio, estado, fecha_cierre, usuario_cierre, fecha_creacion, usuario_creacion, fecha_modificacion, usuario_modificacion)
        VALUES
            (@periodo, @anio, @estado, @fecha_cierre,
             CASE WHEN @estado = 'CERRADO' THEN 'SYSTEM' ELSE NULL END,
             @fecha_actual, 'SYSTEM', NULL, NULL);

        SET @mes = @mes + 1;
    END

    SET @anio = @anio + 1;
END

PRINT 'Periodos insertados exitosamente.'
GO

-- ============================================================================
-- 03. CREAR TABLA: PR_RebajaDevolucionCab (Cabecera)
-- ============================================================================
PRINT '03. Creando tabla PR_RebajaDevolucionCab...'
GO

CREATE TABLE [dbo].[PR_RebajaDevolucionCab](
    [IdRebajaDevolucion] [int] IDENTITY(1,1) NOT NULL,
    [Periodo] [char](8) NOT NULL,
    [TipoPlanilla] [char](2) NOT NULL,
    [TipoProceso] [char](3) NOT NULL,
    [Empleado] [int] NOT NULL,
    [TipoRegistro] [char](1) NOT NULL, -- 'R'=REBAJA, 'D'=DEVOLUCION
    [Estado] [char](1) NOT NULL DEFAULT 'T', -- T=TRAMITE, C=CONSOLIDADA, R=CON RECTIFICATORIA, D=CON DEVOLUCION, A=ANULADA
    [DescripcionTramite] [varchar](500) NULL,
    [ArchivoPDFTramite] [varchar](255) NULL,
	[UUIDPDFTramite] [varchar](255) NULL,
    [TotalMonto] [money] NULL,
    [DiasTrabajadosOriginal] [int] NULL, -- Días trabajados originales del empleado (para recálculo proporcional)

    -- Auditoría - Creación
    [FechaCreacion] [datetime] NULL DEFAULT GETDATE(),
    [UsuarioCreacion] [char](20) NULL,

    -- Para CONSOLIDADA (solo Rebajas)
    [FechaConsolidacion] [datetime] NULL,
    [UsuarioConsolidacion] [char](20) NULL,
    [DescripcionConsolidada] [varchar](500) NULL,

    -- Para CON RECTIFICATORIA (solo Devoluciones)
    [FechaRectificatoria] [datetime] NULL,
    [UsuarioRectificatoria] [char](20) NULL,
    [DescripcionRectificatoria] [varchar](500) NULL,
    [ArchivoPDFRectificatoria] [varchar](255) NULL,
	[UUIDPDFRectificatoria] [varchar](255) NULL,

    -- Para CON DEVOLUCION (solo Devoluciones)
    [FechaDevolucion] [datetime] NULL,
    [UsuarioDevolucion] [char](20) NULL,
    [DescripcionDevolucion] [varchar](500) NULL,
    [ArchivoPDFDevolucion] [varchar](255) NULL,
	[UUIDPDFDevolucion] [varchar](255) NULL,

    -- Para ANULADA
    [FechaAnulacion] [datetime] NULL,
    [UsuarioAnulacion] [char](20) NULL,
    [DescripcionAnulacion] [varchar](500) NULL,
    [ArchivoPDFAnulacion] [varchar](255) NULL,
	[UUIDPDFAnulacion] [varchar](255) NULL,

    -- Auditoría - Última Modificación
    [UltimoUsuario] [char](20) NULL,
    [UltimaFechaModif] [datetime] NULL,
    [TimeStamp] [timestamp] NULL,

    CONSTRAINT [PK_RebajaDevolucionCab] PRIMARY KEY CLUSTERED
    (
        [IdRebajaDevolucion] ASC
    )
) ON [PRIMARY]
GO

-- Constraints
ALTER TABLE [dbo].[PR_RebajaDevolucionCab]
ADD CONSTRAINT [CK_TipoRegistro] CHECK ([TipoRegistro] IN ('R', 'D'))
GO

ALTER TABLE [dbo].[PR_RebajaDevolucionCab]
ADD CONSTRAINT [CK_Estado] CHECK ([Estado] IN ('T', 'C', 'R', 'D', 'A'))
GO

-- Índices
CREATE NONCLUSTERED INDEX [IX_RebajaDevCab_Periodo_Empleado]
ON [dbo].[PR_RebajaDevolucionCab] ([Periodo], [Empleado])
INCLUDE ([TipoRegistro], [Estado])
GO

CREATE NONCLUSTERED INDEX [IX_RebajaDevCab_Estado]
ON [dbo].[PR_RebajaDevolucionCab] ([Estado], [TipoRegistro])
GO

CREATE NONCLUSTERED INDEX [IX_RebajaDevCab_TipoRegistro]
ON [dbo].[PR_RebajaDevolucionCab] ([TipoRegistro], [Estado], [Periodo])
GO

PRINT 'Tabla PR_RebajaDevolucionCab creada exitosamente.'
GO

-- ============================================================================
-- 04. CREAR TABLA: PR_RebajaDevolucionDet (Detalle)
-- ============================================================================
PRINT '04. Creando tabla PR_RebajaDevolucionDet...'
GO

CREATE TABLE [dbo].[PR_RebajaDevolucionDet](
    [IdRebajaDevolucion] [int] NOT NULL,
    [Concepto] [char](4) NOT NULL,
    [MontoOriginal] [money] NULL,
    [MontoAjuste] [money] NOT NULL,
    [MontoFinal] [money] NULL,
    [Observacion] [varchar](255) NULL,
    [UltimoUsuario] [char](20) NULL,
    [UltimaFechaModif] [datetime] NULL,
    [TimeStamp] [timestamp] NULL,

    CONSTRAINT [PK_RebajaDevolucionDet] PRIMARY KEY CLUSTERED
    (
        [IdRebajaDevolucion] ASC,
        [Concepto] ASC
    ),
    CONSTRAINT [FK_RebajaDevDet_Cabecera] FOREIGN KEY([IdRebajaDevolucion])
        REFERENCES [dbo].[PR_RebajaDevolucionCab] ([IdRebajaDevolucion])
        ON DELETE CASCADE,
    CONSTRAINT [FK_RebajaDevDet_Concepto] FOREIGN KEY([Concepto])
        REFERENCES [dbo].[pr_concepto] ([Concepto])
) ON [PRIMARY]
GO

-- Índice
CREATE NONCLUSTERED INDEX [IX_RebajaDevDet_Concepto]
ON [dbo].[PR_RebajaDevolucionDet] ([Concepto])
GO

PRINT 'Tabla PR_RebajaDevolucionDet creada exitosamente.'
GO

-- ============================================================================
-- 05. CREAR TABLA: PR_RebajaDevolucionEstado (Estados y datos maestros)
-- ============================================================================
PRINT '05. Creando tabla PR_RebajaDevolucionEstado e insertando datos maestros...'
GO

CREATE TABLE [dbo].[PR_RebajaDevolucionEstado](
    [Estado] [char](1) NOT NULL,
    [TipoRegistro] [char](1) NOT NULL, -- 'R'=REBAJA, 'D'=DEVOLUCION
    [Descripcion] [varchar](50) NOT NULL,
    [Orden] [int] NOT NULL,
    [PermiteModificar] [bit] NOT NULL,
    [PermiteAnular] [bit] NOT NULL,

    CONSTRAINT [PK_RebajaDevolucionEstado] PRIMARY KEY CLUSTERED
    (
        [Estado] ASC,
        [TipoRegistro] ASC
    )
) ON [PRIMARY]
GO

-- Insertar datos maestros de estados para REBAJAS
INSERT INTO [dbo].[PR_RebajaDevolucionEstado]
([Estado], [TipoRegistro], [Descripcion], [Orden], [PermiteModificar], [PermiteAnular])
VALUES
('T', 'R', 'TRAMITE', 1, 1, 1),
('C', 'R', 'CONSOLIDADA', 2, 0, 0),
('A', 'R', 'ANULADA', 99, 0, 0)
GO

-- Insertar datos maestros de estados para DEVOLUCIONES
INSERT INTO [dbo].[PR_RebajaDevolucionEstado]
([Estado], [TipoRegistro], [Descripcion], [Orden], [PermiteModificar], [PermiteAnular])
VALUES
('T', 'D', 'TRAMITE', 1, 1, 1),
('R', 'D', 'CON RECTIFICATORIA', 2, 0, 0),
('D', 'D', 'CON DEVOLUCION', 3, 0, 0),
('A', 'D', 'ANULADA', 99, 0, 0)
GO

PRINT 'Tabla PR_RebajaDevolucionEstado creada y datos maestros insertados exitosamente.'
GO

-- ============================================================================
-- FIN DEL SCRIPT CONSOLIDADO
-- ============================================================================
PRINT ''
PRINT '============================================================================'
PRINT 'SCRIPT CONSOLIDADO EJECUTADO EXITOSAMENTE'
PRINT 'Tablas creadas:'
PRINT '  - PR_PlanillaPeriodo_Rebaja_Devolucion'
PRINT '  - PR_RebajaDevolucionCab'
PRINT '  - PR_RebajaDevolucionDet'
PRINT '  - PR_RebajaDevolucionEstado'
PRINT '============================================================================'
GO
