# PWC-Task

This repository contains a small Python web application packaged with Docker, Kubernetes manifests for deployment, Terraform infrastructure code for provisioning Azure resources, and GitHub Actions workflows for CI/CD and Terraform automation.

## Repository layout

- `Dockerfile` - multi-stage Dockerfile that installs Python dependencies and runs `run.py` on container start.
- `requirements.txt` - Python dependencies used by the app.
- `run.py` - application entrypoint.
- `app/` - application source code (routes and services).
- `Kubernetes/` - Kubernetes manifests:
	- `deployment.yaml` - Deployment spec for the app.
	- `service.yaml` - Service definition to expose the app inside the cluster or externally.
- `Terraform-Infra/` - Terraform code to provision cloud resources (contains `Main/` and `Modules/`).
	- `Main/` - top-level Terraform configuration (backend, provider, variables, tfvars).
	- `Modules/Compute`, `Modules/Network`, `Modules/Resources` - reusable Terraform modules.
- `.github/workflows/` - GitHub Actions workflows:
	- `CI-workflow.yaml` - build/test CI pipeline.
	- `CD-workflow.yaml` - deployment pipeline (Docker push / Kubernetes deploy).
	- `Terraform-workflow.yaml` - runs Terraform plan/apply in CI for infra changes.

## Quick goals covered by this README

- Build and run the app locally with Docker.
- Deploy the app to a Kubernetes cluster.
- Initialize and apply Terraform in `Terraform-Infra/Main`.
- Understand the included GitHub Actions workflows.

---

## Docker

The `Dockerfile` uses a multi-stage build:

- Stage 1 installs Python dependencies from `requirements.txt` into the container user site (`/root/.local`).
- Stage 2 copies the installed packages into the final image, sets `PATH` so installed binaries are available, copies the app sources, exposes port `5000`, and runs `python run.py`.

Build and run locally (PowerShell):

```powershell
# Build image (run from repository root)
docker build -t pwc-task:latest .

# Run container and map port 5000
docker run --rm -p 5000:5000 pwc-task:latest
```

If your app listens on a different port, adjust the `-p` mapping accordingly.

---

## Kubernetes

Manifests are in the `Kubernetes/` folder. Typical files included:

- `deployment.yaml` — defines a Deployment with the container image, replicas and resource requests/limits.
- `service.yaml` — exposes the Deployment via LoadBalancer as required.

Apply the manifests to a cluster (PowerShell):

```powershell
# Apply Deployment
kubectl apply -f .\Kubernetes\deployment.yaml

# Apply Service
kubectl apply -f .\Kubernetes\service.yaml

# Check pods and service
kubectl get pods
kubectl get svc
```


Notes:
- If `service.yaml` uses `type: LoadBalancer`, your cloud provider will provision an external IP (may take a few minutes).
- Ensure your kubeconfig points to the intended cluster before running apply.

---

## Terraform

Terraform code is under `Terraform-Infra/` and is organized into a `Main/` folder with a `backend.tf`, `provider.tf`, `main.tf`, `variables.tf`, and `terraform.tfvars` plus reusable module folders under `Modules/` (Compute, Network, Resources).

Typical workflow (run from `Terraform-Infra/Main`):

```powershell
cd .\Terraform-Infra\Main

# Initialize Terraform and backend
terraform init

# (Optional) Validate
terraform validate

# Plan using the tfvars file
terraform plan 

# Apply (review plan then apply)
terraform apply 
```

Notes and tips:
- `backend.tf` configures remote state (if present). Ensure any required backend credentials or service principal are configured.
- `terraform.tfvars` typically contains environment-specific values (subscription IDs, resource prefixes). Do not commit secrets — use environment variables or secure variable stores for credentials.
- Modules in `Modules/` are referenced from `Main/main.tf`.

---

## GitHub Actions workflows

Workflows are located in `.github/workflows/`:

- `CI-workflow.yaml` — runs on push for only the docker and python files, or manually to build and test the application, and may build a Docker image for testing.
- `CD-workflow.yaml` — triggered on push to Kubernetes files, manually and when CI-workflow is succesful, to  deploy the Kubernetes Cluster.
- `Terraform-workflow.yaml` — runs Terraform plan and (optionally) apply in CI using GitHub Actions for infrastructure changes. It uses a service principal with OIDC authentication / secrets stored in repository secrets.

---

## Development notes

- The application entrypoint is `run.py`. Use `requirements.txt` to reproduce the environment.
- The application code is under `app/` with `routes/` and `services/`.

Run locally without Docker (if you have Python installed):

```powershell
python -m venv .venv
. .\.venv\Scripts\Activate.ps1
pip install -r requirements.txt
python run.py
```

---