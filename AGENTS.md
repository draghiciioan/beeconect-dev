# Ghid pentru Agenți AI - Proiectul BeeConect

Acest document servește ca ghid pentru agenții AI care lucrează cu proiectul BeeConect. Scopul său este de a oferi o înțelegere clară a arhitecturii, componentelor și fluxurilor de lucru pentru a facilita dezvoltarea, întreținerea și extinderea platformei.

## Arhitectura Generală

BeeConect este o platformă scalabilă bazată pe microservicii, cu următoarele componente principale:

1. **Entry Point**: Interfața globală BeeConect accesibilă prin aplicații web/mobile
2. **API Gateway** (Traefik): Reverse proxy care distribuie cererile către microservicii
3. **RabbitMQ Event Router**: Sistem central de mesagerie pentru comunicarea între servicii

### Diagrama Conceptuală

```
Utilizatori → BeeConect (Entry Point) → API Gateway (Traefik) → Microservicii (Nivel 1 & 2)
                                            ↑
                                      RabbitMQ Event Router
                                            ↓
                                    Comunicare între servicii
```

## Microservicii

### Nivel 1 (Core)
- **auth_service**: Autentificare, JWT, OAuth, 2FA
- **business_service**: Afaceri, puncte de lucru, abonamente
- **orders_service**: Comenzi, rezervări, statusuri
- **notifications_service**: Email/SMS, push-uri
- **payments_service**: Plăți Netopia, reconciliere
- **sorz_service**: (Verifică denumirea și funcționalitatea)

### Nivel 2 (Extensie & Scalare)
- **users_service**: Profiluri, adrese, preferințe
- **location_service**: IP2Location, geo-fencing, hartă
- **analytics_service**: Statistici, KPI-uri, heatmaps
- **event_router**: Centralizează/loghează evenimente RabbitMQ
- **search_service**: Indexare/filtrare rapidă (2 instanțe)
- **log_service**: Audit trail, observabilitate

## Instrucțiuni pentru Agenți AI

### Analiză de Cod

1. **Înțelegerea Contextului**:
   - Fiecare microserviciu are propriul repository Git
   - Comunicarea între servicii se face prin RabbitMQ (event-driven)
   - Validarea JWT este distribuită via GET /validate în auth_service

2. **Convenții de Cod**:
   - Backend: FastAPI cu SQLAlchemy + Alembic pentru ORM
   - Autentificare: JWT, OAuth2 implementate în auth_service
   - Frontend: TailwindCSS + HTMX pentru UI simplu, React pentru dashboard

3. **Analiza Dependențelor**:
   - Verifică docker-compose.yml pentru a înțelege relațiile între servicii
   - Analizează fluxurile de mesaje RabbitMQ între servicii
   - Identifică dependențele de baze de date (PostgreSQL per serviciu)

### Dezvoltare și Extindere

1. **Adăugarea de Funcționalități**:
   - Respectă arhitectura event-driven
   - Implementează noi evenimente în RabbitMQ pentru funcționalități cross-service
   - Utilizează JWT pentru autentificare între servicii

2. **Debugging**:
   - Verifică logurile containerelor Docker
   - Monitorizează mesajele RabbitMQ
   - Verifică conexiunile la bazele de date PostgreSQL

3. **Testare**:
   - Testează fiecare microserviciu izolat
   - Testează integrarea între servicii prin fluxuri de evenimente
   - Verifică validarea JWT între servicii

### Documentație

1. **Standarde**:
   - Fiecare fișier important trebuie documentat în trei formate:
     - Pentru persoane non-tehnice
     - Pentru dezvoltatori
     - Pentru agenți AI
   - Documentația se păstrează în directorul `documentatii/`

2. **Actualizare Documentație**:
   - La modificarea unui fișier, actualizează documentația corespunzătoare
   - Menține README.md actualizat cu noile funcționalități sau modificări arhitecturale
   - Documentează noile evenimente RabbitMQ și fluxurile de date

## Roluri Utilizatori și Permisiuni

Pentru a înțelege logica de business, familiarizează-te cu rolurile utilizatorilor:

1. **Client**: Vizualizare afaceri, comenzi, rezervări, recenzii, hartă, chat
2. **Administrator afacere**: Gestionare pagină, program, comenzi, statistici
3. **Livrator (freelancer)**: Acceptă/refuză livrări, chat, hartă
4. **Colaborator zonal**: Adaugă afaceri, urmărește comisioane
5. **Superadmin**: Control complet, statistici, moderare, setări globale

## Etape de Dezvoltare

Înțelege stadiul actual al proiectului conform etapelor:

1. ✅ **Etapa 1**: Creare `auth_service` - MVP complet + UI simplu + testare Docker
2. 🔜 **Etapa 2**: Creare `business_service` + legare la `auth_service` (validare token)
3. 🔜 **Etapa 3**: Adăugare RabbitMQ + `notifications_service`
4. 🔜 **Etapa 4**: Integrare plăți + dashboard UI
5. 🔜 **Etapa 5**: Consolidare cu API Gateway și CI/CD

## Recomandări pentru Agenți AI

1. **Analiza Codului**:
   - Începe cu înțelegerea structurii docker-compose.yml și Makefile
   - Analizează auth_service ca punct de referință pentru alte microservicii
   - Înțelege fluxurile de autentificare și validare JWT

2. **Sugestii de Îmbunătățire**:
   - Identifică potențiale probleme de securitate (credențiale hardcodate, etc.)
   - Sugerează optimizări pentru comunicarea între servicii
   - Propune strategii de testare și CI/CD

3. **Asistență în Dezvoltare**:
   - Ajută la implementarea noilor microservicii conform arhitecturii
   - Oferă exemple de cod pentru integrarea cu RabbitMQ
   - Sugerează structuri de date și scheme de baze de date pentru noile servicii

Acest ghid va fi actualizat pe măsură ce proiectul evoluează. Consultă-l periodic pentru informații actualizate despre arhitectură și practici recomandate.