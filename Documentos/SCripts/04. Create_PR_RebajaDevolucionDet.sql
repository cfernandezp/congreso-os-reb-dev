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