# Laravel TTS - Configuração Docker

Guia completo para rodar a aplicação Laravel TTS em containers Docker.

## 📋 Pré-requisitos

- Docker e Docker Compose instalados
  - Windows: [Docker Desktop](https://www.docker.com/products/docker-desktop)
  - macOS: [Docker Desktop](https://www.docker.com/products/docker-desktop)
  - Linux: [Docker Engine](https://docs.docker.com/engine/install/) + [Docker Compose](https://docs.docker.com/compose/install/)

## 🚀 Início Rápido

### 1. Clone ou prepare o projeto

```bash
cd laravel-tts
```

### 2. Crie o arquivo .env

```bash
# Copie o arquivo de exemplo
copy .env.docker .env
```

**Windows (PowerShell)**:
```powershell
Copy-Item .env.docker .env
```

### 3. Gere a APP_KEY

```bash
docker-compose run --rm app php artisan key:generate
```

### 4. Inicie os containers

```bash
docker-compose up -d
```

### 5. Execute as migrações

```bash
docker-compose exec app php artisan migrate
```

### 6. Crie um link simbólico para o storage

```bash
docker-compose exec app php artisan storage:link
```

## 🌐 Acessar a Aplicação

- **URL da Aplicação**: http://localhost
- **Mailhog** (testes de email): http://localhost:8025

## 📊 Banco de Dados

### Conectar ao MySQL

```bash
# Usando Docker
docker-compose exec mysql mysql -u laravel_user -p laravel_tts

# Ou usando ferramenta gráfica (ex: MySQL Workbench, DBeaver)
# Host: localhost
# Porta: 3306
# Usuário: laravel_user
# Senha: laravel_password
# Banco: laravel_tts
```

### Fazer backup do banco

```bash
docker-compose exec mysql mysqldump -u laravel_user -p laravel_tts > backup.sql
```

## 🔧 Comandos Úteis

### Logs da Aplicação

```bash
# Todos os logs
docker-compose logs -f

# Logs específicos
docker-compose logs -f app
docker-compose logs -f nginx
docker-compose logs -f mysql
```

### Executar Comandos Artisan

```bash
# Sintaxe geral
docker-compose exec app php artisan [comando]

# Exemplos
docker-compose exec app php artisan tinker
docker-compose exec app php artisan queue:listen
docker-compose exec app php artisan test
```

### Instalar Pacotes

```bash
# PHP (Composer)
docker-compose exec app composer require package/name

# Node.js (NPM)
docker-compose exec app npm install package-name
```

### Parar e Remover Containers

```bash
# Parar
docker-compose stop

# Parar e remover
docker-compose down

# Remover tudo incluindo volumes
docker-compose down -v
```

### Acessar o Container

```bash
# Bash
docker-compose exec app bash

# PHP CLI
docker-compose exec app php
```

## 🔐 Segurança em Produção

Antes de fazer deploy em produção:

1. **Altere as senhas padrão** no `docker-compose.yml`:
   - `MYSQL_ROOT_PASSWORD`
   - `MYSQL_PASSWORD`
   - `DB_PASSWORD`

2. **Configure o APP_KEY** com um valor seguro

3. **Defina APP_DEBUG=false**

4. **Configure SSL/TLS** no Nginx (veja comentários em `docker/nginx/conf.d/app.conf`)

5. **Use variáveis de ambiente** em produção em vez de .env

6. **Configure backup automático** do banco de dados

## 📦 Estrutura de Serviços

| Serviço | Imagem | Porta | Descrição |
|---------|--------|-------|-----------|
| app | php:8.2-fpm | 9000 | Aplicação Laravel (PHP-FPM) |
| nginx | nginx:alpine | 80, 443 | Servidor web reverso |
| mysql | mysql:8.0 | 3306 | Banco de dados |
| redis | redis:7-alpine | 6379 | Cache e sessões |
| mailhog | mailhog/mailhog | 1025, 8025 | Teste de emails (dev) |

## 🐛 Troubleshooting

### Porta já em uso

```bash
# Windows
netstat -ano | findstr :80
taskkill /PID [PID] /F

# macOS/Linux
lsof -i :80
kill -9 [PID]
```

### Permissões de arquivo

```bash
docker-compose exec app chown -R www-data:www-data /var/www/html/storage
docker-compose exec app chmod -R 775 /var/www/html/storage
```

### Limpar volumes

```bash
docker-compose down -v
docker-compose up -d
```

### Conexão ao banco de dados recusada

```bash
# Verificar se o MySQL está rodando
docker-compose ps

# Verificar logs do MySQL
docker-compose logs mysql

# Reiniciar MySQL
docker-compose restart mysql
```

## 📝 Notas Adicionais

- Os volumes estão configurados para desenvolvimento. Para produção, revise a estratégia.
- A aplicação está configurada para usar Redis para cache, sessões e fila.
- Email está configurado para usar Mailhog em desenvolvimento.
- Configure variáveis de ambiente específicas em `.env` para seu ambiente.

## 🆘 Suporte

Para mais informações:
- [Documentação Laravel](https://laravel.com/docs)
- [Documentação Docker](https://docs.docker.com)
- [Docker Compose Reference](https://docs.docker.com/compose/compose-file)
