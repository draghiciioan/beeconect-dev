# Docker Desktop Setup for BeeConect

This document provides instructions for setting up Docker Desktop on Windows, which is required to run the BeeConect project.

## Issue Description

The error message:
```
unable to get image 'rabbitmq:3-management-alpine': error during connect: Get "http://%2F%2F.%2Fpipe%2FdockerDesktopLinuxEngine/v1.51/images/rabbitmq:3-management-alpine/json": open //./pipe/dockerDesktopLinuxEngine: The system cannot find the file specified.
```

This error indicates that Docker Desktop is either:
1. Not installed on your system
2. Not running
3. Not properly configured

## Solution

### 1. Check if Docker Desktop is Installed

1. Look for Docker Desktop in your Start menu or installed applications.
2. If not installed, download and install Docker Desktop from the official website:
   - Visit [Docker Desktop for Windows](https://www.docker.com/products/docker-desktop/)
   - Click "Download for Windows"
   - Follow the installation instructions

### 2. If Docker Desktop is Installed but Not Running

1. Start Docker Desktop from the Start menu or desktop shortcut
2. Wait for Docker Desktop to fully initialize (the Docker icon in the system tray should stop animating)
3. You may need to accept the Docker Desktop license agreement if this is the first time running it

### 3. Verify Docker Desktop is Running Properly

Open PowerShell or Command Prompt and run:
```
docker info
```

If Docker is running correctly, you should see system information about your Docker installation.

### 4. Troubleshooting Docker Desktop Issues

If Docker Desktop is installed but still not working:

1. **Restart Docker Desktop**:
   - Right-click the Docker icon in the system tray
   - Select "Restart"

2. **Check Windows Subsystem for Linux (WSL) Requirements**:
   - Docker Desktop requires WSL 2 on Windows
   - Open PowerShell as Administrator and run:
     ```
     wsl --status
     ```
   - If WSL is not installed or needs updating, run:
     ```
     wsl --install
     ```
   - You may need to restart your computer after installing WSL

3. **Check Virtualization Settings**:
   - Docker requires hardware virtualization to be enabled in BIOS/UEFI
   - Open Task Manager (Ctrl+Shift+Esc) and go to the Performance tab
   - Under CPU, check if "Virtualization" is enabled
   - If not, you'll need to enable virtualization in your BIOS/UEFI settings

4. **Reset Docker Desktop to Factory Defaults**:
   - Open Docker Desktop settings
   - Go to "Troubleshoot" section
   - Click "Reset to factory defaults"
   - This will reset Docker Desktop but won't affect your containers or images

## Running BeeConect After Docker Desktop is Working

Once Docker Desktop is properly installed and running:

1. Open PowerShell or Command Prompt
2. Navigate to the BeeConect project directory:
   ```
   cd C:\Users\jhony\Desktop\BeeConect\beeconect-dev
   ```
3. Start the development environment using the Makefile:
   ```
   make dev
   ```
   Or directly with Docker Compose:
   ```
   docker-compose --env-file .env.development up --build -d
   ```

## Additional Resources

- [Docker Desktop for Windows Documentation](https://docs.docker.com/desktop/install/windows-install/)
- [Troubleshooting Docker Desktop on Windows](https://docs.docker.com/desktop/troubleshoot/overview/)
- [Windows Subsystem for Linux Documentation](https://learn.microsoft.com/en-us/windows/wsl/install)