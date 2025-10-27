use testing5
go
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
    [TotalMonto] [money] NULL,
    [DiasTrabajadosOriginal] [int] NULL, -- D�as trabajados originales del empleado (para rec�lculo proporcional)

    -- Auditor�a - Creaci�n
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
    
    -- Para CON DEVOLUCION (solo Devoluciones)
    [FechaDevolucion] [datetime] NULL,
    [UsuarioDevolucion] [char](20) NULL,
	[DescripcionDevolucion] [varchar](500) NULL,
    [ArchivoPDFDevolucion] [varchar](255) NULL,
    
    -- Para ANULADA
    [FechaAnulacion] [datetime] NULL,    
    [UsuarioAnulacion] [char](20) NULL,
	[DescripcionAnulacion] [varchar](500) NULL,
    [ArchivoPDFAnulacion] [varchar](255) NULL,

    -- Auditor�a - �ltima Modificaci�n
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

-- �ndices
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