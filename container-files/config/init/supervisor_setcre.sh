
#!/bin/bash
# Establecemos Usuario y contraseña para el Supervisord

if [ -z "${USER}" ]
then
echo "Supervisor user is default (gelmer)"
else
sed -ri "s/gelmer/${USER}/g" /etc/supervisord.conf
fi


if [ -z "${PASSWORD}" ]
then
echo "Supervisor password is default (gqr)"
else
sed -ri "s/gqr/${PASSWORD}/g" /etc/supervisord.conf
fi
