# Nginx on EKS demo

Sup folks 🖐

## Tasks
1. Deploy EKS + asg
2. Deploy nginx + hpa
3. Create nginx public endpoind
4. Cluster hardening recommendations

### Requirements
* terragrunt 0.63.3
* terraform 1.5.7
* helm 3.8.0
* AWS Account
* Ensure you filled in `registry_username` and `registry_password` in `live/faraway/us-east-1/prod/faraway_app/terragrunt.hcl`

## Getting started
Run `make` to see available options.
Choose `make plan` to see the expected infrastructure changes.
Choose `make apply` to deploy infrastructure in the cloud.
And `make destroy` to stop and delete created services in the cloud. 

## Repo structure
* `live/` configuration files mirroring your live infrastructure
* [`live/faraway`](live/faraway/README.md) Faraway AWS account
* `live/faraway/us-east-1` region specific services
* `live/faraway/us-east-1/dev,prod` environment specific services
* `modules` community modules, infrastructure micro-modules

## Todo
* Introduce code review practices for infrastructure code
* Apply Terraform code only through CD pipeline
* Replace public Terraform modules to owns
* Deploy monitoring system (e.g. Prometheus)
* Deploy dashboards (e.g. Grafana)
* Setup alerts (e.g. Alertmanager)
* Apply security policies
* Implement Karpenter (node autoscaling improvement)
* Implement AWS Load balancer instead of classic Kubernetes LB for Ingress
* Implement GitOps approach
* Use PodDisruption budget
* Use CloudFront in front of LB
* Store sensitive variables in git and encrypt them with Mozilla SOPS

## Feedback
[Suggestions and improvements](https://github.com/exdial/eks-nginx-demo/issues)
