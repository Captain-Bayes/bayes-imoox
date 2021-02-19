Server Deployment
=================

To deploy, you need
- A reverse proxy
- Docker to run the container running PlutoBindServer.jl and the notebooks

## Reverse Proxy configuration
Setup nginx as a reverse proxy, forwarding to the docker container.
```Nginx
server {
    server_name bayes-pluto.HOST.TLD;

    proxy_set_header X-Forwarded-For $remote_addr;

    proxy_cache one;  # Update, to match global cache configuration

    location / {
         proxy_pass         http://127.0.0.1:8123;
         proxy_set_header   Host $host;
         proxy_set_header   X-Real-IP $remote_addr;
         proxy_set_header   X-Forwarded-For $proxy_add_x_forwarded_for;
         proxy_set_header   X-Forwarded-Host $server_name;
         proxy_read_timeout  30s;

         access_log      /var/log/nginx/bayes.access.log;
         error_log       /var/log/nginx/bayes.error.log;
    }
    
    listen 443 ssl; # SSL is required for CORS
    ssl_certificate ...;
    ssl_certificate_key ...;
    include ...;
    ssl_dhparam ...;
}
```

To improve server performance, nginx can cache responses. The cache configuration must be done in the http context.
```Nginx
http {
    include       mime.types;
    default_type  application/octet-stream;

    # ...

    gzip  on;
    charset utf-8;

    proxy_cache_path /var/cache/nginx levels=1:2 keys_zone=one:10m max_size=1G;
    
    # ...

    include sites-enabled/*.conf;
}
```

## Docker configuration
Running the docker container is straightforward. Here, the docker container exposes the internal port (1234) on 8123.
```shell
docker run -dp 8123:1234 ghcr.io/captain-bayes/pluto-server:latest
```

Automatically updating and restarting the docker container may be done with [watchtower].
```shell
docker run -d --name watchtower -v /var/run/docker.sock:/var/run/docker.sock containrrr/watchtower --interval 300 --cleanup
```

[watchtower]: https://github.com/containrrr/watchtower