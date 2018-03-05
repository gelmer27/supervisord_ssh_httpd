# supervisord_ssh_httpd

- Es necesario mapear los siguientes puertos:
  80 > Apache
  9001 > Supervisord
  2222 > SSH
  
- Para poder creer la imagen utilizaremos este comando:
  docker build -t supervisord_ssh_httpd .

- Para descargar esta imagen "supervisord_ssh_httpd"
  docker pull gelmer27/supervisord_ssh_httpd
  
- Una vez descargado la imagen, Crearemos el contenedor abriendo los puertos necesasrios y definiendo un nombre de usuario y contraseña     para los servicios de ssh, apache, supervisord.
- Ejemplo del docker run: 
  docker run -it -d -p 80:80 -p 9001:9001 -p 2222:22 -e USER=gelmer27 -e PASSWORD=gelmer27  supervisord_ssh_httpd
