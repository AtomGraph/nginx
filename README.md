# nginx
nginx Docker image with `ping` installed

# Usage

If environmental variable `$UPSTREAM_SERVER` is supplied, then the entrypoint script will ping that host for a `$TIMEOUT` number of seconds (the default is 10).

If the host responds during that period, the entrypoint command is executed. Otherwise the script exits.