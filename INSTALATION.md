# Installation Guide
---

### 1. Pre-requisites

Ensure the following requirements are met before starting the installation process:

1. **Run with Root Privileges**:
   - Use `sudo` or switch to the root user if not already running with root privileges:
     ```bash
     sudo su
     ```

2. **Certificates and Keys**:
   - Make sure the necessary certificates and keys are placed in their respective paths:

   **FreeRADIUS Certificates**:
   - `/root/wba-openroaming-connector/certs/freeradius/cert.pem`: FreeRADIUS certificate.
   - `/root/wba-openroaming-connector/certs/freeradius/chain.pem`: FreeRADIUS chain file.
   - `/root/wba-openroaming-connector/certs/freeradius/privkey.pem`: FreeRADIUS private key.

#### Note:
Failing to provide these files in the correct locations will cause the installation process to halt.

---

### 2. Run the `deploy.sh` Script

After meeting the requirements, execute the **`deploy.sh`** script to perform configuration and installation tasks.

---

### 3. Verify Docker Containers

Once the setup is complete, verify that all expected services are running using `docker ps`.

#### Command:
```bash
docker ps
```

#### Example Output:
```plaintext
CONTAINER ID   IMAGE                 COMMAND                  STATUS         PORTS                                         NAMES
642d2a23f456   idp-freeradius        "/docker-entrypoint.…"   Up 5 minutes   1812-1813/udp                                hybrid-freeradius-1
4cc3b65c2a51   mysql:8.0             "docker-entrypoint.s…"   Up 5 minutes   0.0.0.0:3306->3306/tcp                       hybrid-mysql_freeradius-1
```

---

#### Key Points to Verify:

- **Port Mapping**: Verify the following ports:
   - UDP ports `1812-1813` for FreeRADIUS.
   - MySQL port `3306` for database access.

- **Status**: Confirm all containers display **Up** in the status field.

---

### 4. Open UFW ports

After verifying everything is running correctly:
- Validate that relevant ports are open. Use the following command to allow required ports via UFW:
  ```bash
  for port in 1812/udp 1813/udp; do sudo ufw allow $port; done
  ```

---
