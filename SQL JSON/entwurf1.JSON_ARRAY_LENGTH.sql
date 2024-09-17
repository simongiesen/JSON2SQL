CREATE FUNCTION [entwurf1].JSON_ARRAY_LENGTH
(
    @JSON NVARCHAR(MAX)   -- JSON-Array
)
RETURNS INT
AS
BEGIN
    DECLARE @count INT = 0;
    DECLARE @pos INT = 1;

    -- Schleife über den JSON-String und zähle die Anzahl der öffnenden Klammern "{"
    WHILE @pos > 0
    BEGIN
        SET @pos = PATINDEX('%{%', @JSON); -- Suche nach "{"

        IF @pos > 0
        BEGIN
            -- Zähle eine öffnende Klammer und entferne den gefundenen Teil
            SET @count = @count + 1;
            SET @JSON = SUBSTRING(@JSON, @pos + 1, LEN(@JSON) - @pos);
        END
    END

    RETURN @count; -- Anzahl der Elemente im Array
END