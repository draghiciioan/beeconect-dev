# Documentația Configurației Docker Compose

Acest document oferă o explicație a fișierului `docker-compose.yml` din proiectul BeeConect în trei formate diferite.

## Pentru Persoane Non-Tehnice

Fișierul `docker-compose.yml` este ca o rețetă care spune calculatorului cum să configureze și să ruleze toate părțile diferite ale aplicației BeeConect. Gândiți-vă la el ca la un plan pentru un mic oraș unde fiecare clădire (numită "serviciu") are un scop specific și trebuie să comunice cu alte clădiri.

Acest plan definește:
- O rețea numită "beeconect" care permite tuturor serviciilor să comunice între ele
- Spații de stocare (numite "volume") care păstrează date importante în siguranță chiar și atunci când aplicația este oprită
- Cinci clădiri principale (servicii):
  1. **Traefik**: Poarta de intrare a orașului care direcționează vizitatorii către clădirile potrivite
  2. **Postgres-Auth**: Un dulap de fișiere securizat care stochează conturi de utilizator și informații de autentificare
  3. **Redis**: Un bloc-notes super-rapid pentru informații temporare
  4. **RabbitMQ**: Un oficiu poștal care livrează mesaje între diferite clădiri
  5. **Auth-Service**: Biroul de securitate care gestionează autentificările utilizatorilor și permisiunile

Fiecare dintre aceste servicii este configurat cu setări specifice, cum ar fi ce uși (porturi) sunt deschise vizitatorilor, ce informații au nevoie pentru a porni și de care alte servicii depind.

## Pentru Dezvoltatori

Fișierul `docker-compose.yml` definește un mediu Docker multi-container pentru arhitectura de microservicii BeeConect. Utilizează formatul Docker Compose versiunea 3.8 și stabilește următoarele componente:

### Configurația Rețelei
- Creează o rețea bridge numită "beeconect" pentru comunicarea între servicii

### Volume Persistente
- `postgres_auth_data`: Pentru persistența bazei de date PostgreSQL
- `redis_data`: Pentru persistența datelor Redis
- `rabbitmq_data`: Pentru persistența cozii de mesaje RabbitMQ

### Servicii

1. **Traefik (v3.0)**
   - Funcționează ca un proxy invers și echilibrator de încărcare
   - Expune porturile 80 (HTTP) și 8080 (Dashboard)
   - Configurat cu provider Docker și acces API nesecurizat
   - Montează socket-ul Docker pentru descoperirea containerelor

2. **Postgres-Auth (PostgreSQL 15 Alpine)**
   - Serviciu de bază de date pentru autentificare
   - Configurat cu numele bazei de date "auth_db", utilizator "auth_user" și parola "auth_pass_123"
   - Expune portul 5432
   - Utilizează volum persistent pentru stocarea datelor

3. **Redis (v7 Alpine)**
   - Stocare de structuri de date în memorie
   - Expune portul 6379
   - Utilizează volum persistent pentru persistența datelor

4. **RabbitMQ (v3 cu Plugin de Management)**
   - Serviciu de broker de mesaje
   - Configurat cu utilizator/parolă admin
   - Expune porturile 15672 (UI Management) și 5672 (AMQP)
   - Utilizează volum persistent pentru datele cozii

5. **Auth-Service**
   - Microserviciu personalizat de autentificare
   - Construit din Dockerfile în "../microservicii/bee_auth_services"
   - Expune portul 8001 (mapat la 8000 intern)
   - Configurat cu variabile de mediu pentru conexiuni la baza de date, coada de mesaje și cache
   - Dependențe definite pentru serviciile postgres-auth, redis și rabbitmq

## Pentru Agenți AI

```yaml
# Fișier: docker-compose.yml
# Scop: Definește infrastructura containerizată pentru aplicația de microservicii BeeConect
# Versiune: 3.8 (specificație Docker Compose)

# Configurația Rețelei
# Creează o rețea bridge pentru comunicarea între containere
networks:
  beeconect:
    driver: bridge  # Driver standard de rețea bridge pentru dezvoltare locală

# Volume de Stocare Persistente
# Aceste volume persistă datele dincolo de ciclul de viață al containerului
volumes:
  postgres_auth_data:  # Stochează baza de date de autentificare PostgreSQL
  redis_data:          # Stochează datele cache Redis
  rabbitmq_data:       # Stochează datele cozii de mesaje RabbitMQ

# Definițiile Serviciilor
services:
  # Traefik - Gateway API și Load Balancer
  traefik:
    image: traefik:v3.0  # Utilizează Traefik v3.0 ca proxy invers
    command:
      - "--api.insecure=true"  # Activează accesul API nesecurizat (nu este recomandat pentru producție)
      - "--providers.docker=true"  # Activează provider-ul Docker pentru descoperirea serviciilor
      - "--providers.docker.exposedbydefault=false"  # Serviciile trebuie să opteze pentru a fi expuse
      - "--entrypoints.web.address=:80"  # Definește punctul de intrare HTTP pe portul 80
    ports:
      - "80:80"      # Mapare port HTTP
      - "8080:8080"  # Mapare port Dashboard
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock:ro  # Socket Docker pentru descoperirea containerelor (doar citire)
    networks:
      - beeconect  # Atașat la rețeaua beeconect

  # Bază de Date PostgreSQL pentru Serviciul de Autentificare
  postgres-auth:
    image: postgres:15-alpine  # Utilizează PostgreSQL 15 Alpine (ușor)
    environment:
      POSTGRES_DB: auth_db  # Numele bazei de date
      POSTGRES_USER: auth_user  # Utilizatorul bazei de date
      POSTGRES_PASSWORD: auth_pass_123  # Parola bazei de date (ar trebui să utilizeze secrete în producție)
    volumes:
      - postgres_auth_data:/var/lib/postgresql/data  # Stocare persistentă pentru baza de date
    ports:
      - "5432:5432"  # Mapare port PostgreSQL
    networks:
      - beeconect  # Atașat la rețeaua beeconect

  # Serviciu Cache Redis
  redis:
    image: redis:7-alpine  # Utilizează Redis 7 Alpine (ușor)
    volumes:
      - redis_data:/data  # Stocare persistentă pentru datele Redis
    ports:
      - "6379:6379"  # Mapare port Redis
    networks:
      - beeconect  # Atașat la rețeaua beeconect

  # Broker de Mesaje RabbitMQ
  rabbitmq:
    image: rabbitmq:3-management-alpine  # Utilizează RabbitMQ 3 cu plugin de management
    environment:
      RABBITMQ_DEFAULT_USER: admin  # Utilizator implicit (ar trebui să utilizeze secrete în producție)
      RABBITMQ_DEFAULT_PASS: admin  # Parolă implicită (ar trebui să utilizeze secrete în producție)
    ports:
      - "15672:15672"  # Mapare port UI Management
      - "5672:5672"    # Mapare port AMQP
    volumes:
      - rabbitmq_data:/var/lib/rabbitmq  # Stocare persistentă pentru datele RabbitMQ
    networks:
      - beeconect  # Atașat la rețeaua beeconect

  # Microserviciu de Autentificare
  auth-service:
    build:
      context: ../microservicii/bee_auth_services  # Calea contextului de build
      dockerfile: Dockerfile  # Dockerfile-ul de utilizat
    ports:
      - "8001:8000"  # Mapare port serviciu (extern:intern)
    environment:
      - DATABASE_URL=postgresql://auth_user:auth_pass_123@postgres-auth:5432/auth_db  # String de conexiune PostgreSQL
      - RABBITMQ_URL=amqp://admin:admin@rabbitmq:5672/  # String de conexiune RabbitMQ
      - REDIS_URL=redis://redis:6379  # String de conexiune Redis
    networks:
      - beeconect  # Atașat la rețeaua beeconect
    depends_on:  # Dependențe serviciu
      - postgres-auth  # Necesită baza de date PostgreSQL
      - redis  # Necesită cache-ul Redis
      - rabbitmq  # Necesită broker-ul de mesaje RabbitMQ
```

Observații cheie pentru procesarea AI:
1. Aceasta este o configurație de mediu de dezvoltare (setări nesecurizate, porturi expuse)
2. Arhitectura urmează un model de microservicii cu depozite de date separate
3. Autentificarea este centralizată într-un serviciu dedicat
4. Descoperirea serviciilor este gestionată de Traefik
5. Toate serviciile partajează aceeași rețea pentru comunicare
6. Credențialele sunt hardcodate (neadecvat pentru producție)
7. Serviciul auth-service este construit dintr-un Dockerfile într-o cale relativă în afara directorului curent
8. Sunt utilizate porturi standard pentru toate serviciile
9. Dependențele sunt definite explicit pentru serviciul auth-service