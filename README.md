# nginx
nginx Docker image with `ping` installed

# Usage

## Server certificate

If `$GENERATE_SERVER_CERT=true`, a self-signed server certificate and private key will be generated under `$SERVER_CERT_FILE` (by default `/etc/nginx/ssl/server.crt`) and `$SERVER_KEY_FILE` (by default `/etc/nginx/ssl/server.key`), respectively. `$HOST` variable needs to be set to the hostname of the server, e.g. `localhost`.
The certificate can be mounted by mounting the container's `$SERVER_CERT_MOUNT` folder (by default `/etc/nginx/ssl/public`).

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
          - HOST=localhost
          - UPSTREAM_SERVER=tomcat
        command: nginx -g 'daemon off;'
        volumes:
          - ./certs:/etc/nginx/ssl/public