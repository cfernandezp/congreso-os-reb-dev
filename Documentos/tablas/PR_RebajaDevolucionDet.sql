USE [testing5]
GO

/****** Object:  Table [dbo].[PR_RebajaDevolucionDet]    Script Date: 23/10/2025 14:25:45 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[PR_RebajaDevolucionDet]  WITH CHECK ADD  CONSTRAINT [FK_RebajaDevDet_Cabecera] FOREIGN KEY([IdRebajaDevolucion])
REFERENCES [dbo].[PR_RebajaDevolucionCab] ([IdRebajaDevolucion])
ON DELETE CASCADE
GO

ALTER TABLE [dbo].[PR_RebajaDevolucionDet] CHECK CONSTRAINT [FK_RebajaDevDet_Cabecera]
GO

ALTER TABLE [dbo].[PR_RebajaDevolucionDet]  WITH CHECK ADD  CONSTRAINT [FK_RebajaDevDet_Concepto] FOREIGN KEY([Concepto])
REFERENCES [dbo].[pr_concepto] ([Concepto])
GO

ALTER TABLE [dbo].[PR_RebajaDevolucionDet] CHECK CONSTRAINT [FK_RebajaDevDet_Concepto]
GO


