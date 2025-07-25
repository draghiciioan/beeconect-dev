# Configurarea Docker Desktop pentru BeeConect

Acest document oferă instrucțiuni pentru configurarea Docker Desktop pe Windows, care este necesar pentru a rula proiectul BeeConect.

## Descrierea problemei

Mesajul de eroare:
```
unable to get image 'rabbitmq:3-management-alpine': error during connect: Get "http://%2F%2F.%2Fpipe%2FdockerDesktopLinuxEngine/v1.51/images/rabbitmq:3-management-alpine/json": open //./pipe/dockerDesktopLinuxEngine: The system cannot find the file specified.
```

Această eroare indică faptul că Docker Desktop este fie:
1. Neinstalat pe sistemul dumneavoastră
2. Nu rulează
3. Nu este configurat corespunzător

## Soluție

### 1. Verificați dacă Docker Desktop este instalat

1. Căutați Docker Desktop în meniul Start sau în aplicațiile instalate.
2. Dacă nu este instalat, descărcați și instalați Docker Desktop de pe site-ul oficial:
   - Vizitați [Docker Desktop pentru Windows](https://www.docker.com/products/docker-desktop/)
   - Faceți clic pe "Download for Windows"
   - Urmați instrucțiunile de instalare

### 2. Dacă Docker Desktop este instalat, dar nu rulează

1. Porniți Docker Desktop din meniul Start sau de pe shortcut-ul de pe desktop
2. Așteptați ca Docker Desktop să se inițializeze complet (iconița Docker din system tray ar trebui să nu mai fie animată)
3. Este posibil să fie necesar să acceptați acordul de licență Docker Desktop dacă este prima dată când îl rulați

### 3. Verificați dacă Docker Desktop rulează corect

Deschideți PowerShell sau Command Prompt și rulați:
```
docker info
```

Dacă Docker rulează corect, ar trebui să vedeți informații despre instalarea Docker.

### 4. Depanarea problemelor Docker Desktop

Dacă Docker Desktop este instalat, dar tot nu funcționează:

1. **Reporniți Docker Desktop**:
   - Faceți clic dreapta pe iconița Docker din system tray
   - Selectați "Restart"

2. **Verificați cerințele Windows Subsystem for Linux (WSL)**:
   - Docker Desktop necesită WSL 2 pe Windows
   - Deschideți PowerShell ca Administrator și rulați:
     ```
     wsl --status
     ```
   - Dacă WSL nu este instalat sau trebuie actualizat, rulați:
     ```
     wsl --install
     ```
   - Este posibil să fie nevoie să reporniți computerul după instalarea WSL

3. **Verificați setările de virtualizare**:
   - Docker necesită ca virtualizarea hardware să fie activată în BIOS/UEFI
   - Deschideți Task Manager (Ctrl+Shift+Esc) și accesați tab-ul Performance
   - La CPU, verificați dacă "Virtualization" este activată
   - Dacă nu, va trebui să activați virtualizarea în setările BIOS/UEFI

4. **Resetați Docker Desktop la setările din fabrică**:
   - Deschideți setările Docker Desktop
   - Accesați secțiunea "Troubleshoot"
   - Faceți clic pe "Reset to factory defaults"
   - Aceasta va reseta Docker Desktop, dar nu va afecta containerele sau imaginile dumneavoastră

## Rularea BeeConect după ce Docker Desktop funcționează

Odată ce Docker Desktop este instalat și rulează corect:

1. Deschideți PowerShell sau Command Prompt
2. Navigați la directorul proiectului BeeConect:
   ```
   cd C:\Users\jhony\Desktop\BeeConect\beeconect-dev
   ```
3. Porniți mediul de dezvoltare folosind Makefile:
   ```
   make dev
   ```
   Sau direct cu Docker Compose:
   ```
   docker-compose --env-file .env.development up --build -d
   ```

## Resurse suplimentare

- [Documentația Docker Desktop pentru Windows](https://docs.docker.com/desktop/install/windows-install/)
- [Depanarea Docker Desktop pe Windows](https://docs.docker.com/desktop/troubleshoot/overview/)
- [Documentația Windows Subsystem for Linux](https://learn.microsoft.com/en-us/windows/wsl/install)