USE [testing5]
GO

/****** Object:  Table [dbo].[PR_RebajaDevolucionEstado]    Script Date: 23/10/2025 14:26:16 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[PR_RebajaDevolucionEstado](
	[Estado] [char](1) NOT NULL,
	[TipoRegistro] [char](1) NOT NULL,
	[Descripcion] [varchar](50) NOT NULL,
	[Orden] [int] NOT NULL,
	[PermiteModificar] [bit] NOT NULL,
	[PermiteAnular] [bit] NOT NULL,
 CONSTRAINT [PK_RebajaDevolucionEstado] PRIMARY KEY CLUSTERED 
(
	[Estado] ASC,
	[TipoRegistro] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO


