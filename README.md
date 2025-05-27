# Keycloak-LDAP-Docker

This project sets up a Keycloak instance integrated with OpenLDAP for user federation, using Docker Compose. It includes PostgreSQL as the database for Keycloak and Nginx as a reverse proxy.

## Prerequisites

- Docker and Docker Compose installed on your machine
- OpenSSL (for generating SSL certificates, if needed)

## Project Structure

```
.
├── docker-compose.yml
├── .env
├── nginx/
│   ├── conf.d/
│   │   └── default.conf
│   └── ssl/
│       ├── server.crt
│       └── server.key
├── backup/
│   ├── ldap/
│   └── postgres/
└── backup.sh
```

## Configuration

### Environment Variables

Create a `.env` file in the project root with the following variables:

```
# LDAP Configuration
LDAP_ADMIN_USERNAME=admin
LDAP_ADMIN_PASSWORD=change_me_secure_password
LDAP_USERS=keycloak,testuser
LDAP_USER_PASSWORDS=change_me_keycloak_pass,change_me_test_pass
LDAP_ROOT=dc=example,dc=org
LDAP_ORGANISATION=Example Org

# Keycloak Configuration
KEYCLOAK_ADMIN=admin
KEYCLOAK_ADMIN_PASSWORD=change_me_secure_password
KC_DB=postgres
KC_DB_URL=jdbc:postgresql://postgres:5432/keycloak
KC_DB_USERNAME=keycloak
KC_DB_PASSWORD=change_me_secure_password
KC_HOSTNAME=localhost

# PostgreSQL Configuration
POSTGRES_DB=keycloak
POSTGRES_USER=keycloak
POSTGRES_PASSWORD=change_me_secure_password

# Resource Limits (optional)
LDAP_MEMORY_LIMIT=512M
KEYCLOAK_MEMORY_LIMIT=1G
POSTGRES_MEMORY_LIMIT=1G
```

### SSL Certificates

For development, you can generate self-signed SSL certificates:

```bash
mkdir -p nginx/ssl
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout nginx/ssl/server.key -out nginx/ssl/server.crt -subj "/CN=localhost"
```

## Usage

1. **Start the Services:**

   ```bash
   docker-compose up -d
   ```

2. **Access Keycloak:**

   - Open your browser and navigate to `http://localhost:8080/auth` (or `https://localhost` if SSL is configured).

3. **Backup Data:**

   - Run the backup script to backup PostgreSQL and LDAP data:

     ```bash
     ./backup.sh
     ```

## Services

- **OpenLDAP:** LDAP server for user federation.
- **Keycloak:** Identity and Access Management server.
- **PostgreSQL:** Database for Keycloak.
- **Nginx:** Reverse proxy for Keycloak.

## Health Checks

Health checks are configured for all services to ensure they are running properly.

## Resource Limits

Resource limits are set for each service to prevent overuse of system resources.

## Backup Strategy

The `backup.sh` script is provided to backup both PostgreSQL and LDAP data. It keeps the last 7 days of backups.

## SSL/TLS Support

SSL/TLS is configured for secure communication. For production, replace the self-signed certificates with valid ones.

## Contributing

Feel free to submit issues and pull requests.

## License

This project is licensed under the MIT License. 