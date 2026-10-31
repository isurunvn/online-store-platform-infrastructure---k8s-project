# Infrastructure CI

`check.yml` runs Terraform formatting, init with backend disabled and a read-only
provider lock file, validation, Gitleaks and report-only Trivy misconfiguration
scanning on PRs and main pushes. It never plans/applies/destroys or uses OCI secrets.
Terraform 1.14.0 is checksum-pinned; OCI provider 7.32.0 is locked with checksums.
Only the Trivy JSON report is uploaded, never state, tfvars or plan files.
Dependabot proposes provider and GitHub Action updates. Review plans separately
with explicit authorization for infrastructure changes.

See platform-gitops/DELIVERY.md for the full cross-repository delivery architecture,
and platform-gitops/docs/TRIAL-RECOVERY.md for protected exports and teardown review.
Terraform uses the Business Source License; internal project use does not require
purchasing Terraform Cloud. Source: https://www.hashicorp.com/license-faq
