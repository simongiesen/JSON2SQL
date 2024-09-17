CREATE FUNCTION [entwurf1].[JSON_VALUE]
(
    @JSON NVARCHAR(MAX),   -- Das JSON-Objekt
    @key NVARCHAR(255)     -- Der JSON-Schlüssel, dessen Wert extrahiert werden soll
)
RETURNS NVARCHAR(MAX)
AS
BEGIN
    DECLARE @value NVARCHAR(MAX);
    DECLARE @start INT;
    DECLARE @end INT;
    DECLARE @firstChar NVARCHAR(1);

    -- Suche den Schlüssel im JSON-Objekt
    SET @start = CHARINDEX('"' + @key + '":', @JSON);
    
    IF @start > 0
    BEGIN
        -- Verschiebe den Startpunkt, um den Wert nach dem Schlüssel zu finden
        SET @start = @start + LEN(@key) + 3; -- +3 für '":'

        -- Prüfe, ob der erste Charakter nach dem Doppelpunkt ein Anführungszeichen ist (String) oder eine Zahl
        SET @firstChar = SUBSTRING(@JSON, @start, 1);

        IF @firstChar = '"'
        BEGIN
            -- Es handelt sich um einen String, also suche das nächste Anführungszeichen
            SET @end = CHARINDEX('"', @JSON, @start + 1);
            IF @end > @start
            BEGIN
                SET @value = SUBSTRING(@JSON, @start + 1, @end - @start - 1);
            END
        END
        ELSE
        BEGIN
            -- Es handelt sich um eine Zahl, also suche das nächste Komma oder die schließende Klammer
            SET @end = CHARINDEX(',', @JSON, @start);
            IF @end = 0 
            BEGIN
                -- Falls kein Komma gefunden wird, suche die schließende Klammer
                SET @end = CHARINDEX('}', @JSON, @start);
            END
            
            IF @end > @start
            BEGIN
                -- Extrahiere den Zahlenwert
                SET @value = SUBSTRING(@JSON, @start, @end - @start);
            END
        END
    END
    ELSE
    BEGIN
        -- Schlüssel nicht gefunden
        SET @value = NULL;
    END
    
    RETURN @value;
END