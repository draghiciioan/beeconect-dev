# Comenzi Makefile BeeConect

Acest document descrie comenzile disponibile în Makefile-ul BeeConect, inclusiv comenzile nou adăugate pentru logs, down, restart și status.

## Comenzi de Bază

| Comandă | Descriere |
|---------|-----------|
| `make help` | Afișează comenzile disponibile |
| `make setup` | Configurează mediul (atât dev, cât și prod) |
| `make dev` | Pornește toate serviciile în modul de dezvoltare |
| `make prod` | Pornește toate serviciile în modul de producție |
| `make infrastructure` | Pornește doar serviciile de infrastructură |
| `make auth-service` | Pornește auth-service cu dependențele sale |
| `make customers-service` | Pornește customers-service cu dependențele sale |
| `make web-service` | Pornește web-service cu dependențele sale |
| `make stop-dev` | Oprește serviciile de dezvoltare |
| `make stop-prod` | Oprește serviciile de producție |
| `make stop` | Oprește toate serviciile (atât dev, cât și prod) |
| `make clean` | Curăță totul |

## Comenzi Noi

### Comenzi pentru Logs

Vizualizarea logurilor pentru servicii:

| Comandă | Descriere |
|---------|-----------|
| `make logs` | Vizualizează logurile pentru toate serviciile |
| `make logs-auth` | Vizualizează logurile pentru auth-service |
| `make logs-customers` | Vizualizează logurile pentru customers-service |
| `make logs-web` | Vizualizează logurile pentru web-service |

Aceste comenzi afișează ultimele 100 de linii de loguri și urmăresc noile intrări de log.

### Comanda Down

Oprește și elimină containerele, rețelele și volumele:

| Comandă | Descriere |
|---------|-----------|
| `make down` | Oprește și elimină toate containerele, rețelele și volumele |

Această comandă este similară cu `make clean`, dar fără curățarea sistemului.

### Comenzi Restart

Repornește serviciile fără reconstruire:

| Comandă | Descriere |
|---------|-----------|
| `make restart` | Repornește toate serviciile (atât dev, cât și prod) |
| `make restart-dev` | Repornește serviciile de dezvoltare |
| `make restart-prod` | Repornește serviciile de producție |

Aceste comenzi repornesc containerele fără a le reconstrui.

### Comanda Status

Verifică starea containerelor:

| Comandă | Descriere |
|---------|-----------|
| `make status` | Afișează starea tuturor containerelor |

Această comandă arată care containere rulează, porturile lor și starea lor.

## Exemple

### Exemplul 1: Vizualizarea Logurilor

Pentru a vizualiza logurile pentru serviciul de autentificare:

```
make logs-auth
```

Aceasta va afișa ultimele 100 de linii de loguri și va urmări noile intrări de log.

### Exemplul 2: Repornirea Serviciilor

Pentru a reporni toate serviciile de dezvoltare:

```
make restart-dev
```

Aceasta va reporni toate containerele din mediul de dezvoltare fără a le reconstrui.

### Exemplul 3: Verificarea Stării

Pentru a verifica starea tuturor containerelor:

```
make status
```

Aceasta va afișa care containere rulează, porturile lor și starea lor.

## Concluzie

Makefile-ul îmbunătățit oferă instrumente puternice pentru gestionarea mediului de microservicii BeeConect. Folosind aceste comenzi, puteți vizualiza cu ușurință logurile, reporni serviciile și verifica starea containerelor, făcând dezvoltarea și implementarea mai eficiente.

## Depanare Avansată

Makefile-ul include, de asemenea, funcționalități avansate de raportare a erorilor și depanare:

- **Afișare color-codată** pentru o mai bună lizibilitate și vizibilitate a erorilor
- **Raportare detaliată a erorilor** pentru a identifica unde și de ce eșuează serviciile
- **Verificarea sănătății serviciilor** pentru a verifica dacă serviciile răspund corect
- **Monitorizarea stării containerelor** pentru a verifica dacă containerele rulează corespunzător
- **Comenzi dedicate de depanare** pentru fiecare serviciu
- **Mod verbose** pentru output în timp real în timpul pornirii

### Comenzi de Depanare

| Comandă | Descriere |
|---------|-----------|
| `make check-health` | Verifică sănătatea tuturor serviciilor |
| `make debug-auth` | Depanează auth-service (stare, dependențe, sănătate, loguri) |
| `make debug-customers` | Depanează customers-service (stare, dependențe, sănătate, loguri) |
| `make debug-web` | Depanează web-service (stare, dependențe, sănătate, loguri) |

Aceste comenzi vă ajută să identificați rapid unde și de ce eșuează serviciile, făcând dezvoltarea și implementarea mai eficiente.