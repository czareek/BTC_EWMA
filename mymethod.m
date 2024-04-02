function [sellUSD, sellBitcoin] = mymethod(filename, initialUSD, initialBitcoin)
 % Autor : Cezary Panas  nr albumu: 114562
  
    data = loadBitcoinData(filename); 

    % Oblicz średnią ważoną EWMA z ostatnich 20 dni
     
    smoothingFactor = 0.4;  % współczynnik wygładzania   0,4 

    % policz wagi dla EWMA
    EWMA = 0;
    totalWeight = 0;
    for i = 1:20
        weight = smoothingFactor^(20 - i);
        EWMA = EWMA + weight * data.Close(end - i + 1);
        totalWeight = totalWeight + weight;
    end
    EWMA = EWMA / totalWeight;

    % Inicjalizuje wyniki transakcji
    sellUSD = 0;
    sellBitcoin = 0;
       
    amount=1; % raczej nie pomaga ale pozwala zwizualizowac kiedy model chciałby kupic/sprzedac ale nie ma waluty w potfelu;
    
    % Sprawdź czy cena zamknięcia ostatniego dnia jest większa od średniej
    if data.Close(end) > 1.02 * EWMA  && abs(data.Close(end-1)-data.Close(end)) < 4*abs(data.Close(end-2)-data.Close(end-1)) 
        % Realizuje transakcję kupna bitcoina
        sellUSD = initialUSD*amount;
        sellBitcoin = 0;
    % jeżeli zasygnalizuje odwrócenie trendu sprzedaj lub jeżeli różnice stóp zwrotu są bardzo duże, ogranicz starty sprzedając odrazu (zakładam asymetrie rozkładu stóp zwrotu i okazjonalne duże straty; duża zmienność --> ogranicznie ryzyka straty) 
    elseif data.Close(end) < 0.98 * EWMA || abs(data.Close(end-1)-data.Close(end)) > 4*abs(data.Close(end-2)-data.Close(end-1)) %
        % Realizuje transakcję sprzedaży bitcoina
        sellUSD = 0;
        sellBitcoin = initialBitcoin*amount;
    end
end