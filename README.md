# nginx
nginx Docker image with `ping` installed

# Usage

## Server certificate

If `$GENERATE_SERVER_CERT=true`, a self-signed server certificate and private key will be generated under `$SERVER_CERT_FILE` (by default `/etc/nginx/ssl/server.crt`) and `$SERVER_CERT_KEY` (by default `/etc/nginx/ssl/server.key`), respectively. `$HOST` variable needs to be set to the hostname of the server, e.g. `localhost`.

## Upstream sever

If `$UPSTREAM_SERVER` is supplied, then the entrypoint script will ping that host for a `$TIMEOUT` number of seconds (the default is 10).
If the host responds during that period, the entrypoint command is executed. Otherwise the script exits.

# Example

    docker run \
        -e GENERATE_SERVER_CERT=true \
        -e HOST=localhost \
        -e UPSTREAM_SERVER=tomcat \
        atomgraph/nginx
