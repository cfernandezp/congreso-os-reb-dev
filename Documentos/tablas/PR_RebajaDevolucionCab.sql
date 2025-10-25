USE [testing5]
GO

/****** Object:  Table [dbo].[PR_RebajaDevolucionCab]    Script Date: 23/10/2025 14:23:40 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[PR_RebajaDevolucionCab](
	[IdRebajaDevolucion] [int] IDENTITY(1,1) NOT NULL,
	[Periodo] [char](8) NOT NULL,
	[TipoPlanilla] [char](2) NOT NULL,
	[TipoProceso] [char](3) NOT NULL,
	[Empleado] [int] NOT NULL,
	[TipoRegistro] [char](1) NOT NULL,
	[Estado] [char](1) NOT NULL,
	[Descripcion] [varchar](500) NULL,
	[ArchivoPDF] [varchar](255) NULL,
	[TotalMonto] [money] NULL,
	[FechaCreacion] [datetime] NULL,
	[UsuarioCreacion] [char](20) NULL,
	[FechaConsolidacion] [datetime] NULL,
	[UsuarioConsolidacion] [char](20) NULL,
	[FechaRectificatoria] [datetime] NULL,
	[NumeroOrdenRectificatoria] [varchar](50) NULL,
	[ObservacionRectificatoria] [varchar](500) NULL,
	[UsuarioRectificatoria] [char](20) NULL,
	[FechaDevolucion] [datetime] NULL,
	[NumeroNotaCredito] [varchar](50) NULL,
	[ObservacionDevolucion] [varchar](500) NULL,
	[UsuarioDevolucion] [char](20) NULL,
	[FechaAnulacion] [datetime] NULL,
	[MotivoAnulacion] [varchar](500) NULL,
	[UsuarioAnulacion] [char](20) NULL,
	[UltimoUsuario] [char](20) NULL,
	[UltimaFechaModif] [datetime] NULL,
	[TimeStamp] [timestamp] NULL,
 CONSTRAINT [PK_RebajaDevolucionCab] PRIMARY KEY CLUSTERED 
(
	[IdRebajaDevolucion] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[PR_RebajaDevolucionCab] ADD  DEFAULT ('T') FOR [Estado]
GO

ALTER TABLE [dbo].[PR_RebajaDevolucionCab] ADD  DEFAULT (getdate()) FOR [FechaCreacion]
GO

ALTER TABLE [dbo].[PR_RebajaDevolucionCab]  WITH CHECK ADD  CONSTRAINT [CK_Estado] CHECK  (([Estado]='A' OR [Estado]='D' OR [Estado]='R' OR [Estado]='C' OR [Estado]='T'))
GO

ALTER TABLE [dbo].[PR_RebajaDevolucionCab] CHECK CONSTRAINT [CK_Estado]
GO

ALTER TABLE [dbo].[PR_RebajaDevolucionCab]  WITH CHECK ADD  CONSTRAINT [CK_TipoRegistro] CHECK  (([TipoRegistro]='D' OR [TipoRegistro]='R'))
GO

ALTER TABLE [dbo].[PR_RebajaDevolucionCab] CHECK CONSTRAINT [CK_TipoRegistro]
GO


