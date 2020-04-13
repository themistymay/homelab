set -o allexport; source .env; set +o allexport;
docker run -it --rm --name certbot \
  -v "$PWD/letsencrypt/etc/letsencrypt:/etc/letsencrypt" \
  -v "$PWD/letsencrypt/var/lib:/var/lib/letsencrypt" \
  -v "$PWD/letsencrypt/logs:/tmp/logs" \
  -e "AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID" \
  -e "AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY" \
  -e "AWS_DEFAULT_REGION=$AWS_DEFAULT_REGION" \
  --user $(id -u):$(id -g) \
  certbot/dns-route53 certonly -n --logs-dir /tmp/logs --agree-tos