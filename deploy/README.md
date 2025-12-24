# 🚀 Deployment Guide

This folder contains everything needed to run Diplomacy on your Ubuntu VPS.

## 1. Prerequisites on VPS
Install Docker and Nginx:
```bash
sudo apt update
sudo apt install docker.io docker-compose-plugin nginx -y
```

## 2. Setup Files
Copy the project to your VPS (e.g., using `git clone`).
Navigate to the `deploy` directory:
```bash
cd diplomacy-simulation/deploy
cp .env.example .env
```
Edit `.env` and set your password, host, and generate a secret:
```bash
# To generate a secret key base:
docker compose run --rm web mix phx.gen.secret
```

## 3. Run the Application
```bash
docker compose -f docker-compose.prod.yml up -d
```

## 4. Configure Nginx
```bash
sudo cp nginx.conf /etc/nginx/sites-available/diplomacy
sudo ln -s /etc/nginx/sites-available/diplomacy /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl restart nginx
```

## 5. SSL (Recommended)
Use Certbot to get a free SSL certificate:
```bash
sudo apt install certbot python3-certbot-nginx -y
sudo certbot --nginx -d yourdomain.com
```

## 6. Maintenance
To see logs: `docker compose -f docker-compose.prod.yml logs -f`
To restart: `docker compose -f docker-compose.prod.yml restart`
