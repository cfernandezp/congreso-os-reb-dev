USE [testing5]
GO
CREATE TABLE [dbo].[PR_RebajaDevolucionEstado](
    [Estado] [char](1) NOT NULL,
    [TipoRegistro] [char](1) NOT NULL, -- 'R'=REBAJA, 'D'=DEVOLUCION
    [Descripcion] [varchar](50) NOT NULL,
    [Orden] [int] NOT NULL,
    [PermiteModificar] [bit] NOT NULL,
    [PermiteAnular] [bit] NOT NULL,
    
    CONSTRAINT [PK_RebajaDevolucionEstado] PRIMARY KEY CLUSTERED 
    (
        [Estado] ASC,
        [TipoRegistro] ASC
    )
) ON [PRIMARY]
GO

-- Insertar datos maestros de estados para REBAJAS
INSERT INTO [dbo].[PR_RebajaDevolucionEstado] 
([Estado], [TipoRegistro], [Descripcion], [Orden], [PermiteModificar], [PermiteAnular])
VALUES 
('T', 'R', 'TRAMITE', 1, 1, 1),
('C', 'R', 'CONSOLIDADA', 2, 0, 0),
('A', 'R', 'ANULADA', 99, 0, 0)
GO

-- Insertar datos maestros de estados para DEVOLUCIONES
INSERT INTO [dbo].[PR_RebajaDevolucionEstado] 
([Estado], [TipoRegistro], [Descripcion], [Orden], [PermiteModificar], [PermiteAnular])
VALUES 
('T', 'D', 'TRAMITE', 1, 1, 1),
('R', 'D', 'CON RECTIFICATORIA', 2, 0, 0),
('D', 'D', 'CON DEVOLUCION', 3, 0, 0),
('A', 'D', 'ANULADA', 99, 0, 0)
GO