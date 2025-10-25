use testing5
go
--drop table PR_PlanillaPeriodo_Rebaja_Devolucion
CREATE TABLE PR_PlanillaPeriodo_Rebaja_Devolucion(
    periodo_id INT PRIMARY KEY IDENTITY(1,1),
    periodo VARCHAR(7) NOT NULL,  -- Formato: YYYY-MM
    anio INT NOT NULL,
    estado VARCHAR(20) NOT NULL,  -- PROCESO, CERRADO
    fecha_cierre DATETIME,
    usuario_cierre VARCHAR(20),
    fecha_creacion DATETIME NOT NULL,
    usuario_creacion VARCHAR(20) NOT NULL,
    fecha_modificacion DATETIME,
    usuario_modificacion VARCHAR(20),
    
    -- Índices para mejorar el rendimiento
    INDEX idx_periodo (periodo),
    INDEX idx_anio (anio),
    INDEX idx_estado (estado),    

);

-- Restricción de verificación para el estado (si tu versión de MySQL lo soporta)
ALTER TABLE PR_PlanillaPeriodo_Rebaja_Devolucion 
ADD CONSTRAINT chk_estado 
CHECK (estado IN ('PROCESO', 'CERRADO'));

--select * from PR_PlanillaPeriodo_Rebaja_Devolucion

