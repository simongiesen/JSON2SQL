CREATE FUNCTION [entwurf1].[JSON_ARRAY_ELEMENT]
(
    @JSON NVARCHAR(MAX),  -- JSON-Array
    @index INT            -- Index des gewünschten Elements (beginnend bei 1)
)
RETURNS NVARCHAR(MAX)
AS
BEGIN
    DECLARE @element NVARCHAR(MAX);
    DECLARE @start INT;
    DECLARE @end INT;
    DECLARE @counter INT = 1;
    DECLARE @jsonArray NVARCHAR(MAX) = LTRIM(RTRIM(SUBSTRING(@JSON, PATINDEX('%[%', @JSON) + 1, LEN(@JSON)))); -- Trim opening [
    
    SET @jsonArray = LEFT(@jsonArray, LEN(@jsonArray) - PATINDEX('%]%', REVERSE(@jsonArray))); -- Trim closing ]
    
    WHILE @counter <= @index
    BEGIN
        -- Suche nach dem Start der nächsten '{'
        SET @start = CHARINDEX('{', @jsonArray);
        IF @start = 0 BREAK;

        -- Suche nach dem Ende des aktuellen JSON-Objekts '}'
        SET @end = CHARINDEX('}', @jsonArray, @start);
        IF @end = 0 BREAK;

        -- Extrahiere das JSON-Objekt
        IF @counter = @index
        BEGIN
            SET @element = SUBSTRING(@jsonArray, @start, @end - @start + 1);
            RETURN @element;
        END

        -- Schneide das verarbeitete Element ab und fahre fort
        SET @jsonArray = LTRIM(SUBSTRING(@jsonArray, @end + 1, LEN(@jsonArray) - @end));
        SET @counter = @counter + 1;
    END
    
    RETURN NULL;
END