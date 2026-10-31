# OCI infrastructure for the Online Store

Terraform under terraform-iac/environments/prod manages the existing VCN, networking and three-node
OKE cluster. Application deployment, Gateway configuration and image promotion belong in
platform-gitops. Frontend and notification additions need no new OCI infrastructure: they use
ClusterIP Services and the existing Gateway with local port-forwarding.

## Local validation

```bash
cd terraform-iac/environments/prod
terraform init -backend=false
terraform validate
```

Do not run apply merely to add frontend/notification workloads. Preserve the existing Terraform
state and tfvars; never commit OCI API private keys or credential values. Provider versions are
controlled by the committed lock file. No infrastructure configuration change is required for the
private final demo. Recheck live node scheduling if resource requests increase.

## Trial closeout

Complete the demo and retain the repository commits and non-secret verification results before
trial expiry. Stopping port-forwards does not stop OCI workers or volumes. Current GitOps applications
use no automatic pruning, and PostgreSQL/RabbitMQ volumes use Retain, so deleting Applications or
PVCs does not guarantee OCI storage is removed.

When you decide to dismantle the learning environment, inventory the live resources and the
Terraform state first. Remove workloads and their cloud storage deliberately, review a Terraform
destroy plan, and only then execute the approved cleanup. Inspect OCI for retained block volumes,
boot volumes and other leftovers afterward. Terraform does not own CSI-created data volumes merely
because it owns the cluster. This repository does not automatically destroy anything at trial expiry.
