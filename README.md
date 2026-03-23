# Sonatype Nexus 3 hosted at Eclipse Foundation

This repository contains all required sources for the Sonatype Nexus 3 instance hosted at https://repo.eclipse.org and https://repo-staging.eclipse.org.

## Contents

* Helm chart for Nexus 3
* Deployment script for Nexus 3
* Configuration files for staging and production environments

## Prerequisites

### Database Secret

Before deploying Nexus 3, you need to create a Kubernetes secret containing the PostgreSQL database credentials:

```bash
kubectl -n <namespace> create secret generic nexus3-postgressql-db \
  --from-literal=db_name='nexus3_<env>' \
  --from-literal=db_user='nexus3_<env>_rw' \
  --from-literal=db_pw='...'
```

Replace:
- `<namespace>`: the Kubernetes namespace (e.g., `repo3-eclipse-org`)
- `<env>`: the environment name (e.g., `staging` or `production`)
- `db_pw`: the actual database password

### Nexus License File

Place your Nexus Repository Manager license file in the following location:

```
charts/nexus3/secrets/nxrm-license.lic
```

This file will be automatically mounted into the container at `/etc/nxrm-license/nxrm-license.lic`.

## Deployment

### Deploy to Staging

To deploy Nexus 3 to the staging environment:

```bash
./helm-deploy-nexus3.sh staging
```

This will:
- Use the configuration from `charts/nexus3/values-staging.yaml`
- Deploy to namespace `repo-eclipse-org-staging`
- Create/upgrade the Helm release `nexus3-staging`

### Deploy to Production

To deploy Nexus 3 to the production environment:

```bash
./helm-deploy-nexus3.sh production
```

This will:
- Use the configuration from `charts/nexus3/values.yaml`
- Deploy to namespace `repo3-eclipse-org`
- Create/upgrade the Helm release `nexus3-production`
- Show a diff before applying changes (for upgrades)

### Deploy with Custom Image Tag

You can optionally specify a custom image tag:

```bash
./helm-deploy-nexus3.sh <environment> <image-tag>
```

Example:
```bash
./helm-deploy-nexus3.sh staging 3.70.1
```

## Configuration

### Environment-Specific Settings

- **Staging**: `charts/nexus3/values-staging.yaml`
  - Namespace: `repo-eclipse-org-staging`
  - Host: `repo-staging.eclipse.org`
  - SELinux level: `s0:c34,c19`

- **Production**: `charts/nexus3/values.yaml`
  - Namespace: `repo3-eclipse-org`
  - Host: `repo.eclipse.org`
  - SELinux level: `s0:c66,c15`

