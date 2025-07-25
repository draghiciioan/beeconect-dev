# BeeConect Authentication Service - Documentație Detaliată

## Prezentare Generală

Serviciul de Autentificare BeeConect este un microserviciu responsabil pentru autentificarea și autorizarea utilizatorilor în cadrul platformei BeeConect. Acesta oferă funcționalități pentru înregistrarea utilizatorilor, autentificare, verificare email, autentificare în doi factori și validare token. Serviciul este construit folosind FastAPI, SQLAlchemy și PostgreSQL, cu integrări suplimentare pentru mesageria RabbitMQ, cache-ul Redis și monitorizarea Prometheus.

## Structura Proiectului

Proiectul urmează o structură modulară cu separare clară a responsabilităților:

```
bee_auth_services/
├── alembic/                  # Scripturi de migrare a bazei de date
├── docs/                     # Fișiere de documentație
├── events/                   # Gestionare evenimente (RabbitMQ)
├── models/                   # Modele de bază de date
├── routers/                  # Definiții de rute API
├── schemas/                  # Scheme Pydantic pentru validare
├── services/                 # Servicii de logică de business
├── tests/                    # Suite de teste
├── utils/                    # Funcții utilitare
├── main.py                   # Punct de intrare în aplicație
├── database.py               # Configurare conexiune bază de date
├── Dockerfile                # Definiție container
└── pyproject.toml            # Dependențe proiect
```

## Configurare și Rulare

Serviciul de Autentificare BeeConect poate fi rulat în două moduri: dezvoltare (development) și producție (production). Fiecare mod are configurații specifice pentru a optimiza serviciul pentru scenariul respectiv.

### Cerințe Preliminare

- Docker și Docker Compose
- Git
- Make (opțional, dar recomandat)

### Configurare Mediu

1. Clonează repository-ul:
   ```
   git clone https://github.com/your-organization/beeconect-dev.git
   cd beeconect-dev
   ```

2. Configurează mediul:
   ```
   make setup
   ```

### Rulare în Mediul de Dezvoltare

Mediul de dezvoltare este optimizat pentru dezvoltare rapidă, cu reîncărcare automată a codului și instrumente de depanare.

1. Asigură-te că fișierul `.env.development` conține configurațiile corecte:
   ```
   ENV=development
   DEBUG=true
   JWT_SECRET_KEY=dev-jwt-secret-key-123
   AUTH_DB_PASSWORD=auth_pass_123
   JWT_ALGORITHM=HS256
   TOKEN_EXPIRATION_SECONDS=7200
   REDIS_PASSWORD=
   RABBITMQ_USER=admin
   RABBITMQ_PASSWORD=admin
   CORS_ORIGINS=http://localhost:3000,http://localhost:8080
   ENABLE_METRICS=true
   AUTH_SERVICE_WORKERS=1
   ```

2. Pornește serviciile în modul dezvoltare:
   ```
   make dev
   ```

3. Accesează serviciile:
   - Serviciul de Autentificare: http://localhost:8001
   - Dashboard Traefik: http://localhost:8080
   - Management RabbitMQ: http://localhost:15672 (user: admin, password: admin)

4. Pentru a opri serviciile:
   ```
   make stop-dev
   ```

### Rulare în Mediul de Producție

Mediul de producție este optimizat pentru performanță, securitate și fiabilitate.

1. Configurează fișierul `.env.production` cu valorile corecte:
   ```
   ENV=production
   DEBUG=false
   JWT_SECRET_KEY=CHANGE_THIS_TO_A_SECURE_RANDOM_STRING
   AUTH_DB_PASSWORD=CHANGE_THIS_TO_A_SECURE_PASSWORD
   JWT_ALGORITHM=HS256
   TOKEN_EXPIRATION_SECONDS=3600
   REDIS_PASSWORD=CHANGE_THIS_TO_A_SECURE_PASSWORD
   RABBITMQ_USER=beeconect
   RABBITMQ_PASSWORD=CHANGE_THIS_TO_A_SECURE_PASSWORD
   CORS_ORIGINS=https://app.beeconect.com,https://admin.beeconect.com
   ENABLE_METRICS=true
   SENTRY_DSN=YOUR_SENTRY_DSN_HERE
   AUTH_SERVICE_WORKERS=2
   DOMAIN_NAME=beeconect.com
   ACME_EMAIL=admin@beeconect.com
   TRAEFIK_BASIC_AUTH=admin:$$apr1$$CHANGE_THIS_TO_HTPASSWD_HASH
   ```

   **Important**: 
   - Înlocuiește toate valorile placeholder cu valori securizate reale.
   - Observați că semnele dollar ($) din hash-ul htpasswd sunt dublate ($$). Acest lucru este necesar pentru a evita ca Docker Compose să le interpreteze ca referințe de variabile. Fără această dublare, veți vedea avertismente precum "The 'apr1' variable is not set".

2. Generează un hash pentru autentificarea de bază Traefik:
   ```
   docker run --rm httpd:2.4-alpine htpasswd -nbB admin "your-secure-password" | cut -d ":" -f 2
   ```

3. Pornește serviciile în modul producție:
   ```
   make prod
   ```

4. Accesează serviciile:
   - Serviciul de Autentificare: https://auth.beeconect.com
   - Dashboard Traefik: https://traefik.beeconect.com (protejat cu autentificare de bază)

5. Pentru a opri serviciile:
   ```
   make stop-prod
   ```

## Diferențe între Mediile de Dezvoltare și Producție

| Aspect | Dezvoltare | Producție |
|--------|------------|-----------|
| **Server** | Uvicorn cu reîncărcare automată | Gunicorn cu lucrători Uvicorn |
| **Securitate** | Setări de bază, credențiale implicite | Securitate sporită, HTTPS, credențiale puternice |
| **Depanare** | Activată | Dezactivată |
| **Expirare Token** | 2 ore | 1 oră |
| **Lucrători** | 1 | 2+ |
| **Porturi Expuse** | Toate | Doar HTTP/HTTPS |
| **Monitorizare** | De bază | Completă cu Sentry |
| **Resurse** | Nelimitate | Limitate și optimizate |

## Funcționalități Principale

Serviciul de Autentificare oferă următoarele endpoint-uri API:

- `/register`: Înregistrare utilizator cu verificare email
- `/login`: Autentificare utilizator cu opțiune 2FA
- `/social-login` și `/social-callback`: Autentificare prin rețele sociale
- `/verify-email`: Endpoint verificare email
- `/verify-twofa`: Verificare autentificare în doi factori
- `/validate`: Endpoint validare token
- `/me`: Obținere informații utilizator curent

## Integrări

Serviciul se integrează cu mai multe sisteme externe:

- **PostgreSQL**: Stocare date primară
- **Redis**: Limitare rată și cache token
- **RabbitMQ**: Mesagerie evenimente
- **Prometheus**: Colectare metrici
- **Sentry**: Urmărire erori (doar în producție)

## Securitate

Serviciul implementează mai multe măsuri de securitate:

- Hashing parole cu bcrypt
- Autentificare bazată pe JWT
- Limitare rată pentru a preveni atacurile de forță brută
- Urmărire încercări de autentificare
- Autentificare în doi factori
- Verificare email
- Headere de securitate (HSTS, CSP, etc.)
- Suport pentru rotație cheie secretă

## Depanare

### Probleme Comune în Dezvoltare

1. **Serviciul nu pornește**:
   - Verifică dacă portul 8001 este disponibil
   - Asigură-te că toate serviciile dependente (PostgreSQL, Redis, RabbitMQ) sunt în execuție

2. **Erori de conexiune la baza de date**:
   - Verifică variabila DATABASE_URL în docker-compose.yml
   - Asigură-te că serviciul postgres-auth este în execuție

3. **Erori de autentificare RabbitMQ**:
   - Verifică credențialele în .env.development
   - Asigură-te că serviciul rabbitmq este în execuție

### Probleme Comune în Producție

1. **Certificatele SSL nu se generează**:
   - Verifică dacă ACME_EMAIL este configurat corect
   - Asigură-te că domeniul este configurat corect și pointează la serverul tău

2. **Performanță slabă**:
   - Crește numărul de lucrători prin variabila AUTH_SERVICE_WORKERS
   - Verifică limitele de resurse în docker-compose.prod.yml

3. **Erori de autentificare**:
   - Verifică configurațiile JWT_SECRET_KEY și JWT_ALGORITHM
   - Asigură-te că toate serviciile dependente sunt în execuție

## Concluzie

Serviciul de Autentificare BeeConect oferă o soluție de autentificare securizată și scalabilă pentru platforma BeeConect. Designul său modular permite întreținere și extindere ușoară, în timp ce configurațiile separate pentru dezvoltare și producție asigură un flux de lucru eficient pentru dezvoltatori și o experiență optimă pentru utilizatorii finali.