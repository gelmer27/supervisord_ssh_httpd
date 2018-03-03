FROM centos
MAINTAINER Gelmer Quiroz <gelmerqr@gmail.com>

#Instalar dependencias y actualizar
RUN \
  yum update -y && \
  yum install -y epel-release && \
  yum install -y iproute python-setuptools hostname inotify-tools yum-utils which jq && \
  yum clean all && \
  easy_install supervisor

# Actualizar el sistema
# Instalamos programas basicos como el tar,wget, etc.
RUN \ 
yum update -y && \ 
yum install -y wget patch tar bzip2 unzip openssh-clients MariaDB-client

# -- Instalar Apache
RUN \
 yum install -y httpd && \
 systemctl enable httpd

# -- Instalar OpenSSH server
RUN \
  yum install -y openssh-server pwgen sudo vim mc links

# Genera las claves para SSH 
RUN ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -N '' \
&& ssh-keygen -t dsa  -f /etc/ssh/ssh_host_dsa_key -N '' \
&& ssh-keygen -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key -N '' \
&& chmod 600 /etc/ssh/*

# - Configuramos SSH daemon...
RUN \
  sed -i -r 's/.?UseDNS\syes/UseDNS no/' /etc/ssh/sshd_config && \
  sed -i -r 's/.?PasswordAuthentication.+/PasswordAuthentication yes/' /etc/ssh/sshd_config && \
  sed -i -r 's/.?ChallengeResponseAuthentication.+/ChallengeResponseAuthentication no/' /etc/ssh/sshd_config && \
  sed -i -r 's/.?PermitRootLogin.+/PermitRootLogin no/' /etc/ssh/sshd_config

# - Añadimos configuracion de archivos clave
RUN \
  sed -ri 's/^HostKey\ \/etc\/ssh\/ssh_host_ed25519_key/#HostKey\ \/etc\/ssh\/ssh_host_ed25519_key/g' /etc/ssh/sshd_config && \
  sed -ri 's/^#HostKey\ \/etc\/ssh\/ssh_host_dsa_key/HostKey\ \/etc\/ssh\/ssh_host_dsa_key/g' /etc/ssh/sshd_config && \
  sed -ri 's/^#HostKey\ \/etc\/ssh\/ssh_host_rsa_key/HostKey\ \/etc\/ssh\/ssh_host_rsa_key/g' /etc/ssh/sshd_config && \
  sed -ri 's/^#HostKey\ \/etc\/ssh\/ssh_host_ecdsa_key/HostKey\ \/etc\/ssh\/ssh_host_ecdsa_key/g' /etc/ssh/sshd_config && \
  sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config

# Deshabilitar la comprobación de clave de host estricta SSH: necesaria para acceder a git a través de SSH en modo no interactivo

RUN \
  echo -e "StrictHostKeyChecking no" >> /etc/ssh/ssh_config

# - Eliminar 'Defaults secure_path' de / etc / sudoers que anula la ruta cuando se usa el comando 'sudo'.

RUN \
  sed -i '/secure_path/d' /etc/sudoers

# - Eliminar la advertencia sobre la configuración regional faltante al iniciar sesión a través de ssh

RUN \
  echo > /etc/sysconfig/i18n

RUN \
  yum clean all && rm -rf /tmp/yum*

# -Definimos el usuario y contraseña por defecto

ENV USER=gelmer
ENV PASSWORD=gqr

ADD container-files /
RUN \
   sed -ri "s/gelmer/${USER}/g" /etc/supervisord.conf && \
   sed -ri "s/gqr/${PASSWORD}/g" /etc/supervisord.conf

VOLUME ["/data"]
EXPOSE 22 9001 80

ENTRYPOINT ["/config/bootstrap.sh"]
