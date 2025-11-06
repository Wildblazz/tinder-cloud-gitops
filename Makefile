KUBECTL = kubectl apply -f
KUSTOMIZE = kubectl apply -k

# Run all setup steps
all: deploy-resources

deploy-resources: deploy-apps
deploy-apps: apply-projects
apply-projects: argocd-init
argocd-init: minikube-init

minikube-init:
	bash scripts/minikube-init.sh

argocd-init:
	bash scripts/argocd-init.sh

generate-secrets:
	bash scripts/apply-secrets.sh

# ArgoCD
apply-projects:
	$(KUBECTL) argocd/app-projects/infrastructure.yaml
	$(KUBECTL) argocd/app-projects/tinder-cloud.yaml

deploy-apps:
	$(KUBECTL) argocd/apps/infrastructure-app.yaml
	$(KUBECTL) argocd/apps/tinder-app.yaml

deploy-resources:
	$(KUSTOMIZE) argocd/base/infrastructure/
	$(KUSTOMIZE) argocd/base/tinder-app/

.PHONY: all minikube-init argocd-init generate-secrets apply-projects deploy-apps deploy-resources
