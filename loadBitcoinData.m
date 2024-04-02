function [data] = loadBitcoinData(filename)
    % Autor : Cezary Panas  nr albumu: 114562

    % załaduj csv
    data = readtable(filename);
    
    % sortuj chronologicznie
    data = sortrows(data, 'Date');
    
    % Zamiana kolumn na numeryczne : 
    numericCols = {'Open', 'High', 'Low', 'Close'};
    for col = numericCols
        % Sprawdź, czy wartości w kolumnie są komórkami i czy zawierają przecinki 
        if iscell(data.(col{1})) && any(contains(data.(col{1}), ','))
            % Konwersja komórek na liczby z zamianą przecinków na kropki
            data.(col{1}) = cellfun(@(x) str2double(strrep(x, ',', '.')), data.(col{1}));
            
            % Sprawdź czy nie powstały wartości nienumeryczne 
            if any(isnan(data.(col{1})))
                error('Błąd przy konwertowaniu kolumn na numeryczne');
            end
        end
    end
end