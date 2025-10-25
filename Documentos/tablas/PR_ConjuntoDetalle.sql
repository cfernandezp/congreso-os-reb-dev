USE [testing5]
GO

/****** Object:  Table [dbo].[PR_ConjuntoDetalle]    Script Date: 24/10/2025 17:38:58 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[PR_ConjuntoDetalle](
	[Conjunto] [char](20) NOT NULL,
	[Concepto] [char](4) NOT NULL,
	[TipoAplicacion] [char](1) NULL,
	[Signo] [int] NULL,
	[UltimoUsuario] [char](20) NULL,
	[UltimaFechaModif] [datetime] NULL,
	[TimeStamp] [timestamp] NULL,
 CONSTRAINT [k_pr_conjuntodetalle] PRIMARY KEY NONCLUSTERED 
(
	[Conjunto] ASC,
	[Concepto] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[PR_ConjuntoDetalle]  WITH CHECK ADD FOREIGN KEY([Concepto])
REFERENCES [dbo].[pr_concepto] ([Concepto])
GO

ALTER TABLE [dbo].[PR_ConjuntoDetalle]  WITH CHECK ADD FOREIGN KEY([Conjunto])
REFERENCES [dbo].[PR_Conjunto] ([Conjunto])
GO


