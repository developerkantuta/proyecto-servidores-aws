# Proyecto de Servidores Frontend y Backend en AWS

Este repositorio contiene la infraestructura como código (IaC) usando **OpenTofu** para desplegar dos servidores en AWS: uno para el **Frontend** y otro para el **Backend**.

## Arquitectura

- **VPC por defecto de AWS** (para simplificar el laboratorio).
- **2 instancias EC2** (`t3.micro`, Free Tier eligible):
  - `servidor-frontend`: Expuesto a Internet (HTTP/HTTPS).
  - `servidor-backend`: Solo accesible desde el frontend (puerto 3000 y 8080).
- **2 Security Groups**:
  - `frontend-sg`: Permite HTTP/HTTPS desde Internet y SSH desde la IP del administrador.
  - `backend-sg`: Permite tráfico desde el frontend y SSH desde la IP del administrador.

## Requisitos previos

1. **OpenTofu** instalado (`tofu version`).
2. **AWS CLI** configurado con credenciales (`aws configure`).
3. **Par de claves SSH** (`lab-key.pem`) en AWS.

## Cómo usar este repositorio

### 1. Clonar el repositorio

```bash
git clone <URL_DEL_REPOSITORIO>
cd proyecto-servidores
2. Configurar las variables
Edita el archivo variables.tf y cambia el valor de my_ip por tu IP pública actual en formato CIDR (ej. 189.28.71.162/32).
3. Inicializar OpenTofu
bash
tofu init
4. Ver el plan
bash
tofu plan
5. Aplicar los cambios
bash
tofu apply
Escribe yes cuando te pregunte.

6. Destruir los recursos (importante)
Cuando termines de usar los servidores, ejecuta:

bash
tofu destroy
Escribe yes cuando te pregunte. Esto elimina todos los recursos para evitar cargos.
Estructura del proyecto
main.tf: Configuración de las instancias y Security Groups.

variables.tf: Variables configurables (región, tipo de instancia, IP del administrador).

outputs.tf: Salidas del proyecto (IPs públicas y privadas de los servidores).

.gitignore: Archivos que NO se suben a GitHub (estado de OpenTofu, credenciales, etc.).

Notas de seguridad
NO subas el archivo terraform.tfstate a GitHub. Contiene información sensible de la infraestructura. Ya está en el .gitignore.

NO subas credenciales de AWS (Access Key, Secret Key). Usa aws configure en cada máquina.

El usuario de IAM tofu-deployer tiene la política AdministratorAccess para simplificar el laboratorio. En producción, se debería usar una política más restrictiva.