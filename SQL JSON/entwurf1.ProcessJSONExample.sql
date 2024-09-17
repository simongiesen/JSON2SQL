CREATE PROCEDURE [entwurf1].[ProcessJSONExample]
(
    @json NVARCHAR(MAX)  -- Übergib das JSON-Array als Parameter
)
AS
BEGIN
    DECLARE @index INT = 1;
    DECLARE @element NVARCHAR(MAX);
    DECLARE @elementCount INT;

    -- Anzahl der Elemente im Array dynamisch ermitteln
    SET @elementCount = entwurf1.JSON_ARRAY_LENGTH(@json);
	SELECT @elementCount

    -- Schleife über alle Elemente des Arrays
    WHILE @index <= @elementCount
    BEGIN
        -- Extrahiere das aktuelle Element aus dem JSON-Array
        SET @element = entwurf1.JSON_ARRAY_ELEMENT(@json, @index);
		SELECT @element

        -- Verarbeite jedes Element (z.B. LosID und VariantenID extrahieren)
        SELECT 
            entwurf1.JSON_VALUE(@element, 'LosID') AS LosID, 
            entwurf1.JSON_VALUE(@element, 'VariantenID') AS VariantenID;

        -- Erhöhe den Index, um das nächste Element zu verarbeiten
        SET @index = @index + 1;
    END
END