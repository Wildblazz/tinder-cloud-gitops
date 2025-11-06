# Generate secrets and add into cluster:
  * In `/argocd/base/infrastructure/secrets` create a file `.env.secrets` Example file: `.env.secrets.example`
  * `chmod +x scripts/apply-secrets.sh`
  * `./scripts/apply-secrets.sh`
