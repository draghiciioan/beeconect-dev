# Ghid de Verificare a Microserviciilor BeeConect

Acest document oferă instrucțiuni complete pentru verificarea și asigurarea funcționării corecte a tuturor microserviciilor din platforma BeeConect. Urmați acești pași pentru a valida că fiecare serviciu funcționează conform așteptărilor.

## Cuprins

1. [Cerințe preliminare](#cerințe-preliminare)
2. [Prezentare generală a procesului de verificare](#prezentare-generală-a-procesului-de-verificare)
3. [Servicii de infrastructură](#servicii-de-infrastructură)
4. [Serviciul de Autentificare](#serviciul-de-autentificare)
5. [Serviciul de Clienți](#serviciul-de-clienți)
6. [Serviciul Web](#serviciul-web)
7. [Depanare](#depanare)
8. [Proceduri de verificare a stării](#proceduri-de-verificare-a-stării)

## Cerințe preliminare

Înainte de a începe procesul de verificare, asigurați-vă că aveți:

- Docker și Docker Compose instalate
- Acces la repository-ul BeeConect
- Variabilele de mediu necesare configurate (fișierul .env.development)
- Porturi de rețea disponibile (consultați SETUP_INSTRUCTIONS.md pentru cerințele de porturi)

## Prezentare generală a procesului de verificare

Procesul de verificare constă în:

1. Pornirea serviciilor de infrastructură
2. Verificarea fiecărui microserviciu individual
3. Testarea integrării între servicii
4. Efectuarea verificărilor de stare

Puteți utiliza comenzile din Makefile pentru a porni serviciile individual sau împreună.

## Servicii de infrastructură

### Pornirea serviciilor de infrastructură

```bash
cd beeconect-dev
make infrastructure
```

### Pași de verificare

1. **Traefik**:
   - Accesați dashboard-ul Traefik la http://localhost:8080
   - Verificați că dashboard-ul se încarcă și afișează serviciile așteptate

2. **PostgreSQL (Auth)**:
   - Conectați-vă la baza de date folosind un client PostgreSQL:
     ```
     Host: localhost
     Port: 5432
     Database: auth_db
     Username: auth_user
     Password: auth_pass_123
     ```
   - Rulați o interogare simplă pentru a verifica conectivitatea:
     ```sql
     SELECT 1;
     ```

3. **PostgreSQL (Customers)**:
   - Conectați-vă la baza de date folosind un client PostgreSQL:
     ```
     Host: localhost
     Port: 5433
     Database: customers_db
     Username: customers_user
     Password: customers_pass_123
     ```
   - Rulați o interogare simplă pentru a verifica conectivitatea:
     ```sql
     SELECT 1;
     ```

4. **Redis**:
   - Conectați-vă la Redis folosind un client Redis:
     ```
     Host: localhost
     Port: 6379
     ```
   - Rulați o comandă simplă pentru a verifica conectivitatea:
     ```
     PING
     ```
   - Ar trebui să primiți răspunsul "PONG"

5. **RabbitMQ**:
   - Accesați interfața de management RabbitMQ la http://localhost:15672
   - Autentificați-vă cu:
     ```
     Username: admin
     Password: admin
     ```
   - Verificați că dashboard-ul se încarcă și afișează exchange-urile și cozile așteptate

## Serviciul de Autentificare

### Pornirea Serviciului de Autentificare

```bash
cd beeconect-dev
make auth-service
```

### Pași de verificare

1. **Disponibilitatea serviciului**:
   - Accesați serviciul la http://localhost:8001/docs
   - Verificați că interfața Swagger UI se încarcă corect

2. **Endpoint-uri API**:
   - Testați endpoint-ul de verificare a stării:
     ```
     GET http://localhost:8001/health
     ```
     Răspuns așteptat: `{"status":"ok"}`

   - Testați înregistrarea utilizatorului:
     ```
     POST http://localhost:8001/auth/register
     Content-Type: application/json
     
     {
       "email": "test@example.com",
       "password": "Password123!",
       "full_name": "Test User"
     }
     ```
     Răspuns așteptat: Detaliile utilizatorului cu un cod de stare 201

   - Testați autentificarea utilizatorului:
     ```
     POST http://localhost:8001/auth/login
     Content-Type: application/json
     
     {
       "username": "test@example.com",
       "password": "Password123!"
     }
     ```
     Răspuns așteptat: Token de acces și token de reîmprospătare

3. **Integrarea cu baza de date**:
   - După înregistrarea unui utilizator, verificați că utilizatorul a fost adăugat în baza de date:
     ```sql
     SELECT * FROM users WHERE email = 'test@example.com';
     ```

4. **Integrarea cu Redis**:
   - După autentificare, verificați că token-ul a fost stocat în Redis:
     ```
     KEYS *
     ```

## Serviciul de Clienți

### Pornirea Serviciului de Clienți

```bash
cd beeconect-dev
make customers-service
```

### Pași de verificare

1. **Disponibilitatea serviciului**:
   - Accesați serviciul la http://localhost:8016/docs
   - Verificați că interfața Swagger UI se încarcă corect

2. **Endpoint-uri API**:
   - Testați endpoint-ul de verificare a stării:
     ```
     GET http://localhost:8016/health
     ```
     Răspuns așteptat: `{"status":"ok"}`

   - Testați crearea unui client (necesită token de autentificare de la Serviciul de Autentificare):
     ```
     POST http://localhost:8016/customers
     Authorization: Bearer <token_from_auth_service>
     Content-Type: application/json
     
     {
       "name": "Test Customer",
       "email": "customer@example.com",
       "phone": "+40123456789",
       "address": "123 Test Street"
     }
     ```
     Răspuns așteptat: Detaliile clientului cu un cod de stare 201

   - Testați obținerea clienților:
     ```
     GET http://localhost:8016/customers
     Authorization: Bearer <token_from_auth_service>
     ```
     Răspuns așteptat: Lista de clienți

3. **Integrarea cu baza de date**:
   - După crearea unui client, verificați că clientul a fost adăugat în baza de date:
     ```sql
     SELECT * FROM customers WHERE email = 'customer@example.com';
     ```

4. **Integrarea cu RabbitMQ**:
   - După crearea unui client, verificați că un mesaj a fost publicat în RabbitMQ:
     - Verificați interfața de management RabbitMQ la http://localhost:15672
     - Navigați la tab-ul "Exchanges"
     - Faceți clic pe exchange-ul "bee.customers.events"
     - Verificați că mesajele sunt publicate

## Serviciul Web

### Pornirea Serviciului Web

```bash
cd beeconect-dev
make web-service
```

### Pași de verificare

1. **Disponibilitatea serviciului**:
   - Accesați serviciul la http://localhost:3001
   - Verificați că interfața web se încarcă corect

2. **Interfața utilizator**:
   - Testați funcționalitatea de autentificare:
     - Navigați la pagina de autentificare
     - Introduceți credențialele create în timpul verificării Serviciului de Autentificare
     - Verificați că autentificarea este reușită

   - Testați funcționalitatea de gestionare a clienților:
     - Navigați la pagina de clienți
     - Verificați că clientul creat în timpul verificării Serviciului de Clienți este afișat
     - Încercați să creați un nou client și verificați că apare în listă

3. **Integrarea API**:
   - Deschideți instrumentele de dezvoltare ale browserului
   - Navigați la tab-ul Network
   - Efectuați acțiuni în interfața utilizator și verificați că sunt făcute apeluri API către Serviciul de Autentificare și Serviciul de Clienți
   - Verificați că răspunsurile sunt conform așteptărilor

## Depanare

### Probleme comune și soluții

1. **Serviciul nu pornește**:
   - Verificați log-urile Docker:
     ```bash
     docker-compose logs <service-name>
     ```
   - Verificați că toate variabilele de mediu necesare sunt setate
   - Asigurați-vă că porturile necesare sunt disponibile

2. **Probleme de conexiune la baza de date**:
   - Verificați că serviciul de bază de date rulează:
     ```bash
     docker ps | grep postgres
     ```
   - Verificați string-ul de conexiune la baza de date în variabilele de mediu ale serviciului
   - Încercați să vă conectați direct la baza de date pentru a verifica credențialele

3. **Probleme de autentificare**:
   - Verificați că Serviciul de Autentificare rulează
   - Verificați că cheia secretă JWT este consistentă între servicii
   - Verificați că token-ul este transmis corect în header-ul Authorization

4. **Probleme de conexiune RabbitMQ**:
   - Verificați că RabbitMQ rulează:
     ```bash
     docker ps | grep rabbitmq
     ```
   - Verificați string-ul de conexiune RabbitMQ în variabilele de mediu ale serviciului
   - Încercați să vă conectați direct la RabbitMQ pentru a verifica credențialele

5. **Probleme cu Serviciul Web**:
   - Verificați că Serviciul de Autentificare și Serviciul de Clienți rulează
   - Verificați URL-urile API în variabilele de mediu ale Serviciului Web
   - Ștergeți cache-ul și cookie-urile browserului

### Log-uri și depanare

Pentru a vizualiza log-urile pentru un serviciu specific:

```bash
docker-compose logs <service-name>
```

Pentru a vizualiza log-urile pentru toate serviciile:

```bash
docker-compose logs
```

Pentru a activa modul de depanare pentru un serviciu, setați variabila de mediu `DEBUG` la `true` în configurația serviciului.

## Proceduri de verificare a stării

### Verificări automate de stare

Fiecare microserviciu oferă un endpoint de verificare a stării la `/health` care returnează starea serviciului și a dependențelor sale.

Pentru a verifica starea tuturor serviciilor:

```bash
curl http://localhost:8001/health
curl http://localhost:8016/health
```

### Verificări manuale de stare

Pentru a verifica manual starea serviciilor:

1. **Verificați containerele Docker**:
   ```bash
   docker-compose ps
   ```
   Toate serviciile ar trebui să aibă starea "Up"

2. **Verificați log-urile pentru erori**:
   ```bash
   docker-compose logs | grep -i error
   ```

3. **Verificați utilizarea resurselor**:
   ```bash
   docker stats
   ```

4. **Verificați conectivitatea la rețea**:
   ```bash
   docker network inspect beeconect
   ```

### Monitorizare continuă

Pentru monitorizare continuă, puteți utiliza:

1. **Dashboard-ul Traefik** pentru a monitoriza traficul HTTP
2. **Interfața de management RabbitMQ** pentru a monitoriza mesajele
3. **Prometheus și Grafana** (dacă sunt configurate) pentru metrici detaliate

Aceste instrumente vă vor ajuta să identificați și să rezolvați rapid orice probleme care pot apărea în platforma BeeConect.