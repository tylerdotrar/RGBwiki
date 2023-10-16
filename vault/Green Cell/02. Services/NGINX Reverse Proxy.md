
>[!info]
>This is directly from ChatGPT so be warned.

To configure NGINX as a reverse proxy to redirect to your internal services while utilizing HTTPS on port 443, you can follow these steps. Assuming you already have NGINX installed, here's a basic configuration example for your use case:

1. **Create SSL Certificates:** You'll need SSL/TLS certificates for your domain (e.g., `homelab`) and each internal service you want to proxy. You can obtain free certificates from Let's Encrypt using Certbot.

2. **Configure NGINX:** Create a configuration file for NGINX that defines your reverse proxy settings. You can use the default NGINX configuration file located at `/etc/nginx/nginx.conf` or create a new one in `/etc/nginx/sites-available/`.

- Here's an example configuration file (`/etc/nginx/sites-available/reverse-proxy`):

```nginx
server {
    listen 443 ssl;
    server_name proxmox.homelab;

    ssl_certificate /etc/nginx/ssl/homelab.crt;
    ssl_certificate_key /etc/nginx/ssl/homelab.key;

    location / {
        proxy_pass https://proxmox.homelab:8006;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}

server {
    listen 443 ssl;
    server_name opnsense.homelab;

    ssl_certificate /etc/nginx/ssl/homelab.crt;
    ssl_certificate_key /etc/nginx/ssl/homelab.key;

    location / {
        proxy_pass https://opnsense.homelab:443;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}

# Repeat the above server block for other services like wikijs and pihole.

server {
    listen 443 ssl default_server;
    server_name _;

    ssl_certificate /etc/nginx/ssl/homelab.crt;
    ssl_certificate_key /etc/nginx/ssl/homelab.key;

    return 404;
}
```

- In this example, replace `homelab.crt` and `homelab.key` with the actual paths to your SSL certificate and private key files. Also, make sure to add similar server blocks for your other services (`wikijs.homelab` and `pihole.homelab`) with the corresponding `proxy_pass` values.

3. **Create Symbolic Links:** Create symbolic links to your configuration file in the `/etc/nginx/sites-enabled/` directory:

```shell
sudo ln -s /etc/nginx/sites-available/reverse-proxy /etc/nginx/sites-enabled/
```

4. **Test Configuration:** Check the NGINX configuration for syntax errors:

```shell
sudo nginx -t
```

- If there are no errors, reload NGINX to apply the changes:

```shell
sudo systemctl reload nginx
```

5. **DNS Configuration:** Ensure that DNS records for `proxmox.homelab`, `opnsense.homelab`, `wikijs.homelab`, and `pihole.homelab` all point to the public IP address of your NGINX server.

6. **Firewall Rules:** Make sure your firewall allows incoming traffic on port 443.

Now, you should be able to access all your internal services through a single reverse proxy using HTTPS on port 443. Remember to renew your SSL certificates when needed and adjust the NGINX configuration if you add more services.
