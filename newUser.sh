#!/bin/bash
USER=$1
DOMAIN=$2

# opened with root access?
if [ "$(id -u)" -ne 0 ]; then
    echo "Script must be run with sudo" >&2
    exit 1
fi

# adding a new user
if id "$USER" >/dev/null 2>&1; then
    echo "User already exists, domain will be added to their account"
else
    PASSWORD=$(openssl rand -base64 32 | tr -d '/+' | head -c 16)
    echo "$USER's random password is: $PASSWORD (saved into /home/ubuntu/passwords/${USER}Password)"
    touch /home/ubuntu/passwords/${USER}Password
    echo "$PASSWORD" > "/home/ubuntu/passwords/${USER}Password"
    useradd -m -d "/home/$USER" -s /bin/bash -e 0 "$USER"
    
    echo "$USER:$PASSWORD" | chpasswd
fi

if [ -d "/var/www/html/$USER" ]; then
    :
else
    mkdir -p "/var/www/html/$USER/"
fi

if [ -d "/var/www/html/$USER/$DOMAIN" ]; then
    echo "Domain already exists in the current context, exiting!"
    exit 1
else
    mkdir -p "/var/www/html/$USER/$DOMAIN/"
fi

cp /var/www/html/index.html "/var/www/html/$USER/$DOMAIN/index.html"


# adding new server block into nginx config
ssl_certificate="/etc/letsencrypt/live/olda.ssibrno.cz/fullchain.pem"
ssl_certificate_key="/etc/letsencrypt/live/olda.ssibrno.cz/privkey.pem"
root_directory="/var/www/html/$USER/$DOMAIN"

sed -i '/^http {/a \
\
\tserver {\
\t\tlisten 80;\
\t\tserver_name '"$DOMAIN"';\
\t\tlocation / {\
\t\t\treturn 301 https://$host$request_uri;\
\t\t}\
\t}\
\tserver {\
\t\tlisten 443 ssl;\
\t\tserver_name '"$DOMAIN"';\
\t\tssl_certificate '"$ssl_certificate"';\
\t\tssl_certificate_key '"$ssl_certificate_key"';\
\t\troot '"$root_directory"';\
\
\t\tindex index.html;\
\
\t\tlocation / {\
\t\t\ttry_files $uri $uri/ /index.html;\
\t\t}\
\t}' /etc/nginx/nginx.conf

nginx -t
service nginx restart

# setting up ssh connection to the new user

mkdir -p "/home/${USER}/.ssh/"
ssh-keygen -t rsa -b 4096 -f "/home/$USER/.ssh/${USER}_key"
cp "/home/${USER}/.ssh/${USER}_key.pub" "/home/${USER}/.ssh/authorized_keys"
chmod 600 "/home/${USER}/.ssh/authorized_keys"
chown ${USER} "/home/${USER}/.ssh/authorized_keys"
cp "/home/${USER}/.ssh/${USER}_key.pub" "/home/ubuntu/passwords/${USER}_key.pub"
cp "/home/${USER}/.ssh/${USER}_key.pub" "/home/ubuntu/passwords/${USER}_key"

if [ -d "/home/$USER/html" ]; then
    :
else
    mkdir -p "/home/$USER/html/"
    ln -s "/var/www/html/$USER" "/home/$USER/html"
fi


