# Tinder-Cloud GitOps

### Overview

GitOps repository for Tinder-Cloud microservices deployment using ArgoCD. 
This repository contains Kubernetes manifests, ArgoCD applications, and deployment configurations for the distributed dating platform backend

### Repository Purpose

This repository manages:
* Kubernetes deployment manifests for all microservices
* ArgoCD application definitions and projects
* Infrastructure components configuration (databases, messaging, caching)
* Environment-specific configurations and secrets management
* Automated deployment pipelines through GitOps principles

### Project Context

This GitOps repository is part of the [Tinder-Cloud](https://github.com/Wildblazz/tinder-cloud.git) educational project

### Architecture Components

**Application Services:**
* `profile-service` - User profile management
* `reaction-service` - Like/dislike functionality
* `recommendation-service` - Profile recommendation engine
* `match-service` - Match detection and management

**Infrastructure Services:**
* PostgreSQL - Primary data storage
* MongoDB - Performance optimization storage
* Redis - Caching layer
* Apache Kafka - Event streaming
* Keycloak - Identity and access management

### Prerequisites

* Docker Desktop or Podman
* Kubernetes cluster (minikube for local development)
* kubectl CLI tool
* ArgoCD CLI (optional)
* kustomize

### Quick Start
* Run all: from the root folder run: `make` to deploy all following steps

### Manual deployment steps
* Run minikube:
  * `cd scripts`
  * `chmod +x minikube-init.sh`
  * `./minikube-init.sh`
  * Optionally open minikube UI: `minikube dashboard`
* Run ArgoCD:
  * `chmod +x argocd-init.sh` 
  * `./argocd-init.sh`
* Install kustomize: `brew install kustomize`
* Create ArgoCD apps:
  * `kubectl apply -f argocd/app-projects/infrastructure.yaml` 
  * `kubectl apply -f argocd/app-projects/tinder-cloud.yaml`
* Generate secrets and add into cluster:
    * See detailed instructions in the [Secrets README](argocd/secrets/README.md)
* Deploy infra apps in cluster:
    * `kubectl apply -f argocd/apps/infrastructure-app.yaml`
    * `kubectl apply -f argocd/apps/tinder-app.yaml`\
* Deploy all resources in cluster:
    * `kubectl apply -k argocd/base/infrastructure/`
    * `kubectl apply -k argocd/base/tinder-app/`
* Expose local docker registry port: `kubectl port-forward -n infrastructure service/registry 5000:5000` 
* Expose local ingress port: `kubectl -n ingress-kong port-forward service/kong-proxy 8888:80 &` 
* Generate app images (need to clone [Main repo](https://github.com/Wildblazz/tinder-cloud.git)): 
  * By script: `chmod +x scripts/build-images.sh` and `./scripts/build-images.sh`
  * Or manually:
    * Make images accessible inside minikube BEFORE image building: `eval $(minikube docker-env)`
    * profile-service:        `docker build -t profile-service:latest -f be-components/profile-service/Dockerfile .`
    * reaction-service:       `docker build -t reaction-service:latest -f be-components/reaction-service/Dockerfile .`
    * recommendation-service: `docker build -t recommendation-service:latest -f be-components/recommendation-service/Dockerfile .`
    * match-service:          `docker build -t match-service:latest -f be-components/match-service/Dockerfile .`

* Useful commands:
  * Minikube dashboard: `minikube dashboard`
  * To make ArgoCd UI accessible: `kubectl port-forward svc/argocd-server -n argocd 8444:443`
  * ArgoCd UI: `https://localhost:8444`
  * ArgoCd UI Login: `admin`. Get password: `kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo`
  * Port forward minikube service (for example KeyCloak): `minikube service keycloak -n tinder-space --url`
  * Restart all deployment in namespace: `kubectl get deployments -n infrastructure -o name | xargs kubectl rollout restart -n infrastructure`

Shield: [![CC BY-NC 4.0][cc-by-nc-shield]][cc-by-nc]

This work is licensed under a
[Creative Commons Attribution-NonCommercial 4.0 International License][cc-by-nc].

[![CC BY-NC 4.0][cc-by-nc-image]][cc-by-nc]

[cc-by-nc]: https://creativecommons.org/licenses/by-nc/4.0/
[cc-by-nc-image]: https://licensebuttons.net/l/by-nc/4.0/88x31.png
[cc-by-nc-shield]: https://img.shields.io/badge/License-CC%20BY--NC%204.0-lightgrey.svg
