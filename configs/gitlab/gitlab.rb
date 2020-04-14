# external_url 'https://gitlab.mikemay.io/'
gitlab_rails['initial_root_password'] = File.read('/run/secrets/gitlab_root_password')

# disable some built-in services
letsencrypt['enable'] = false
grafana['enable'] = false
prometheus['enable'] = false
postgresql['enable'] = false

# external database
gitlab_rails['db_adapter'] = 'postgresql'
gitlab_rails['db_encoding'] = 'utf8'
gitlab_rails['db_host'] = 'postgres'
gitlab_rails['db_port'] = 5432
gitlab_rails['db_username'] = 'gitlab'
gitlab_rails['db_password'] = 'gitlab'

# external metrics
gitlab_exporter['listen_address'] = '0.0.0.0'
sidekiq['listen_address'] = '0.0.0.0'
gitlab_exporter['listen_port'] = '9168'
node_exporter['listen_address'] = '0.0.0.0:9100'
redis_exporter['listen_address'] = '0.0.0.0:9121'
postgres_exporter['listen_address'] = '0.0.0.0:9187'
gitaly['prometheus_listen_addr'] = "0.0.0.0:9236"
gitlab_workhorse['prometheus_listen_addr'] = "0.0.0.0:9229"
gitlab_rails['monitoring_whitelist'] = ['127.0.0.0/8', '172.0.0.0/8']

nginx['status']['options'] = {
  "server_tokens" => "off",
  "access_log" => "off",
  "allow" => "172.18.0.0/16",
  "deny" => "all",
}

# project feature defaults
gitlab_rails['gitlab_default_projects_features_issues'] = true
gitlab_rails['gitlab_default_projects_features_merge_requests'] = true
gitlab_rails['gitlab_default_projects_features_wiki'] = true
gitlab_rails['gitlab_default_projects_features_snippets'] = true
gitlab_rails['gitlab_default_projects_features_builds'] = true
gitlab_rails['gitlab_default_projects_features_container_registry'] = true

# lfs
gitlab_rails['lfs_enabled'] = true
gitlab_rails['lfs_storage_path'] = "/var/opt/gitlab/gitlab-rails/shared/lfs-objects"

# mattermost
gitlab_rails['mattermost_host'] = "https://chat.mikemay.io"

# authentication
gitlab_rails['omniauth_enabled'] = true
gitlab_rails['omniauth_allow_single_sign_on'] = ['openid_connect']
gitlab_rails['omniauth_auto_link_ldap_user'] = true
gitlab_rails['omniauth_block_auto_created_users'] = false
gitlab_rails['omniauth_providers'] = 
[
  { 
    'name' => 'openid_connect',
    'label' => 'Keycloak',
    'icon' => '',
    'args' => {
      'name' => 'openid_connect',
      'scope' => ['openid','profile'],
      'response_type' => 'code',
      'issuer' => 'https://sso.mikemay.io/auth/realms/mikemay-io',
      'discovery' => true,
      'client_auth_method' => 'query',
      'uid_field' => 'sub',
      'send_scope_to_token_endpoint' => 'false',
      'client_options' => {
        'identifier' => 'gitlab',
        'secret' => 'ef99eed1-215d-49c2-869e-a240a842be54',
        'redirect_uri' => 'https://gitlab.mikemay.io/users/auth/openid_connect/callback'
      }
    }
  }
]