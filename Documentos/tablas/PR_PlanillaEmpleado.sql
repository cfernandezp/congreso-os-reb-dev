USE [testing5]
GO

/****** Object:  Table [dbo].[PR_PlanillaEmpleado]    Script Date: 23/10/2025 14:34:35 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[PR_PlanillaEmpleado](
	[Periodo] [char](8) NOT NULL,
	[TipoPlanilla] [char](2) NOT NULL,
	[Empleado] [int] NOT NULL,
	[TipoProceso] [char](3) NOT NULL,
	[CompaniaSocio] [char](8) NULL,
	[AFE] [char](15) NULL,
	[CentroCosto] [char](10) NULL,
	[SueldoBasicoLocal] [float] NULL,
	[SueldoBasicoDolar] [float] NULL,
	[VacacionDesde] [datetime] NULL,
	[VacacionHasta] [datetime] NULL,
	[Cargo] [char](4) NULL,
	[DepartamentoOperacional] [char](5) NULL,
	[Responsable] [char](4) NULL,
	[LocaciondePago] [char](4) NULL,
	[Perfil] [int] NULL,
	[TipoContrato] [char](2) NULL,
	[GradoSalario] [char](3) NULL,
	[InasistenciasInjustificadas] [int] NULL,
	[InasistenciasJustificadas] [int] NULL,
	[HorasTrabajadas] [int] NULL,
	[DiasTrabajados] [int] NULL,
	[DiasSubsidiados] [int] NULL,
	[CodigoCargo] [int] NULL,
	[TipoCambio] [float] NULL,
	[CodigoAfp] [char](3) NULL,
	[MontoAfectoIPSS] [float] NULL,
	[MontoAfectoSNP] [float] NULL,
	[MontoAfectoAccidenteTrabajo] [float] NULL,
	[MontoAfectoAFP] [float] NULL,
	[MontoAfectoImpuestoRenta] [float] NULL,
	[TotalIngresos] [float] NULL,
	[TotalEgresos] [float] NULL,
	[TotalPatronales] [float] NULL,
	[TotalProvisiones] [float] NULL,
	[TotalNeto] [float] NULL,
	[Sobregiro] [float] NULL,
	[TimeStamp] [timestamp] NULL,
	[Actividad] [char](4) NULL,
	[MontoAfectoIES] [float] NULL,
	[UltimoUsuario] [char](20) NULL,
	[UltimaFechaModif] [datetime] NULL,
	[Banco] [char](3) NULL,
	[TipoCuenta] [char](3) NULL,
	[Cuenta] [char](20) NULL,
	[TipoPago] [char](2) NULL,
	[MonedaBanco] [char](2) NULL,
	[FechaGeneracion] [datetime] NULL,
	[GeneradoPor] [char](20) NULL,
	[FlagEntregado] [char](1) NULL,
	[PorcentajeSueldo] [money] NULL,
	[FechaIngresoBoleta] [datetime] NULL,
	[RegimenPension] [varchar](5) NULL,
	[tipoasistenciasocial] [varchar](3) NULL,
	[CodigoPrograma] [char](2) NULL,
	[Programa] [char](3) NULL,
	[CodigoGrupo] [char](4) NULL,
	[AsignacionPersonal] [char](10) NULL,
	[FlagIPSSVIDA] [char](1) NULL,
	[TipoPension] [char](3) NULL,
	[DiasTrabajadosPDT] [int] NULL,
	[FECHACESEBOLETA] [datetime] NULL,
	[EstadoEmpleadoBoleta] [char](1) NULL,
	[EstadoBoleta] [char](1) NULL,
	[FechaIngresoMst] [datetime] NULL,
	[FechaInicioContrato] [datetime] NULL,
	[BancoCTS] [varchar](3) NULL,
	[TipoMonedaCTS] [varchar](2) NULL,
	[NumeroCuentaCTS] [varchar](20) NULL,
	[TipoFormula] [char](1) NULL,
	[Formula] [int] NULL,
	[NombreBoletaPdf] [varchar](60) NULL,
	[FechaAcuseRecibo] [datetime] NULL,
 CONSTRAINT [k_pr_planillaempleado] PRIMARY KEY NONCLUSTERED 
(
	[Periodo] ASC,
	[TipoPlanilla] ASC,
	[Empleado] ASC,
	[TipoProceso] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[PR_PlanillaEmpleado] ADD  DEFAULT ('A') FOR [EstadoBoleta]
GO

ALTER TABLE [dbo].[PR_PlanillaEmpleado]  WITH CHECK ADD FOREIGN KEY([TipoProceso])
REFERENCES [dbo].[PR_TipoProceso] ([TipoProceso])
GO

ALTER TABLE [dbo].[PR_PlanillaEmpleado]  WITH CHECK ADD  CONSTRAINT [FK__PR_Planil__TipoP__48E2B0DC] FOREIGN KEY([TipoPlanilla])
REFERENCES [dbo].[PR_TipoPlanilla] ([TipoPlanilla])
GO

ALTER TABLE [dbo].[PR_PlanillaEmpleado] CHECK CONSTRAINT [FK__PR_Planil__TipoP__48E2B0DC]
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Estado de la boleta. A=Activo, *=Anulado' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PR_PlanillaEmpleado', @level2type=N'COLUMN',@level2name=N'EstadoBoleta'
GO


