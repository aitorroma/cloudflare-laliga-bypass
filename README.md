<div align="center">

![[image-20210506104427925](https://t.me/aitorroma)](https://tva1.sinaimg.cn/large/008i3skNgy1gq8sv4q7cqj303k03kweo.jpg)


[![ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/J3J64AN17)

  
  <br>

  <a href="https://t.me/aitorroma">
    <img src="https://img.shields.io/badge/Telegram-informational?style=for-the-badge&logo=telegram&logoColor=white" alt="Telegram Badge"/>
  </a>
</div>
</div>


# Monitor de Estado de Cloudflare para Bloqueos de LaLiga

Este proyecto proporciona una automatización para gestionar los bloqueos de Cloudflare durante las transmisiones de partidos de fútbol de LaLiga. El sistema monitorea automáticamente el estado de tu sitio web y gestiona la activación/desactivación de Cloudflare según sea necesario.

## Contexto

En España, los proveedores de servicios de Internet (ISPs) como Telefónica y O2 están implementando bloqueos a Cloudflare como medida para combatir la transmisión ilegal de contenido deportivo, especialmente durante los partidos de fútbol. Sin embargo, esta medida está teniendo efectos colaterales no deseados:

- Afecta a sitios web legítimos de comercio electrónico
- Impacta a webs corporativas y blogs personales
- Interrumpe servicios que no tienen relación alguna con la piratería

Esta situación ha creado la necesidad de desarrollar soluciones que permitan a los sitios web legítimos mantener su servicio activo durante los períodos de bloqueo.

## Funcionamiento

- **Monitoreo Continuo**: El script monitorea check.aitorroma.com para verificar si Cloudflare está activo.
- **Detección de Bloqueos**: Cuando LaLiga implementa bloqueos durante partidos de fútbol, el sistema lo detecta automáticamente.
- **Gestión Automática**: 
  - Desactiva automáticamente Cloudflare cuando se detectan bloqueos
  - Reactiva Cloudflare cuando el sitio vuelve a estar disponible
- **Notificaciones**: Utiliza webhooks para mantener informado sobre los cambios de estado

## Beneficios

- Minimiza el tiempo de inactividad durante las transmisiones de fútbol
- Elimina la necesidad de gestionar manualmente los bloqueos de Cloudflare
- Proporciona una solución automatizada para mantener el servicio disponible
- Asegura la continuidad del servicio para sitios web legítimos

## Requisitos

- Python 3.x
- uv (gestor de paquetes, recomendado)

### Instalación de Python

#### Windows
1. Visita [Python.org](https://www.python.org/downloads/windows/)
2. Descarga la última versión de Python 3.x (64-bit)
3. Ejecuta el instalador
4. **¡IMPORTANTE!** Marca la casilla "Add Python to PATH" durante la instalación
5. Haz clic en "Install Now"

#### macOS
1. Visita [Python.org](https://www.python.org/downloads/macos/)
2. Descarga la última versión de Python 3.x
3. Ejecuta el instalador .pkg
4. Sigue las instrucciones del instalador

#### Linux
La mayoría de distribuciones Linux ya incluyen Python. Si no está instalado:

**Ubuntu/Debian:**
```bash
sudo apt update
sudo apt install python3 python3-pip
```

**Fedora:**
```bash
sudo dnf install python3 python3-pip
```

**Arch Linux:**
```bash
sudo pacman -S python python-pip
```

## Requisitos de Implementación

### Ubicación del Monitoreo

- El script debe ejecutarse desde un proveedor de Internet afectado por los bloqueos (como Telefónica u O2)
- La web de monitoreo (check.aitorroma.com) se mantiene siempre activa con Cloudflare
- Este diseño permite detectar de forma fiable cuando los bloqueos están activos en tu red

### Configuración de n8n

- El servidor de n8n NO debe estar detrás de Cloudflare
- Esto es crucial para que pueda recibir y procesar las notificaciones incluso durante los bloqueos
- Se recomienda hospedar n8n en un servidor con acceso directo a Internet

### Diagrama de Funcionamiento

```
[Script Monitor] ---(ISP bloqueado)---> [check.aitorroma.com] ---(Cloudflare siempre activo)
       |
       |--(Notificación)---> [n8n Server] ---(Sin Cloudflare)---> [Gestión de Cloudflare]
```

## Configuración

1. Crea un archivo `config.ini` en el mismo directorio que el script con el siguiente contenido:
```ini
[DEFAULT]
webhook = TU_URL_WEBHOOK
domain = TU_DOMINIO
```

## Configuración del Workflow en n8n

### Importar el Workflow

1. En tu instancia de n8n, ve al menú lateral y haz clic en "Workflows"
2. Haz clic en el botón "Import from File"
3. Navega hasta el directorio `n8n-workflow` de este proyecto
4. Selecciona el archivo del workflow y haz clic en "Import"

### Configurar Credenciales de Cloudflare

1. Una vez importado el workflow, haz clic en el nodo de Configuración
2. En la pestaña de configuración del nodo, verás dos campos importantes:
   - **Email Address**: Introduce el correo electrónico asociado a tu cuenta de Cloudflare
   - **Global API Key**: Introduce tu Global API Key de Cloudflare

Para obtener tu Global API Key:
1. Inicia sesión en [Cloudflare](https://dash.cloudflare.com)
2. Ve a "Mi Perfil" (icono de usuario en la esquina superior derecha)
3. Navega a la sección "API Tokens"
4. Desplázate hasta encontrar "Global API Key"
5. Haz clic en "Ver" y copia la clave

### Activar el Workflow

1. Una vez configuradas las credenciales, haz clic en el botón "Save" para guardar los cambios
2. Activa el workflow usando el switch "Active" en la parte superior derecha
3. Haz clic en "Save" nuevamente para guardar el workflow completo
4. Abre el nodo webhook y copia la URL de producción en config.ini

## Instalación de Dependencias

### Linux y macOS

```bash
# Instalar uv si no está instalado
pip install uv

# Instalar dependencias
uv pip install -r requirements.txt
```

### Windows

Ejecuta el archivo `build.bat` que instalará automáticamente uv si no está presente y todas las dependencias necesarias.

## Ejecución

### Linux y macOS

```bash
# Ejecutar directamente con Python
python cloudflare.py

# O usando uv
uv run python cloudflare.py
```

### Windows

Tienes dos opciones:

1. Ejecutar directamente con Python (igual que en Linux/macOS)
2. Usar el ejecutable compilado (cloudflare.exe) que se encuentra en la carpeta `dist` después de ejecutar `build.bat`

## Compilar Ejecutable (Windows)

1. Ejecuta `build.bat`
2. El ejecutable se creará en la carpeta `dist`

Si recibes advertencias del antivirus, puedes:
1. Añadir una exclusión en Windows Defender para la carpeta `dist` o el archivo `cloudflare.exe`
2. Usar el comando alternativo que se muestra al final de la ejecución de `build.bat`

## Notas

- El script requiere conexión a Internet para funcionar
- Asegúrate de tener los permisos necesarios para escribir en el directorio donde se ejecuta el script
- En caso de problemas con el ejecutable en Windows, intenta ejecutar el script directamente con Python
