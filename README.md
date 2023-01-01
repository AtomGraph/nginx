# nginx
Unprivileged nginx Docker image that can generate a self-signed server certificate.

# Usage

## Server certificate

If `$GENERATE_SERVER_CERT=true` and `$SERVER_NAME` is set (to the hostname of the server, e.g. `localhost`), a self-signed server certificate and private key will be generated under `$SERVER_CERT_FILE` (by default `/etc/nginx/ssl/server.crt`) and `$SERVER_KEY_FILE` (by default `/etc/nginx/ssl/server.key`), respectively.

## Upstream sever

If `$UPSTREAM_SERVER` is supplied, then the entrypoint script will ping that host for a `$TIMEOUT` number of seconds (the default is 10).

If the host responds during that period, the entrypoint command is executed. Otherwise the script exits.

# Example

Using `docker-compose.yml`:

    version: "2.3"
    services:
      nginx:
        image: atomgraph/nginx
        environment:
          - GENERATE_SERVER_CERT=true
          - SERVER_NAME=localhost
          - UPSTREAM_SERVER=tomcat
        command: nginx -g 'daemon off;'
        volumes:
          - ./certs:/etc/nginx/ssl