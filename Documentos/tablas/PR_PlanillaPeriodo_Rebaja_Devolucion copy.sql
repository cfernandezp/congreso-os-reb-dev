USE [testing5]
GO

/****** Object:  Table [dbo].[PR_PlanillaPeriodo_Rebaja_Devolucion]    Script Date: 23/10/2025 14:21:17 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[PR_PlanillaPeriodo_Rebaja_Devolucion](
	[periodo_id] [int] IDENTITY(1,1) NOT NULL,
	[periodo] [varchar](7) NOT NULL,
	[anio] [int] NOT NULL,
	[estado] [varchar](20) NOT NULL,
	[fecha_cierre] [datetime] NULL,
	[usuario_cierre] [varchar](20) NULL,
	[fecha_creacion] [datetime] NOT NULL,
	[usuario_creacion] [varchar](20) NOT NULL,
	[fecha_modificacion] [datetime] NULL,
	[usuario_modificacion] [varchar](20) NULL,
PRIMARY KEY CLUSTERED 
(
	[periodo_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[PR_PlanillaPeriodo_Rebaja_Devolucion]  WITH CHECK ADD  CONSTRAINT [chk_estado] CHECK  (([estado]='CERRADO' OR [estado]='PROCESO'))
GO

ALTER TABLE [dbo].[PR_PlanillaPeriodo_Rebaja_Devolucion] CHECK CONSTRAINT [chk_estado]
GO


