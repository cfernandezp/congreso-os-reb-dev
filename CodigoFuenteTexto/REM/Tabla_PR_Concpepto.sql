USE [testing5]
GO

/****** Object:  Table [dbo].[pr_concepto]    Script Date: 19/12/2025 11:09:16 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[pr_concepto](
	[Concepto] [char](4) NOT NULL,
	[TipoConcepto] [char](2) NULL,
	[Descripcion] [char](30) NULL,
	[TextoImpresion] [char](25) NULL,
	[MonedaFuente] [char](2) NULL,
	[MonedaPago] [char](2) NULL,
	[PlanillaOrden] [int] NULL,
	[EsPersonal] [char](1) NULL,
	[ValidacionMonetaria] [char](4) NULL,
	[ValidacionCantidad] [char](4) NULL,
	[ValidacionInformacionOpcional1] [char](4) NULL,
	[ValidacionInformacionOpcional2] [char](4) NULL,
	[DescripcionCantidadAuxiliar] [varchar](100) NULL,
	[DescripcionInformacionOpc1] [varchar](100) NULL,
	[DescripcionInformacionOpc2] [varchar](100) NULL,
	[FlagProveedor] [char](1) NULL,
	[Proveedor] [int] NULL,
	[ValorDefectoMonetario] [float] NULL,
	[ValorDefectoCantidadAuxiliar] [float] NULL,
	[ValorDefectoOpc1] [float] NULL,
	[ValorDefectoOpc2] [float] NULL,
	[TieneInformacionLiquidacion] [char](1) NULL,
	[Estado] [char](1) NULL,
	[UltimoUsuario] [char](20) NULL,
	[UltimaFechaModif] [datetime] NULL,
	[ConceptoGrupo] [char](2) NULL,
	[ControlCC] [char](1) NULL,
	[ControlCCAcarrearNodescontado] [char](1) NULL,
	[ControlCCPermanente] [char](1) NULL,
	[ControlCCSaldoCuota] [char](1) NULL,
	[ControlCCAmortizar] [char](1) NULL,
	[FlagProveedorCxP] [char](1) NULL,
	[EsConfidencialFlag] [char](1) NULL,
	[FlagAuditable] [char](1) NULL,
	[ConceptoCliente] [char](4) NULL,
	[ConceptoCliente1] [char](4) NULL,
	[ConceptoCliente2] [char](4) NULL,
	[ConceptoCliente3] [char](4) NULL,
	[ConceptoCliente4] [char](4) NULL,
	[ConceptoCliente5] [char](4) NULL,
	[textoimpresionextranjero] [char](25) NULL,
	[CODIGOANTERIOR] [varchar](4) NULL,
	[DescripcionCompleta] [char](65) NULL,
	[ReferenciaFiscal02] [char](20) NULL,
	[FlagReintegro] [char](1) NULL,
	[conceptoRTPS] [char](4) NULL,
 CONSTRAINT [PK_pr_concepto] PRIMARY KEY CLUSTERED 
(
	[Concepto] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[pr_concepto]  WITH CHECK ADD FOREIGN KEY([ConceptoGrupo])
REFERENCES [dbo].[PR_ConceptoGrupo] ([ConceptoGrupo])
GO

ALTER TABLE [dbo].[pr_concepto]  WITH CHECK ADD FOREIGN KEY([TipoConcepto])
REFERENCES [dbo].[PR_TipoConcepto] ([TipoConcepto])
GO


