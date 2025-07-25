# BeeConect

BeeConect este o platformă scalabilă bazată pe microservicii care conectează afacerile locale cu clienții. Acest repository servește ca punct central de dezvoltare și orchestrare pentru întregul ecosistem de microservicii BeeConect.

## Arhitectură

Platforma BeeConect folosește o arhitectură modernă, scalabilă și distribuită:

### 🔹 Entry Point:
- BeeConect → interfață globală a platformei
- Utilizatorii interacționează prin aplicații web/mobile

### 🔹 API Gateway (Traefik):
- Reverse proxy care distribuie cereri către microservicii
- Implementează rate limiting, routing, header injection (JWT)

### 🔹 RabbitMQ – Event Router (central):
- Primește evenimente de la servicii: ex. user_created, order_placed
- Le transmite către: notifications, analytics, log_service, etc.
- Asigură o arhitectură decuplată și extensibilă

## Microservicii

### Nivel 1 (Core)

| Serviciu | Rol principal |
|----------|---------------|
| auth_service | Autentificare, JWT, OAuth, 2FA |
| business_service | Afaceri, puncte de lucru, abonamente |
| orders_service | Comenzi, rezervări, statusuri |
| notifications_service | Email/SMS, push-uri |
| payments_service | Plăți Netopia, reconciliere |

Toate serviciile folosesc baze PostgreSQL proprii.

### Nivel 2 (Extensie & Scalare)

| Serviciu | Funcționalitate |
|----------|-----------------|
| users_service | Profiluri, adrese, preferințe |
| location_service | IP2Location, geo-fencing, hartă |
| analytics_service | Statistici, KPI-uri, heatmaps |
| event_router | Centralizează/loghează evenimente RabbitMQ |
| search_service (x2) | Indexare/filtrare rapidă |
| log_service | Audit trail, observabilitate |

## Stack Tehnologic

| Componentă | Tehnologie |
|------------|------------|
| Backend API | FastAPI (microservicii separate) |
| ORM | SQLAlchemy + Alembic |
| Autentificare | JWT, OAuth2 (Google, Facebook) - via `auth_service` |
| Frontend web | TailwindCSS + HTMX (UI simplu) / React pentru dashboard |
| Mesagerie | RabbitMQ pentru comunicare asincronă între microservicii |
| Containerizare | Docker/Compose pentru orchestrare locală |
| Gateway API | Traefik |
| Monitorizare | Prometheus + Grafana (viitor) |
| Bază de date | PostgreSQL (un container DB per serviciu) |
| Mobile | Structură pregătită pentru React Native / Flutter |
| Plăți | Netopia (REST API) |

## Tipuri de Utilizatori și Roluri

| Rol | Permisiuni principale |
|-----|----------------------|
| Client | Vizualizare afaceri, comenzi, rezervări, recenzii, hartă, chat |
| Administrator afacere | Gestionare pagină, program, comenzi, statistici |
| Livrator (freelancer) | Acceptă/refuză livrări, chat, hartă |
| Colaborator zonal | Adaugă afaceri, urmărește comisioane |
| Superadmin | Control complet, statistici, moderare, setări globale |

## Instalare și Configurare

### Cerințe Preliminare
- Docker și Docker Compose
- Git

### Pași de Instalare

1. Clonează repository-ul:
   ```
   git clone https://github.com/your-organization/beeconect-dev.git
   cd beeconect-dev
   ```

2. Configurează mediul de dezvoltare:
   ```
   make setup
   ```
   
   Pentru utilizatorii Windows (folosind PowerShell):
   ```
   .\make.ps1 setup
   ```

3. Pornește toate serviciile:
   ```
   make dev
   ```
   
   Pentru utilizatorii Windows (folosind PowerShell):
   ```
   .\make.ps1 dev
   ```

4. Accesează serviciile:
   - Traefik Dashboard: http://localhost:8080
   - RabbitMQ Management: http://localhost:15672
   - Auth Service: http://localhost:8001

### Comenzi Utile

#### Pentru Linux/macOS (folosind make)

- `make help` - Afișează toate comenzile disponibile
- `make setup` - Configurează mediul de dezvoltare
- `make dev` - Pornește toate serviciile
- `make infrastructure` - Pornește doar serviciile de infrastructură (baze de date, mesagerie)
- `make auth-service` - Pornește serviciul de autentificare și componentele necesare
- `make customers-service` - Pornește serviciul de clienți și componentele necesare
- `make web-service` - Pornește interfața web și serviciile de care depinde
- `make stop` - Oprește toate serviciile
- `make clean` - Curăță tot

#### Pentru Windows (folosind PowerShell)

- `.\make.ps1 help` - Afișează toate comenzile disponibile
- `.\make.ps1 setup` - Configurează mediul de dezvoltare
- `.\make.ps1 dev` - Pornește toate serviciile
- `.\make.ps1 infrastructure` - Pornește doar serviciile de infrastructură (baze de date, mesagerie)
- `.\make.ps1 auth-service` - Pornește serviciul de autentificare și componentele necesare
- `.\make.ps1 customers-service` - Pornește serviciul de clienți și componentele necesare
- `.\make.ps1 web-service` - Pornește interfața web și serviciile de care depinde
- `.\make.ps1 stop` - Oprește toate serviciile
- `.\make.ps1 clean` - Curăță tot
- `.\make.ps1 prod` - Pornește toate serviciile în modul producție

### Rularea din PyCharm

Proiectul include configurații de rulare pentru PyCharm care permit executarea comenzilor Makefile direct din interfața IDE-ului:

1. Deschideți proiectul în PyCharm
2. Accesați meniul de rulare din partea de sus a ferestrei (dropdown lângă butonul de rulare)
3. Selectați una dintre configurațiile disponibile:
   - `setup` - Configurează mediul de dezvoltare
   - `dev` - Pornește toate serviciile
   - `prod` - Pornește toate serviciile în modul producție
   - `infrastructure` - Pornește doar serviciile de infrastructură
   - `auth-service` - Pornește serviciul de autentificare
   - `customers-service` - Pornește serviciul de clienți
   - `web-service` - Pornește interfața web
   - `stop` - Oprește toate serviciile
   - `clean` - Curăță tot
4. Apăsați butonul de rulare (săgeată verde) sau folosiți scurtătura Shift+F10

## Etape de Dezvoltare

1. ✅ **Etapa 1**: Creare `auth_service` - MVP complet + UI simplu + testare Docker
2. 🔜 **Etapa 2**: Creare `business_service` + legare la `auth_service` (validare token)
3. 🔜 **Etapa 3**: Adăugare RabbitMQ + `notifications_service`
4. 🔜 **Etapa 4**: Integrare plăți + dashboard UI
5. 🔜 **Etapa 5**: Consolidare cu API Gateway și CI/CD

## Caracteristici Speciale

- **Comunicare Event-Driven**: Toate microserviciile comunică prin evenimente RabbitMQ
- **Validare JWT Distribuită**: Serviciile validează token-urile prin `auth_service`
- **Localizare**: Suport pentru localizare prin IP și selectare manuală
- **PWA Ready**: Aplicația web este pregătită pentru funcționalitate offline
- **Planuri Tarifare**: Sistem flexibil de abonamente și comisioane

## Documentație

Documentația detaliată pentru fiecare componentă se găsește în directorul `documentatii/`:

- [Serviciul de Autentificare](documentatii/auth_service.md) - Documentație completă pentru configurarea și rularea serviciului de autentificare în mediile de dezvoltare și producție
- [Docker Compose](documentatii/docker-compose.yml.md) - Explicații detaliate pentru configurația Docker Compose
- [Makefile](documentatii/Makefile.md) - Documentație pentru comenzile disponibile în Makefile
- [Variabile de Mediu](documentatii/.env.development.md) - Explicații pentru variabilele de mediu utilizate în dezvoltare

Pentru ghiduri specifice pentru agenți AI, consultați [AGENTS.md](AGENTS.md).

## Contribuție

Fiecare microserviciu are propriul repository Git. Pentru a contribui:

1. Verificați repository-ul specific microserviciului
2. Creați un branch nou pentru funcționalitatea dorită
3. Implementați modificările respectând arhitectura event-driven
4. Testați modificările local folosind `make dev`
5. Creați un pull request către branch-ul principal

## Licență

Acest proiect este proprietar și confidențial. Toate drepturile rezervate.