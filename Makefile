.PHONY: save-realm

save-realm:
	docker exec -it homelab_keycloak_1 /opt/jboss/keycloak/bin/standalone.sh \
		-Djboss.socket.binding.port-offset=100 -Dkeycloak.migration.action=export \
		-Dkeycloak.migration.provider=singleFile \
		-Dkeycloak.migration.realmName=mikemay-io \
		-Dkeycloak.migration.usersExportStrategy=REALM_FILE \
		-Dkeycloak.migration.file=/tmp/realm-mikemay-io.json \
		&& exit
	docker cp homelab_keycloak_1:/tmp/realm-mikemay-io.json ./assets/keycloak/realm-mikemay-io.json