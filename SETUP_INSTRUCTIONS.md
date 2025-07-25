# Instrucțiuni de Configurare a Microserviciilor BeeConect

## Prezentare generală

Acest document explică modul în care toate microserviciile au fost conectate în mediul beeconect-dev, permițându-vă să le rulați dintr-o locație centrală. Următoarele microservicii sunt acum integrate:

1. **Serviciul de Autentificare** (bee_auth_services)
2. **Serviciul de Clienți** (bee_customers_service)
3. **Serviciul Web** (bee_web_service)

## Modificări efectuate

Următoarele modificări au fost făcute pentru a conecta toate microserviciile:

1. **Actualizarea docker-compose.yml**:
   - Adăugarea definițiilor de servicii pentru customers-service și web-service
   - Adăugarea unei baze de date PostgreSQL pentru serviciul de clienți
   - Configurarea setărilor de rețea pentru toate serviciile
   - Configurarea mapărilor de volume pentru bazele de date
   - Configurarea variabilelor de mediu pentru toate serviciile

2. **Crearea Dockerfile pentru Serviciul Web**:
   - Configurarea unui proces de build în mai multe etape
   - Prima etapă construiește aplicația React
   - A doua etapă servește aplicația construită folosind Nginx

3. **Actualizarea .env.development**:
   - Adăugarea variabilelor de mediu pentru serviciul de clienți
   - Adăugarea variabilelor de mediu pentru serviciul web
   - Actualizarea setărilor CORS pentru a include URL-urile tuturor serviciilor

4. **Actualizarea Makefile**:
   - Adăugarea informațiilor despre noile servicii în mesajele de output

## Cum să utilizați

### Pornirea tuturor serviciilor

#### Pentru Linux/macOS

Pentru a porni toate serviciile în modul de dezvoltare, rulați:

```bash
cd beeconect-dev
make dev
```

#### Pentru Windows

Pentru a porni toate serviciile în modul de dezvoltare, rulați:

```
cd beeconect-dev
dev.bat
```

Aceasta va porni toate serviciile și va afișa URL-urile pentru accesarea lor:
- Dashboard Traefik: http://localhost:8080
- Management RabbitMQ: http://localhost:15672
- Serviciul de Autentificare: http://localhost:8001
- Serviciul de Clienți: http://localhost:8016
- Serviciul Web: http://localhost:3001

### Oprirea tuturor serviciilor

#### Pentru Linux/macOS

Pentru a opri toate serviciile, rulați:

```bash
cd beeconect-dev
make stop-dev
```

#### Pentru Windows

Pentru a opri toate serviciile, rulați:

```
cd beeconect-dev
stop.bat
```

### Curățare

#### Pentru Linux/macOS

Pentru a curăța toate containerele și volumele, rulați:

```bash
cd beeconect-dev
make clean
```

#### Pentru Windows

Pentru a curăța toate containerele și volumele, rulați:

```
cd beeconect-dev
clean.bat
```

## URL-uri și porturi de servicii

| Serviciu | URL | Port intern | Port extern |
|---------|-----|---------------|--------------|
| Serviciul de Autentificare | http://localhost:8001 | 8000 | 8001 |
| Serviciul de Clienți | http://localhost:8016 | 8007 | 8016 |
| Serviciul Web | http://localhost:3001 | 80 | 3001 |
| Dashboard Traefik | http://localhost:8080 | 8080 | 8080 |
| Management RabbitMQ | http://localhost:15672 | 15672 | 15672 |
| PostgreSQL Auth | localhost:5432 | 5432 | 5432 |
| PostgreSQL Customers | localhost:5433 | 5432 | 5433 |
| Redis | localhost:6379 | 6379 | 6379 |
| RabbitMQ | localhost:5672 | 5672 | 5672 |

## Depanare

Dacă întâmpinați probleme:

1. Verificați că Docker rulează
2. Asigurați-vă că toate porturile sunt disponibile (nu sunt utilizate de alte aplicații)
3. Verificați log-urile pentru fiecare serviciu:
   ```bash
   docker-compose logs auth-service
   docker-compose logs customers-service
   docker-compose logs web-service
   ```
4. Dacă apar probleme de conexiune la baza de date, este posibil să fie nevoie să așteptați câteva secunde pentru ca bazele de date să se inițializeze

## Pași următori

Pe măsură ce sunt dezvoltate mai multe microservicii, acestea pot fi adăugate în fișierul docker-compose.yml urmând același model:

1. Adăugați un serviciu de bază de date dacă este necesar
2. Adăugați microserviciul cu variabilele de mediu corespunzătoare
3. Actualizați fișierul .env.development cu orice variabile de mediu noi
4. Actualizați Makefile pentru a include informații despre noul serviciu
5. Pentru suport Windows, creați sau actualizați fișierele batch corespunzătoare

### Notă pentru dezvoltatorii Windows

Fișierele batch (.bat) oferă aceeași funcționalitate ca și comenzile make pentru utilizatorii Windows. Când adăugați un nou microserviciu sau modificați configurația existentă, asigurați-vă că actualizați atât Makefile-ul cât și fișierele batch corespunzătoare pentru a menține compatibilitatea între platforme.