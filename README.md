# WAF Intelligence Lab 🛡️

    A comprehensive environment for testing, replaying, and auditing ModSecurity WAF rules against vulnerable applications.

## Overview
This laboratory environment enables security engineers to:
1.  **Deploy** a protective layer using Nginx with ModSecurity and OWASP Core Rule Set (CRS).
2.  **Monitor** a vulnerable target application (OWASP Juice Shop).
3.  **Automate** common attack vectors (SQLi, XSS, Path Traversal, Command Injection).
4.  **Analyze** WAF hits through structured log parsing and automated report generation.


## Architecture
- **Web Application Firewall**: Nginx with `owasp/modsecurity-crs`
- **Vulnerable Target**: `bkimminich/juice-shop`
- **Automation Engine**: PowerShell-based Replay & Reporting tool


## Getting Started

### Prerequisites
- [Docker & Docker Compose](https://docs.docker.com/get-docker/)
- PowerShell (Windows) or PowerShell Core (Linux/macOS)

### 1. Start the Environment
Run the following command in the root directory:
```bash
docker-compose up -d
```
The Nginx proxy will be available at `http://localhost:8080`.

### 2. Run Attack Replay & Analysis
Execute the automation script to simulate attacks and generate a security report:
```powershell
.\replay_and_report.ps1
```


## Project Structure
- `docker-compose.yml`: Defines the WAF and Juice Shop services.
- `nginx.conf`: Nginx configuration for the reverse proxy.
- `modsec.conf`: Custom ModSecurity configurations (log formats, engine status).
- `replay_and_report.ps1`: PowerShell script that replays attacks and parses JSON logs into Markdown.
- `attack_report.md`: (Generated) A structured analysis of blocked/detected threats.


## Sample Attacks Covered
- **SQL Injection**: Searching for products using tautologies (`' OR 1=1--`).
- **Cross-Site Scripting (XSS)**: Injecting `<script>` tags into search queries.
- **Path Traversal**: Attempting to access sensitive system files like `/etc/passwd`.
- **Command Injection**: Appending OS commands to application parameters.


## Reporting
The audit script extracts the following data from ModSecurity logs:
- **Status Code**: The HTTP response (e.g., `403 Forbidden`).
- **URI**: The targeted endpoint.
- **Rule ID**: The specific OWASP CRS rule that was triggered.
- **Message**: Description of the detected threat.
- **Matched Data**: The specific payload fragment that triggered the WAF.


## License
MIT
