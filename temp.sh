sudo su

cd ~

amazon-linux-extras enable nginx1

yum clean metadata

yum -y install nginx

unalias cp

## COPY OVER nginx.conf

cp -rf nginx.conf /etc/nginx/nginx.conf

## OPENSSL

openssl req -new -newkey rsa:4096 -days 365 -nodes -x509 -subj "/C=UK/ST=_/L=_/O=_/CN=example" -keyout ca.key -out ca.crt

## SERVER

openssl req -new -newkey rsa:4096 -days 365 -nodes -x509 -subj "/C=UK/ST=_/L=_/O=_/CN=example" -keyout server.key

openssl req -new -key server.key -out server.csr -subj "/C=UK/ST=_/L=_/O=_/OU=_/CN=example"

openssl x509 -req -days 365 -in server.csr -CA ca.crt -CAkey ca.key -set_serial 01 -out server.crt

# USER

openssl req -new -newkey rsa:4096 -days 365 -nodes -x509 -subj "/C=UK/ST=_/L=_/O=_/CN=example" -keyout user.key

openssl req -new -key user.key -out user.csr -subj "/C=UK/ST=_/L=_/O=_/OU=_/CN=example"

openssl x509 -req -days 365 -in user.csr -CA ca.crt -CAkey ca.key -set_serial 01 -out user.crt

# Moving certs to correct location

mkdir /etc/nginx/certs

mkdir /etc/nginx/certs/private

cp server.crt /etc/nginx/certs/server.crt

cp server.key /etc/nginx/certs/private/server.key

cp ca.crt /etc/nginx/certs/private/ca.crt

nginx

nginx -s reload


# TEST

curl -k -v https://localhost:443

curl -k -v http://localhost:80

curl -k -v --key ./user.key --cert ./user.crt https://localhost:443

curl -k -v --key ./server.key --cert ./server.crt https://localhost:443


openssl req -new -newkey rsa:4096 -days 365 -nodes -x509 -subj "/C=UK/ST=_/L=_/O=_/CN=example" -keyout ca1.key -out ca1.crt

openssl req -new -newkey rsa:4096 -days 365 -nodes -x509 -subj "/C=UK/ST=_/L=_/O=_/CN=example" -keyout user1.key

openssl req -new -key user1.key -out user1.csr -subj "/C=UK/ST=_/L=_/O=_/OU=_/CN=example"

openssl x509 -req -days 365 -in user1.csr -CA ca1.crt -CAkey ca1.key -set_serial 01 -out user1.crt

curl -k -v --key ./user1.key --cert ./user1.crt https://localhost:443
