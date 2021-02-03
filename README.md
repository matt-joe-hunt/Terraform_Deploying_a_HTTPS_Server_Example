# Instructions

## Deploying Infrastructure

Ensure you have Terraform install on your system

In your terminal run the following commands:

```
export ENV=dev
terraform init --backend-config=configuration/$ENV.conf
terraform workspace select $ENV || terraform workspace new $ENV
terraform apply
```
Then via your AWS console you will be able to connect to the instance using the Session Manager.  Find your instance in the console and select it with the toggle, then click the 'Connect' button at the top of the screen.

Here you will have 3 options to use to connect to your instance, use the middle option 'Session Manager', and if all has gone well you should be able to connect  to your instance using the connect button in the bottom left of the screen.

## Installing and setting up an HTTPS server

Follow the instructions below, in order, without missing a step. Please check the final line of console output for each command you have ran to ensure it has worked as expected.

### Installing Nginx

```
sudo su

cd ~

amazon-linux-extras enable nginx1

yum clean metadata

yum -y install nginx
```

These steps should be quite straight forward, you are first assuming a role with elevated permissions and then running a few commands to install the Nginx tool, these steps are quite specfic to the AWS AMI defined in the Terraform deployment so would work out of the box with any Linux Distribution.

### Setting up the nginx.conf

```
vim nginx.conf

```
You will be creating a file in the home directory of your current user to copy into another location, if you are not familiar with using *vim* you can use another editor. 

Paste in the content of the nginx.conf file defined in this project, you might want to use the mouse to right click and select paste depending upon how comfortable you are with *vim*.

To save the file and leave the editor, hit *esc* and then type *:wq*.

```
cp -rf nginx.conf /etc/nginx/nginx.conf
```
Here we are copying the file we have just created into the correct location in the nginx directory for the nginx server to use, you may need to approve this *cp* command as it will overwrite an existing file, do this by typing *y*.

## Creating a Certificate Authority (CA)

In order to allow

```
openssl req -new -newkey rsa:4096 -days 365 -nodes -x509 -subj "/C=UK/ST=_/L=_/O=_/CN=example" -keyout ca.key -out ca.crt
```

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
