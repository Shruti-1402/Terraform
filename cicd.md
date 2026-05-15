# Task 4 – CI/CD Pipeline

# Overview

A GitHub Actions CI/CD pipeline was implemented for automated build, test, and deployment workflows.

The pipeline supports secure deployments for multiple engineering teams while maintaining deployment isolation.

---

# Pipeline Features

The pipeline performs:

1. Automatic trigger on push to main branch
2. Docker image build
3. Containerized application testing
4. Deployment to EC2 using SSH
5. Secure secret management using GitHub Secrets

---

# CI/CD Workflow

```text
Developer Push →
GitHub Actions →
Docker Build →
Container Test →
EC2 Deployment
```

---

# Build Process

The pipeline builds a Dockerized Flask application.

Example:

```bash
docker build -t payroll-app .
```

---

# Test Process

The pipeline validates container startup before deployment.

Example:

```bash
curl http://localhost:5000
```

---

# Deployment Strategy

Deployment is performed directly to EC2 using SSH.

The deployment process:

1. Connects securely using SSH
2. Pulls latest code
3. Stops old containers
4. Rebuilds containers
5. Starts updated application

---

# Environment Configuration

Environment-specific variables are managed securely using:

- GitHub Secrets
- Runtime environment variables

No secrets are stored in:
- workflow YAML
- source code
- Dockerfile
- Git repository

---

# Multi-Team Deployment Structure

The CI/CD structure supports isolated deployments for:

- Frontend team
- Backend team
- AI services team

Each team can maintain independent workflows and deployment targets.

Example future structure:

```text
.github/workflows/
├── frontend.yml
├── backend.yml
├── ai-services.yml
```

This prevents deployment interference between teams.

---

# Security Considerations

Security controls implemented:

- SSH key-based authentication
- GitHub encrypted secrets
- No hardcoded credentials
- Containerized deployments
- Isolated deployment workflows

---

# Future Improvements

For production environments:

- Use AWS Systems Manager instead of SSH
- Add rolling deployments
- Add Blue/Green deployments
- Add vulnerability scanning
- Add Docker image signing
- Add automated rollback strategy

---

# Conclusion

The CI/CD pipeline provides a secure and automated deployment workflow supporting scalable multi-team development operations.