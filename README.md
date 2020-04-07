# Homelab

## Assumptions:
### DNS
DNS for hosts needs to resolve the domain name and the following subdomain names to the system you plan to run this on.
* sso.
* chat.
* grafana.

### Certificates
Envoy enforces certificates be in place and each service using Keycloak then requires that certificate to be trusted.
Included in the repo is the cert and private key being used for TLS but also a ca-certificate with public CAs with 
repo one appended.

## Prerequisites 
* Docker
* Docker Compose
* make

## Running
* `docker-compose up -d`

## Descriptions
* `assets`: files needed in support of an application that is not a core configuration file
* `configs`: files that provide core configuration for a service
* `context`: docker build contexts used for building container images if not pulling directly from a registry
* `.env`: environment file with environment specific details