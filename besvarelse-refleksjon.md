# Besvarelse av refleksjonsspørsmål - DATA1500 Oppgavesett 1.3

Skriv dine svar på refleksjonsspørsmålene fra hver oppgave her.

---

## Oppgave 1: Docker-oppsett og PostgreSQL-tilkobling

### Spørsmål 1: Hva er fordelen med å bruke Docker i stedet for å installere PostgreSQL direkte på maskinen?

**Ditt svar:**

- Samme miljø på alle maskiner
- Enkelt å dele/reprodusere miljøer
- Isolering
- Lett å starte/stoppe/slette
- Containeren inneholder alt som trengs for å kjøre applikasjonen

---

### Spørsmål 2: Hva betyr "persistent volum" i docker-compose.yml? Hvorfor er det viktig?

**Ditt svar:**

Det oppretter et volum på disk som kan brukes til å lagre data, så du ikke mister dataen når containeren stoppes.

---

### Spørsmål 3: Hva skjer når du kjører `docker-compose down`? Mister du dataene?

**Ditt svar:**

Containeren stopper og du vil miste alle data som ikke er lagret i et persistent volum.

---

### Spørsmål 4: Forklar hva som skjer når du kjører `docker-compose up -d` første gang vs. andre gang.

**Ditt svar:**

Første gang oppretter den miljøet og laster ned avhengigheter. Senere starter den containeren som alle rede er opprettet.

---

### Spørsmål 5: Hvordan ville du delt docker-compose.yml-filen med en annen student? Hvilke sikkerhetshensyn må du ta?

**Ditt svar:**

Det kommer an på om innholdet er hemmelig eller ikke. Om det ikke er hemmelig ville jeg bare delt det via et privat Github-repository eller lignende, og gitt vedkommende tilgang. 

Om det noe som er hemmelig ville jeg vurdert å benytte en ende-til-ende kryperingstjeneste, og i tillegg la være å lagre miljøvariabler i yaml-filen.  

---

## Oppgave 2: SQL-spørringer og databaseskjema

### Spørsmål 1: Hva er forskjellen mellom INNER JOIN og LEFT JOIN? Når bruker du hver av dem?

**Ditt svar:**

- INNER JOIN returnerer kun de elementene som er i begge tabellene
- LEFT JOIN returnerer alle elementene som er i begge tabellene og alle elementene som er i den "første" tabellen.
- RIGHT JOIN returnerer alle elementene som er i begge tabellene og alle elementene som er i den "siste" tabellen.
- FULL JOIN Returnerer alle elementene fra begge tabellene.

---

### Spørsmål 2: Hvorfor bruker vi fremmednøkler? Hva skjer hvis du prøver å slette et program som har studenter?

**Ditt svar:**

Vi bruker fremmednøkler for å lage relasjoner mellom tabeller og koble dem sammen. Hvis du prøver å slette et program som har studenter vil du få en feilmelding, fordi databasen beskytter dataintegriteten til studenttabellen og forhindrer at de peker på et program som ikke finnes.

---

### Spørsmål 3: Forklar hva `GROUP BY` gjør og hvorfor det er nødvendig når du bruker aggregatfunksjoner.

**Ditt svar:**

GROUP BY sorterer data etter hva man definerer etter GROUP BY, f. eks for å telle antall emner en student tar og skrive det ut på én linje. Når man bruker aggregatfunksjoner vet ikke databasen automatisk hvordan den skal kombinere radene, derfor må vi definere det med en GROUP BY.

---

### Spørsmål 4: Hva er en indeks og hvorfor er den viktig for ytelse?

**Ditt svar:**

En indeks fungerer som en stikkordliste for å finne data raskere. De fleste databaser bruker B-tree (Balnced tree) som er en effektiv datastruktur. 

---

### Spørsmål 5: Hvordan ville du optimalisert en spørring som er veldig treg?

**Ditt svar:**

1. Bruke EXPLAIN ANALYZE til å finne flaskehalser
2. Sjekke om kolonnene som brukes i JOIN er indeksert
3. Unngå bruk av SELECT *
4. Optimaliser JOIN rekkefølge og logikk
   - Filtrer tidlig, prøv å begrense antall rader før man bruker JOIN
   - Unngå funksjoner i WHERE
5. Oppdater tabellstatistikken i DBMS, ANALYZE tabellnavn

---

## Oppgave 3: Brukeradministrasjon og GRANT

### Spørsmål 1: Hva er prinsippet om minste rettighet? Hvorfor er det viktig?

**Ditt svar:**

[Skriv ditt svar her]

---

### Spørsmål 2: Hva er forskjellen mellom en bruker og en rolle i PostgreSQL?

**Ditt svar:**

[Skriv ditt svar her]

---

### Spørsmål 3: Hvorfor er det bedre å bruke roller enn å gi rettigheter direkte til brukere?

**Ditt svar:**

[Skriv ditt svar her]

---

### Spørsmål 4: Hva skjer hvis du gir en bruker `DROP` rettighet? Hvilke sikkerhetsproblemer kan det skape?

**Ditt svar:**

[Skriv ditt svar her]

---

### Spørsmål 5: Hvordan ville du implementert at en student bare kan se sine egne karakterer, ikke andres?

**Ditt svar:**

[Skriv ditt svar her]

---

## Notater og observasjoner

Bruk denne delen til å dokumentere interessante funn, problemer du møtte, eller andre observasjoner:

[Skriv dine notater her]


## Oppgave 4: Brukeradministrasjon og GRANT

1. **Hva er Row-Level Security og hvorfor er det viktig?**
   - Svar her...

2. **Hva er forskjellen mellom RLS og kolonnebegrenset tilgang?**
   - Svar her...

3. **Hvordan ville du implementert at en student bare kan se karakterer for sitt eget program?**
   - Svar her...

4. **Hva er sikkerhetsproblemene ved å bruke views i stedet for RLS?**
   - Svar her...

5. **Hvordan ville du testet at RLS-policyer fungerer korrekt?**
   - Svar her...

---

## Referanser

- PostgreSQL dokumentasjon: https://www.postgresql.org/docs/
- Docker dokumentasjon: https://docs.docker.com/

