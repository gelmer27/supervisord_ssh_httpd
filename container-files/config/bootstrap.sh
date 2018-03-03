#!/bin/bash
set -e
set -u

# parámetros por defecto de Supervisord
SUPERVISOR_PARAMS='-c /etc/supervisord.conf'


# crear directorios para los registros y el zócalo UNIX del supervisor (que pueden faltar)

mkdir -p /data/conf /data/run /data/logs

# como contenedor podría comenzar con / data montado desde otro contenedor de datos).

chmod 711 /data/conf /data/run /data/logs

if [ "$(ls /config/init/)" ]; then
  for init in /config/init/*.sh; do
    . $init
  done
fi


# Tenemos TTY, por lo que probablemente sea un contenedor interactivo ....

if test -t 0; then
  # Ejecutar Supervisord

  supervisord $SUPERVISOR_PARAMS
  
  if [[ $@ ]]; then 
    eval $@
  else 
    export PS1='[\u@\h : \w]\$ '
    /bin/bash
  fi

else
  if [[ $@ ]]; then 
    eval $@
  fi
  supervisord -n $SUPERVISOR_PARAMS
fi
