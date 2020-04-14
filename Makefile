include .env
export

include /etc/os-release
export

run: gen-cert gen-secrets
	docker-compose build
	docker-compose up -d
	sleep 5 && docker-compose up -d

debug:
	docker-compose up

clean:
	-docker-compose kill
	-docker-compose rm -f

clean-data: clean
	-docker volume rm homelab_data-mattermost
	-docker volume rm homelab_data-postgres
	-docker volume rm homelab_data-gitlab
	-docker volume rm homelab_config-gitlab
	-docker volume rm homelab_logs-gitlab

clean-all: clean-data
	-rm -f assets/global/*.crt assets/global/*.key
	-rm -rf password_files
	# -rm -rf letsencrypt/etc/letsencrypt/accounts
	# -rm -rf letsencrypt/etc/letsencrypt/archive
	# -rm -rf letsencrypt/etc/letsencrypt/csr
	# -rm -rf letsencrypt/etc/letsencrypt/keys
	# -rm -rf letsencrypt/etc/letsencrypt/live
	# -rm -rf letsencrypt/etc/letsencrypt/renewal
	# -rm -rf letsencrypt/etc/letsencrypt/renewal-hooks

gen-cert:
# If we have a letencrypt cert, add that
ifneq ("$(wildcard ./letsencrypt/etc/letsencrypt/live/${DOMAIN_NAME}/privkey.pem)","")
	cp ./letsencrypt/etc/letsencrypt/live/${DOMAIN_NAME}/privkey.pem ./assets/global/${REALM_NAME}.key
	cp ./letsencrypt/etc/letsencrypt/live/${DOMAIN_NAME}/fullchain.pem ./assets/global/${REALM_NAME}.crt
# If we dont have letsencrypt, check we already have a cert generated
else ifeq ("$(wildcard ./assets/global/${REALM_NAME}.crt)","")
	# Generate missing certificate
	openssl req \
		-nodes \
		-x509 \
		-newkey rsa:4096 \
		-keyout ./assets/global/${REALM_NAME}.key \
		-out ./assets/global/${REALM_NAME}.crt \
		-subj "/C=US/ST=VA/L=NoVA/O=${ORG_NAME}/CN=*.${DOMAIN_NAME}" \
		-days 3650
endif

# Find the local cert store so that we can add our own
ifneq ("$(wildcard /etc/ssl/certs/ca-certificates.crt)","")
	cp /etc/ssl/certs/ca-certificates.crt ./assets/global/ca-certificates.crt
else ifneq ("$(wildcard /etc/ssl/certs/ca-bundle.crt)","")
	cp /etc/ssl/certs/ca-bundle.crt ./assets/global/ca-certificates.crt
	# openssl x509 -outform der -in ./assets/global/ca-certificates.pem -out ./assets/global/ca-certificates.crt
endif
	cat ./assets/global/${REALM_NAME}.crt >> ./assets/global/ca-certificates.crt

gen-secrets:
ifeq ("$(wildcard ./password_files)","")
	mkdir password_files
	openssl rand -base64 32 > password_files/grafana_admin_password.txt
	openssl rand -base64 32 > password_files/keycloak_keycloak_password.txt
	openssl rand -base64 32 > password_files/gitlab_root_password.txt
endif

save-realm:
	docker exec -it homelab_keycloak_1 timeout 30s \
		/opt/jboss/keycloak/bin/standalone.sh \
		-Djboss.socket.binding.port-offset=100 -Dkeycloak.migration.action=export \
		-Dkeycloak.migration.provider=singleFile \
		-Dkeycloak.migration.realmName=${REALM_NAME} \
		-Dkeycloak.migration.usersExportStrategy=REALM_FILE \
		-Dkeycloak.migration.file=/tmp/realm-${REALM_NAME}.json
	docker cp homelab_keycloak_1:/tmp/realm-${REALM_NAME}.json ./assets/keycloak/realm-${REALM_NAME}.json

.PHONY: run debug clean clean-data clean-all gen-cert gen-secrets save-realm