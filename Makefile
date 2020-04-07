.PHONY: save-realm

clean:
	-docker-compose kill
	-docker-compose rm -f
	-docker volume rm homelab_data-mattermost
	-docker volume rm homelab_data-postgres

save-realm:
	docker exec -it homelab_keycloak_1 timeout 30s \
		/opt/jboss/keycloak/bin/standalone.sh \
		-Djboss.socket.binding.port-offset=100 -Dkeycloak.migration.action=export \
		-Dkeycloak.migration.provider=singleFile \
		-Dkeycloak.migration.realmName=mikemay-io \
		-Dkeycloak.migration.usersExportStrategy=REALM_FILE \
		-Dkeycloak.migration.file=/tmp/realm-mikemay-io.json
	docker cp homelab_keycloak_1:/tmp/realm-mikemay-io.json ./assets/keycloak/realm-mikemay-io.json