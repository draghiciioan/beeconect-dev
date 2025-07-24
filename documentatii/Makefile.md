# Documentația Makefile

Acest document oferă o explicație a fișierului `Makefile` din proiectul BeeConect în trei formate diferite.

## Pentru Persoane Non-Tehnice

Fișierul `Makefile` este ca o listă de scurtături sau rețete care vă ajută să gestionați aplicația BeeConect mai ușor. În loc să trebuiască să vă amintiți și să tastați comenzi lungi și complicate, puteți utiliza cuvinte simple pentru a efectua sarcini comune.

Acest fișier include următoarele scurtături:

1. **help**: Vă arată o listă cu toate scurtăturile disponibile și ce fac acestea
2. **setup**: Pregătește calculatorul dumneavoastră pentru a rula aplicația BeeConect pentru prima dată
3. **dev**: Pornește toate părțile aplicației BeeConect și vă spune cum să le accesați
4. **infrastructure**: Pornește doar serviciile de infrastructură (baze de date, mesagerie)
5. **auth-service**: Pornește serviciul de autentificare și componentele necesare
6. **customers-service**: Pornește serviciul de clienți și componentele necesare
7. **frontend-web-service**: Pornește interfața web și serviciile de care depinde
8. **stop**: Pune în pauză aplicația BeeConect când nu o utilizați
9. **clean**: Elimină complet aplicația BeeConect și curăță orice fișiere rămase

Pentru a utiliza aceste scurtături, ați tasta `make` urmat de numele scurtăturii. De exemplu, tastând `make dev` ar porni întreaga aplicație, iar `make auth-service` ar porni doar serviciul de autentificare și componentele necesare acestuia.

## Pentru Dezvoltatori

Fișierul `Makefile` oferă o interfață standardizată pentru operațiunile comune de dezvoltare în proiectul BeeConect. Utilizează GNU Make pentru a defini ținte care simplifică operațiunile Docker și Docker Compose.

### Ținte Disponibile

1. **help**
   - Auto-documentează Makefile-ul prin parsarea comentariilor
   - Utilizează awk pentru a extrage și formata descrierile țintelor
   - Oferă o interfață CLI curată pentru dezvoltatori

2. **setup**
   - Inițializează mediul de dezvoltare
   - Creează rețeaua Docker "beeconect" dacă nu există deja
   - Suprimă erorile dacă rețeaua există deja

3. **dev**
   - Pornește toate serviciile definite în docker-compose.yml
   - Utilizează flag-ul --build pentru a asigura că imaginile sunt actualizate
   - Rulează containerele în modul detașat (-d)
   - Afișează URL-urile pentru accesarea serviciilor cheie

4. **infrastructure**
   - Pornește doar serviciile de infrastructură (traefik, postgres, redis, rabbitmq)
   - Utilizează docker-compose cu flag-ul --build și -d
   - Afișează informații despre porturile și URL-urile serviciilor
   - Util pentru dezvoltarea și testarea componentelor individuale

5. **auth-service**
   - Pornește serviciul de autentificare și dependențele sale (postgres-auth, redis, rabbitmq)
   - Utilizează docker-compose cu flag-ul --build și -d
   - Afișează URL-ul serviciului și informații despre dependențe
   - Util pentru dezvoltarea și testarea izolată a serviciului de autentificare

6. **customers-service**
   - Pornește serviciul de clienți și dependențele sale (postgres-customers, rabbitmq)
   - Utilizează docker-compose cu flag-ul --build și -d
   - Afișează URL-ul serviciului și informații despre dependențe
   - Util pentru dezvoltarea și testarea izolată a serviciului de clienți

7. **frontend-web-service**
   - Pornește interfața web și serviciile de care depinde (auth-service, customers-service)
   - Utilizează docker-compose cu flag-ul --build și -d
   - Afișează URL-ul interfeței și informații despre serviciile backend
   - Util pentru dezvoltarea și testarea interfeței utilizator

8. **stop**
   - Oprește toate containerele în execuție definite în docker-compose.yml
   - Păstrează volumele și rețelele

9. **clean**
   - Oprește toate containerele
   - Elimină volumele asociate (flag-ul -v)
   - Curăță sistemul Docker pentru a elimina resursele neutilizate
   - Util pentru resetarea completă a mediului

Toate țintele sunt marcate ca .PHONY pentru a se asigura că rulează indiferent dacă există un fișier cu același nume.

## Pentru Agenți AI

```makefile
# Fișier: Makefile
# Scop: Oferă comenzi standardizate pentru gestionarea mediului de dezvoltare BeeConect

# Declarația .PHONY asigură că aceste ținte rulează întotdeauna indiferent de existența fișierului
.PHONY: help setup dev prod stop-dev stop-prod stop clean infrastructure auth-service customers-service frontend-web-service

help: ## Arată ajutor
	# Utilizează @ pentru a suprima afișarea comenzii
	# Afișează antetul pentru comenzile disponibile
	@echo 'BeeConect Commands:'
	# Utilizează awk pentru a parsa comentariile după ## și a le formata ca text de ajutor
	# MAKEFILE_LIST este o variabilă încorporată care conține numele fișierelor Makefile
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  %-15s %s\n", $$1, $$2}' $(MAKEFILE_LIST)

setup: ## Configurează mediul de dezvoltare
	# Mesaj informativ
	@echo "Setting up BeeConect..."
	# Creează rețeaua Docker dacă nu există
	# 2>/dev/null suprimă ieșirea stderr
	# || true asigură succesul comenzii chiar dacă rețeaua există deja
	@docker network create beeconect 2>/dev/null || true
	@mkdir -p letsencrypt 2>/dev/null || true

dev: ## Pornește toate serviciile în modul dezvoltare
	# Mesaj informativ
	@echo "Starting BeeConect development environment..."
	# Pornește toate serviciile definite în docker-compose.yml cu variabilele de mediu din .env.development
	# --build asigură reconstruirea imaginilor dacă este necesar
	# -d rulează containerele în modul detașat (fundal)
	@docker-compose --env-file .env.development up --build -d
	# Afișează informații de acces pentru serviciile cheie
	@echo "Development services available:"
	@echo "  - Traefik Dashboard: http://localhost:8080"
	@echo "  - RabbitMQ Management: http://localhost:15672"
	@echo "  - Auth Service: http://localhost:8001"
	@echo "  - Customers Service: http://localhost:8016"
	@echo "  - Frontend Web Service: http://localhost:3001"

prod: ## Pornește toate serviciile în modul producție
	# Mesaj informativ
	@echo "Starting BeeConect production environment..."
	# Pornește serviciile definite în docker-compose.prod.yml cu variabilele de mediu din .env.production
	@docker-compose -f docker-compose.prod.yml --env-file .env.production up --build -d
	# Afișează informații de acces pentru serviciile cheie în producție
	@echo "Production services available at:"
	@echo "  - Auth Service: https://auth.$(shell grep DOMAIN_NAME .env.production | cut -d '=' -f2)"
	@echo "  - Traefik Dashboard: https://traefik.$(shell grep DOMAIN_NAME .env.production | cut -d '=' -f2) (protected by basic auth)"

infrastructure: ## Pornește doar serviciile de infrastructură
	# Mesaj informativ
	@echo "Starting infrastructure services..."
	# Pornește doar serviciile de infrastructură specificate
	@docker-compose --env-file .env.development up --build -d traefik postgres-auth postgres-customers redis rabbitmq
	# Afișează informații de acces pentru serviciile de infrastructură
	@echo "Infrastructure services available:"
	@echo "  - Traefik Dashboard: http://localhost:8080"
	@echo "  - RabbitMQ Management: http://localhost:15672"
	@echo "  - PostgreSQL Auth: localhost:5432"
	@echo "  - PostgreSQL Customers: localhost:5433"
	@echo "  - Redis: localhost:6379"

auth-service: ## Pornește serviciul de autentificare cu dependențele sale
	# Mesaj informativ
	@echo "Starting auth-service with dependencies..."
	# Pornește serviciul auth-service și dependențele sale
	@docker-compose --env-file .env.development up --build -d postgres-auth redis rabbitmq auth-service
	# Afișează informații de acces pentru serviciu și dependențele sale
	@echo "Auth service available at: http://localhost:8001"
	@echo "Dependencies available:"
	@echo "  - PostgreSQL Auth: localhost:5432"
	@echo "  - Redis: localhost:6379"
	@echo "  - RabbitMQ Management: http://localhost:15672"

customers-service: ## Pornește serviciul de clienți cu dependențele sale
	# Mesaj informativ
	@echo "Starting customers-service with dependencies..."
	# Pornește serviciul customers-service și dependențele sale
	@docker-compose --env-file .env.development up --build -d postgres-customers rabbitmq customers-service
	# Afișează informații de acces pentru serviciu și dependențele sale
	@echo "Customers service available at: http://localhost:8016"
	@echo "Dependencies available:"
	@echo "  - PostgreSQL Customers: localhost:5433"
	@echo "  - RabbitMQ Management: http://localhost:15672"

frontend-web-service: ## Pornește interfața web cu dependențele sale
	# Mesaj informativ
	@echo "Starting frontend-web-service with dependencies..."
	# Pornește serviciul frontend-web-service și dependențele sale
	@docker-compose --env-file .env.development up --build -d auth-service customers-service frontend-web-service
	# Afișează informații de acces pentru serviciu și dependențele sale
	@echo "Frontend web service available at: http://localhost:3001"
	@echo "Dependencies available:"
	@echo "  - Auth Service: http://localhost:8001"
	@echo "  - Customers Service: http://localhost:8016"

stop-dev: ## Oprește serviciile de dezvoltare
	# Mesaj informativ
	@echo "Stopping development services..."
	# Oprește toate containerele în execuție definite în docker-compose.yml
	@docker-compose --env-file .env.development down

stop-prod: ## Oprește serviciile de producție
	# Mesaj informativ
	@echo "Stopping production services..."
	# Oprește toate containerele în execuție definite în docker-compose.prod.yml
	@docker-compose -f docker-compose.prod.yml --env-file .env.production down

stop: ## Oprește toate serviciile (atât dezvoltare, cât și producție)
	# Mesaj informativ
	@echo "Stopping all services..."
	# Oprește serviciile de dezvoltare și producție
	@make stop-dev
	@make stop-prod

clean: ## Curăță tot
	# Mesaj informativ
	@echo "Cleaning up..."
	# Oprește toate containerele și elimină volumele (flag-ul -v)
	@docker-compose --env-file .env.development down -v
	@docker-compose -f docker-compose.prod.yml --env-file .env.production down -v
	# Elimină resursele Docker neutilizate (imagini, rețele, etc.)
	# -f forțează eliminarea fără confirmare
	@docker system prune -f
```

Observații cheie pentru procesarea AI:
1. Acest Makefile urmează sintaxa și convențiile standard GNU Make
2. Utilizează auto-documentarea prin comentarii cu un format specific (## pentru textul de ajutor)
3. Toate comenzile utilizează prefixul @ pentru a suprima afișarea comenzii pentru o ieșire mai curată
4. Gestionarea erorilor este implementată pentru comanda de creare a rețelei
5. Fișierul oferă o gestionare completă a ciclului de viață pentru mediul de dezvoltare
6. Ținta help generează dinamic documentația din Makefile-ul însuși
7. Docker și Docker Compose sunt instrumentele principale gestionate
8. Țintele urmează o progresie logică: setup → dev → stop → clean
9. Toate țintele sunt declarate ca .PHONY pentru a se asigura că se execută întotdeauna