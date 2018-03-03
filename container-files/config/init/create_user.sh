#!/bin/bash
user=$USER
pwd=$PASSWORD
# crear el usuario gelmer si no especificamos en el docker run un usuario 

ret=false
getent passwd $user >/dev/null 2>&1 && ret=true

if $ret; then
echo "El usuario ya existe";
else

useradd $user -d /data/$user

# Establecer contraseña para el usuario gqr

echo "${user}:${pwd}" | chpasswd

# Añadir el user 'gqr' a usuarios  sudoers

echo "${user}  ALL=(ALL)  NOPASSWD: ALL" > /etc/sudoers.d/$user
echo "user created"
fi
