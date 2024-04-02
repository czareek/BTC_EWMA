# BTC_EWMA 
## Cel Projektu:

Celem projektu było stworzenie prostego systemu inwestycyjnego opartego na analizie danych dotyczących kursu Bitcoina. Strategia miała być przetestowana na danych treningowych, a jej skuteczność miała być zweryfikowana na danych testowych.

## Wykorzystane Dane:

Dane dotyczące kursu Bitcoina zostały wczytane z plików "bitcoin.csv" (dane treningowe) i "bitcoin2024.csv" (dane testowe).

## Struktura Kodu:

Kod został podzielony na trzy funkcje:
- `loadBitcoinData` - wczytuje dane, sortuje je chronologicznie i przekształca niektóre kolumny na numeryczne.
- `mymethod` - implementuje strategię inwestycyjną na podstawie analizy średniej ważonej kroczącej eksponencjalnej (EWMA) oraz warunków transakcyjnych.
- `raport` - przeprowadza analizę strategii na danych testowych, generuje raport ze stanem portfela i tworzy wykres strategii inwestycyjnej.

## Wyniki:

Strategia wygenerowała zadowalający wynik w postaci stanu portfela w Bitcoinach na ostatni dzień zbioru testowego, który wyniósł 24.4634. Należy jednak pamiętać, że wyniki finansowe oparte na historycznych notowaniach mają ograniczone znaczenie w przewidywaniu przyszłych wyników inwestycyjnych.


## Uwagi i Kierunki Rozwoju:

- Kod nie obejmuje obsługi opłat transakcyjnych, co może wpłynąć na rzeczywiste wyniki inwestycji.
- Zakłada się dostępność wystarczającej ilości zamówień w order book'u każdego dnia, co w praktyce może być ograniczeniem.
- Dalszy rozwój projektu może obejmować optymalizację strategii, uwzględnienie bieżącej sytuacji na runku w tym wyróżnienie okresów podwyższonego ryzyka do modyfikacji reguł decyzyjnych.

## Wnioski:

Projekt dostarcza podstawowy szkielet strategii inwestycyjnej, ale wymaga dalszej pracy w celu dostosowania do realnych warunków rynkowych. Uwzględnienie opłat transakcyjnych, dodatkowych wskaźników i ulepszeń w algorytmie może poprawić skuteczność strategii.
