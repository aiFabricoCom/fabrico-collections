# KlubManager — Specyfikacja (MVP)

> Aplikacja do zarządzania amatorskim klubem piłkarskim. Gotowa do uruchomienia przez `/fabrico-autopilot SPEC.md`.
> Skopiuj ten plik do katalogu swojego projektu (np. `~/Projects/klub-sportowy/SPEC.md`) zanim odpalisz autopilota.
> Język dokumentu: polski; terminy techniczne i nazwy bibliotek po angielsku (standard).

## 1. Podsumowanie produktu

KlubManager to webowa aplikacja dla amatorskiego klubu piłkarskiego (ok. 5 drużyn, ~120 zawodników). Zastępuje
arkusze kalkulacyjne i czaty: w jednym miejscu prowadzi ewidencję członków i drużyn, grafik treningów i meczów,
potwierdzanie i ewidencję obecności oraz miesięczne składki członkowskie z płatnością online. Odbiorcy: zarząd
klubu (admin), trenerzy i zawodnicy/rodzice. Priorytet: prostota i mobile-first (większość ruchu z telefonu).

## 2. Użytkownicy i role

- **Admin (zarząd klubu)** — pełny dostęp: zarządza klubem, drużynami, członkami, rolami i składkami; widzi wszystko.
- **Trener** — zarządza grafikiem (treningi/mecze) i obecnością **swoich** drużyn; widzi profile zawodników swoich drużyn.
- **Zawodnik / rodzic** — widzi grafik swojej drużyny, potwierdza obecność, edytuje własny profil, opłaca składki,
  czyta powiadomienia. (Rodzic = to samo konto reprezentujące niepełnoletniego zawodnika.)

## 3. Zakres

**W zakresie (MVP):**
- uwierzytelnianie (email + hasło) i kontrola dostępu wg ról (RBAC)
- rejestracja i profile zawodników, przypisanie do drużyn
- zarządzanie drużynami
- grafik: treningi i mecze (CRUD przez trenera, podgląd przez zawodników)
- potwierdzanie obecności przez zawodników + ewidencja faktycznej obecności przez trenera
- składki członkowskie: definicja, generowanie należności, płatność online (Stripe, test mode), status zaległości
- powiadomienia in-app o zmianach w grafiku (wysyłka realna **zastępowana stubem** w MVP)
- panel/dashboard admina z kluczowymi metrykami

**Poza zakresem (świadomie NIE teraz):**
- natywne aplikacje mobilne (tylko responsywny web)
- statystyki meczowe / live score, składy meczowe, taktyka
- publiczna strona marketingowa, sklep z gadżetami
- multi-club / wiele klubów na jednej instancji (jeden klub na instalację)
- realna wysyłka email/SMS/push (interfejs gotowy, implementacja później)

## 4. Funkcje / historie użytkownika

> Każda historia ma kryteria akceptacji (testowalne). Autopilot ma zaimplementować każdą wraz z testami.

### E1. Uwierzytelnianie i role
**US1.1 — Rejestracja konta**
As a gość, I want założyć konto przez email i hasło so that móc korzystać z aplikacji.
- [ ] Walidacja: poprawny format email (unikalny), hasło min. 8 znaków.
- [ ] Nowe konto dostaje domyślnie rolę `PLAYER`.
- [ ] Po rejestracji użytkownik jest zalogowany i widzi swój (pusty) profil.
- [ ] Weryfikacja email pominięta w MVP (zostawić interfejs/TODO; nie blokować logowania).

**US1.2 — Logowanie / wylogowanie**
- [ ] Poprawne dane → sesja i przekierowanie do widoku startowego właściwego dla roli.
- [ ] Błędne dane → czytelny komunikat, brak ujawniania, które pole jest złe.
- [ ] Wylogowanie kończy sesję.

**US1.3 — Kontrola dostępu (RBAC)**
- [ ] Każda strona/akcja jest dostępna tylko dla uprawnionych ról; próba dostępu bez uprawnień → 403/redirect.
- [ ] Trener widzi/edytuje tylko zasoby swoich drużyn.
- [ ] Zawodnik widzi tylko własny profil, grafik i składki swojej drużyny.

**US1.4 — Zarządzanie rolami (admin)**
- [ ] Admin może zmienić rolę użytkownika (PLAYER ↔ COACH ↔ ADMIN).
- [ ] Admin nie może odebrać sobie ostatniej roli admina (zawsze ≥1 admin).

### E2. Profile zawodników
**US2.1 — Edycja profilu**
- [ ] Zawodnik edytuje: imię, nazwisko, data urodzenia, pozycja, numer telefonu, opcjonalnie kontakt rodzica.
- [ ] Walidacja pól; data urodzenia w przeszłości.
- [ ] Zdjęcie profilowe opcjonalne (upload pliku ≤2MB, jpg/png) — w MVP zapis lokalny/dysk, za interfejsem storage.

**US2.2 — Przypisanie do drużyny**
- [ ] Admin lub trener przypisuje zawodnika do jednej lub wielu drużyn.
- [ ] Profil pokazuje drużyny, do których należy zawodnik.

### E3. Drużyny
**US3.1 — CRUD drużyn (admin)**
- [ ] Admin tworzy/edytuje/usuwa drużynę: nazwa, kategoria wiekowa (np. U12, Seniorzy), przypisany trener.
- [ ] Usunięcie drużyny z zawodnikami wymaga potwierdzenia i nie kasuje kont zawodników (tylko powiązania).

**US3.2 — Skład drużyny**
- [ ] Trener/admin widzi listę zawodników drużyny z podstawowymi danymi i statusem składek.

### E4. Grafik (treningi i mecze)
**US4.1 — CRUD treningów (trener)**
- [ ] Trener tworzy/edytuje/odwołuje trening swojej drużyny: data, godzina start/koniec, miejsce, notatka.
- [ ] Walidacja: koniec po starcie; nie można utworzyć wydarzenia w przeszłości.

**US4.2 — CRUD meczów (trener)**
- [ ] Mecz: przeciwnik, data/godzina, miejsce, dom/wyjazd, notatka.
- [ ] Te same reguły walidacji co treningi.

**US4.3 — Podgląd grafiku (zawodnik)**
- [ ] Zawodnik widzi nadchodzące wydarzenia swojej drużyny (lista + prosty widok kalendarza, domyślnie 14 dni).
- [ ] Wydarzenia odwołane są wyraźnie oznaczone.

### E5. Obecność
**US5.1 — Deklaracja obecności (zawodnik)**
- [ ] Zawodnik ustawia status: `BĘDĘ` / `NIE BĘDĘ` / `MOŻE` dla nadchodzącego wydarzenia.
- [ ] Zmiana możliwa do momentu startu wydarzenia; po starcie zablokowana.

**US5.2 — Podgląd deklaracji (trener)**
- [ ] Trener widzi listę deklaracji per wydarzenie z licznikami (ilu będzie / nie będzie / może / brak odpowiedzi).

**US5.3 — Ewidencja faktycznej obecności (trener)**
- [ ] Po wydarzeniu trener oznacza faktyczną obecność (`PRESENT`/`ABSENT`) per zawodnik.
- [ ] Frekwencja zawodnika jest liczona (procent obecności w wybranym okresie) i widoczna w jego profilu.

### E6. Składki członkowskie i płatności
**US6.1 — Definicja składki (admin)**
- [ ] Admin definiuje miesięczną składkę: kwota i waluta (PLN), zakres (globalnie lub per drużyna).

**US6.2 — Generowanie należności**
- [ ] System generuje miesięczne należności per zawodnik (status domyślny `UNPAID`), bez duplikatów na ten sam okres.
- [ ] Zawodnik widzi swoje należności (bieżące i historyczne).

**US6.3 — Płatność online (Stripe, test mode)**
- [ ] Zawodnik/rodzic opłaca należność przez Stripe Checkout (test mode).
- [ ] Webhook Stripe ustawia status należności na `PAID` i zapisuje referencję płatności.
- [ ] Brak kluczy Stripe → integracja za interfejsem `PaymentProvider`; zostaw działający tryb „mock" (oznacz
      jako opłacone bez realnej płatności) i odnotuj w `BUILD-SUMMARY.md`, że do trybu realnego potrzebne są klucze.

**US6.4 — Dashboard płatności (admin)**
- [ ] Admin widzi, kto zalega w bieżącym miesiącu i procent opłaconych składek.

### E7. Powiadomienia (stub w MVP)
**US7.1 — Powiadomienie o zmianie grafiku**
- [ ] Utworzenie/zmiana/odwołanie wydarzenia generuje powiadomienie do zawodników danej drużyny.
- [ ] Wysyłka realna **zastąpiona stubem**: zapis do tabeli `Notification` + log; cała wysyłka za interfejsem
      `NotificationSender` (przyszła integracja email/push bez zmian w logice biznesowej).

**US7.2 — Powiadomienia in-app**
- [ ] Zawodnik widzi listę swoich powiadomień, może oznaczyć jako przeczytane; licznik nieprzeczytanych w nagłówku.

### E8. Dashboard admina
**US8.1 — Przegląd klubu**
- [ ] Kafelki: liczba członków, liczba drużyn, najbliższe wydarzenia (7 dni), % opłaconych składek w bieżącym miesiącu.

## 5. Model danych (zarys — schematy projektuje architekt)

- `User(id, email, passwordHash, role[ADMIN|COACH|PLAYER], createdAt)`
- `PlayerProfile(userId→User, firstName, lastName, birthDate, position, phone, parentContact?, photoUrl?)`
- `Team(id, name, ageCategory, coachId→User?)`
- `TeamMembership(userId→User, teamId→Team)` — relacja wiele-do-wielu User↔Team
- `Event(id, teamId→Team, type[TRAINING|MATCH], startsAt, endsAt?, location, opponent?, homeAway?, note?, cancelled)`
- `AttendanceDeclaration(eventId→Event, userId→User, status[YES|NO|MAYBE], updatedAt)`
- `AttendanceRecord(eventId→Event, userId→User, present[PRESENT|ABSENT])`
- `FeeDefinition(id, scope[GLOBAL|TEAM], teamId?→Team, amount, currency, periodType[MONTHLY])`
- `Due(id, userId→User, period[YYYY-MM], amount, status[UNPAID|PAID], paymentRef?)`
- `Notification(id, userId→User, type, payload, read, createdAt)`

## 6. Stack techniczny i ograniczenia

Wybór dokonany (architekt może dostroić detale, ale trzymaj się tej osi, żeby autopilot nie pytał):
- **Frontend/Backend:** Next.js (App Router) + TypeScript, Tailwind CSS, React Server Components gdzie sensowne.
- **Formularze/walidacja:** react-hook-form + Zod (Zod jako wspólne schematy walidacji front+back).
- **ORM/baza:** Prisma + PostgreSQL. Lokalnie Postgres przez `docker-compose`.
- **Auth:** Auth.js (NextAuth) — provider credentials (email + hasło), sesje w bazie.
- **i18n:** next-intl, domyślny język **PL**, dodatkowo **EN**.
- **Testy:** Vitest (unit/integration), Playwright (E2E). Każda historia ma testy.
- **Jakość:** ESLint + Prettier, TypeScript strict.
- Brak vendor lock-in, z którego nie da się wyeksportować danych (standardowy SQL, własne modele).

## 7. Integracje i usługi zewnętrzne

- **Płatności — Stripe (test mode):** klucze **dostarczę ja**. Do czasu ich podania działaj na interfejsie
  `PaymentProvider` z implementacją „mock" (patrz US6.3). Nie wykonuj realnych obciążeń.
- **Email / powiadomienia:** **stub w MVP** (log + zapis do bazy) za interfejsem `NotificationSender`. Bez realnej wysyłki.
- **Storage zdjęć:** lokalny katalog/dysk za interfejsem `FileStorage` (później np. S3). Bez chmury w MVP.
- **Auth zewnętrzny (Google itp.):** poza zakresem MVP.

## 8. UI / UX

- Brak Figmy — projektuj wg opisu. Czysty, **mobile-first** interfejs, język **polski** (EN jako druga wersja).
- Nawigacja zawodnika (dolny pasek na mobile): **Grafik / Obecność / Składki / Profil**.
- Trener: dodatkowo zarządzanie grafikiem i obecnością swoich drużyn.
- Admin: szerszy układ dashboardowy (kafelki metryk + sekcje zarządzania).
- Obsłuż stany: ładowanie, pusto, błąd, brak uprawnień. Komunikaty po polsku.

## 9. Wymagania niefunkcjonalne

- RBAC egzekwowane po stronie serwera (nie tylko UI).
- Responsywność mobile + desktop; podstawowa dostępność (semantyczny HTML, focus, kontrast).
- Walidacja wejścia (Zod) i czytelne błędy; brak nieobsłużonych wyjątków w UI.
- Testy automatyczne dla każdej historii (jednostkowe/integracyjne + krytyczne ścieżki E2E).
- **Seed danych demo**: 1 admin, 2 trenerów, 2 drużyny, ~10 zawodników, kilka wydarzeń i należności — żeby od razu klikać.
- Uruchomienie lokalne jedną komendą (np. `docker-compose up` + `npm run dev`), `.env.example` z wymaganymi zmiennymi.
- README z instrukcją uruchomienia i kontami demo.

## 10. Wdrożenie

**Odłóż.** W MVP buduj i uruchamiaj **lokalnie** (Postgres w Dockerze). Hosting zajmę się później — nie wdrażaj
niczego do chmury i nie konfiguruj CI/CD bez mojej zgody.

## 11. Granice autonomii

**Możesz zakładać i decydować samodzielnie (zapisz w `ASSUMPTIONS.md` i kontynuuj):**
- szczegóły stacku w ramach osi z sekcji 6, struktura folderów, dobór bibliotek pomocniczych, nazewnictwo,
- reguły walidacji nieokreślone wprost, domyślne układy/komponenty UI, treść komunikatów, dane seed,
- struktura schematu bazy i migracji, strategia testów.

**Zatrzymaj się i zapytaj mnie wyłącznie gdy:**
- potrzebny jest mój klucz/sekret (Stripe, ewentualny zewnętrzny provider) — do tego czasu używaj mocka/stuba,
- akcja byłaby płatna, nieodwracalna lub wychodząca na zewnątrz (wdrożenie, realne obciążenie karty, wysyłka maili),
- pojawia się sprzeczność w tym specu zmieniająca produkt,
- ten sam krok zawodzi 3 razy i nie potrafisz go rozwiązać.

Wszystko, czego nie da się dokończyć (np. realne płatności bez kluczy), wyląduj w `BUILD-SUMMARY.md`
w sekcji „Wymaga Twojego działania" — nie usuwaj cicho zakresu.
