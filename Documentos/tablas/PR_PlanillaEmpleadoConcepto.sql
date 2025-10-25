USE [testing5]
GO

/****** Object:  Table [dbo].[PR_PlanillaEmpleadoConcepto]    Script Date: 23/10/2025 14:35:53 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[PR_PlanillaEmpleadoConcepto](
	[Periodo] [char](8) NOT NULL,
	[TipoPlanilla] [char](2) NOT NULL,
	[TipoProceso] [char](3) NOT NULL,
	[Empleado] [int] NOT NULL,
	[Concepto] [char](4) NOT NULL,
	[Monto] [float] NULL,
	[Cantidad] [float] NULL,
	[Saldo] [money] NULL,
	[InformacionOpcional1] [float] NULL,
	[InformacionOpcional2] [float] NULL,
	[UltimoUsuario] [char](20) NULL,
	[UltimaFechaModif] [datetime] NULL,
	[TimeStamp] [timestamp] NULL,
	[ComentarioOpcional] [varchar](255) NULL,
 CONSTRAINT [ALE] PRIMARY KEY NONCLUSTERED 
(
	[Periodo] ASC,
	[TipoPlanilla] ASC,
	[TipoProceso] ASC,
	[Empleado] ASC,
	[Concepto] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[PR_PlanillaEmpleadoConcepto]  WITH CHECK ADD FOREIGN KEY([Concepto])
REFERENCES [dbo].[pr_concepto] ([Concepto])
GO


