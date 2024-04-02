function finalPortfolioBitcoin = raport(trainFile, testFile)
    % Autor : Cezary Panas  nr albumu: 114562
    
    % Wczytaj dane treningowe i testowe
    trainData = loadBitcoinData(trainFile);
    testData = loadBitcoinData(testFile);

    % Zapisz ostatnie 20 obserwacji ze zbioru treningowego do pliku tymczasowego
    writetable(trainData(end-19:end, :), 'dynamicTrainData.csv', 'WriteVariableNames', true);
    
    % Inicjalizuj portfel
    initialUSD = 0;
    initialBitcoin = 5; % Zakładamy, że na koniec okresu treningowego było 5 Bitcoinów

    % Inicjalizuj wektory do przechowywania wyników
    portfolioBitcoin = zeros(size(testData, 1), 1);
    actionBuy = zeros(size(testData, 1), 1);
    actionSell = zeros(size(testData, 1), 1);
    
    % Pętla dla każdego dnia ze zbioru testowego
       for i = 1:size(testData, 1)
        % Uzyskaj dane dla danego dnia
        currentData = testData(i, :);

        % Wczytaj  dynamiczny plik
        dynamicTrainData = loadBitcoinData('dynamicTrainData.csv');
        
        
        % Wywołaj funkcję mymethod
        [sellUSD, sellBitcoin] = mymethod('dynamicTrainData.csv', initialUSD, initialBitcoin);
        
        % Dodaj aktualne dane do dynamicznego zbioru treningowego
        dynamicTrainData = [dynamicTrainData; currentData]; 
        
        % Ogranicz dynamiczny zbiór treningowy do ostatnich 20 obserwacji
        dynamicTrainData = dynamicTrainData(end-19:end, :);

       
        % Formatuj daty do zapisu 
        dynamicTrainData.Date = datetime(datestr(dynamicTrainData.Date, 'dd.mm.yyyy'), 'InputFormat', 'dd.MM.yyyy');

        % Nadpisz plik tymczasowy
        writetable(dynamicTrainData, 'dynamicTrainData.csv', 'WriteVariableNames', true);
        
        % Aktualizuj portfel na podstawie transakcji przelicz dolary pośredniej cenie bitcoina
        % cena kupna i sprzedaży opiera sie na cenie zamknięcia bitcoina na
        initialUSD = initialUSD - sellUSD + sellBitcoin * currentData.Close(end);
        initialBitcoin = initialBitcoin - sellBitcoin + sellUSD / currentData.Close(end);
        %przelicz dolary pośredniej cenie bitcoina
        portfolioBitcoin(i) = initialUSD/((currentData.Close(end)+currentData.Open(end))/2) + initialBitcoin;
       
        

        % Sprawdź, czy była akcja (kupno lub sprzedaż)
        if sellUSD > 0
            actionBuy(i) = 1;
        elseif sellBitcoin > 0
            actionSell(i) = 1;
        else
            actionSell(i) = 0;
            actionBuy(i) = 0;
        
          
        end
         
        
    end
    
    %średnia cena bitcoina
    BITCOIN = (testData.Open + testData.Close) / 2;
    
    % Narysuj wykres
    figure;
    plot(testData.Date, BITCOIN, 'k-', 'LineWidth', 1.5); 
    hold on;
    scatter(testData.Date(actionBuy == 1), BITCOIN(actionBuy == 1), 50, 'r', 'filled'); % Kupno (czerwony)
    scatter(testData.Date(actionSell == 1), BITCOIN(actionSell == 1), 50, 'g', 'filled'); % Sprzedaż (zielony)
    hold off;
    xlabel('Data');
    ylabel('Średnia Cena Bitcoina');
    title('Wykres strategii inwestycyjnej');
    legend('Notowania Bitcoin', 'Kupno', 'Sprzedaż', 'Location', 'Best');
    saveas(gcf, 'strategia.jpg'); % zapisz do pliku
    
    % konwertuj daty na format string
    dateStrTest = datestr(testData.Date, 'dd.mm.yyyy');

    % konwertuj daty spowrotem na datetime
    dateColumn = datetime(dateStrTest, 'InputFormat', 'dd.MM.yyyy');

    % Zwróć stan portfela  w zbiorze testowym
    disp('Zestawienie stanu portfela w Bitcoinach w kolejnych dniach:');
    disp('         Data     | Stan portfela w Bitcoinach');
    disp([cellstr(dateColumn), num2cell(portfolioBitcoin)]);

    % Zwróć stan portfela na ostatni dzień w zbiorze testowym
    finalPortfolioBitcoin = portfolioBitcoin(end);
    disp(['Stan portfela w Bitcoinach na ostatni dzień w zbiorze testowym: ', num2str(finalPortfolioBitcoin)]);
    
    % Usuń plik pomocniczy 
    delete("dynamicTrainData.csv")

end