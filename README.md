# Homelab

## Assumptions:
### DNS
DNS for hosts needs to resolve the domain name and the following subdomain names to the system you plan to run this on.
* sso.
* chat.
* grafana.

### Certificates
Envoy enforces certificates be in place and each service using Keycloak then requires that certificate to be trusted.
* You can use `make gen-certs` but `make run` will run this automatically if it detects you don't have local certs
* Current assumption is that your host ca-cet store is located at `/etc/ssl/certs/ca-certificates.crt`

## Prerequisites 
* Docker
* Docker Compose
* make
* openssl

## Running
* Create your .env file
* If you are doing let's encrypt: `set -o allexport; source .env; set +o allexport; ./letsencryp.sh`
* `make run`

## Clean up
* `make clean`: cleans up docker containers
* `make clean-data`: everything in clean + remove docker volumes
* `make clean-all`: everything in clean-data + removes certificates + removes password_files

## Descriptions
* `assets`: files needed in support of an application that is not a core configuration file
* `configs`: files that provide core configuration for a service
* `context`: docker build contexts used for building container images if not pulling directly from a registry
* `password_files`: get generated and contains the passwords generated for service accounts

## Know Issues
* Certificate helpers will not work with MacOS because docker on Mac uses `docker-machine`.

## .env structure
```
# Required
DOMAIN_NAME=
REALM_NAME=
ORG_NAME=

# Optional: to use letsencrypt dns-route53
AWS_ACCESS_KEY_ID=
AWS_SECRET_ACCESS_KEY=
AWS_DEFAULT_REGION=
```
