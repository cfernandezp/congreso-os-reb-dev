use testing5
go

-- INSERT de periodos desde 2020 hasta 2099 con estado según la fecha actual
DECLARE @anio INT = 2020;
DECLARE @mes INT;
DECLARE @periodo VARCHAR(7);
DECLARE @fecha_actual DATETIME = GETDATE();
DECLARE @anio_actual INT = YEAR(@fecha_actual);
DECLARE @mes_actual INT = MONTH(@fecha_actual);
DECLARE @estado VARCHAR(20);
DECLARE @fecha_cierre DATETIME;

WHILE @anio <= 2099
BEGIN
    SET @mes = 1;
    
    WHILE @mes <= 12
    BEGIN
        -- Formato del periodo: YYYY-MM
        SET @periodo = CAST(@anio AS VARCHAR(4)) + '-' + RIGHT('0' + CAST(@mes AS VARCHAR(2)), 2);
        
        -- Determinar estado: CERRADO si el periodo ya pasó, PROCESO si es actual o futuro
        IF (@anio < @anio_actual) OR (@anio = @anio_actual AND @mes < @mes_actual)
        BEGIN
            SET @estado = 'CERRADO';
            -- Fecha de cierre: último día del mes a las 23:59:59
            SET @fecha_cierre = DATEADD(SECOND, -1, DATEADD(MONTH, 1, CAST(@periodo + '-01' AS DATETIME)));
        END
        ELSE
        BEGIN
            SET @estado = 'PROCESO';
            SET @fecha_cierre = NULL;
        END
        
        INSERT INTO PR_PlanillaPeriodo_Rebaja_Devolucion 
            (periodo, anio, estado, fecha_cierre, usuario_cierre, fecha_creacion, usuario_creacion, fecha_modificacion, usuario_modificacion)
        VALUES 
            (@periodo, @anio, @estado, @fecha_cierre, 
             CASE WHEN @estado = 'CERRADO' THEN 'SYSTEM' ELSE NULL END,
             @fecha_actual, 'SYSTEM', NULL, NULL);
        
        SET @mes = @mes + 1;
    END
    
    SET @anio = @anio + 1;
END


