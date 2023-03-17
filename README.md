# Golden-image

## High Level Workflow
Workflow: Pull request changes terraform file -> terraform pulls the latest ami -> reprovisions the ec2 based on statefile
---

### Overall Plan
1. Packer to create base hardened images (cloud + provider agnostic).
2. Ansible to configure the base images (optional).
3. Terraform to pull the Packer Image and provision in the cloud (cloud agnostic).
4. CI/CD Pipeline with GitHub Actions/GitLab to scan on pull request, prior to provisioning. 

### 1. Packer AMI
- Create a gold ami and then automatically push the ami to the cloud for it to be used later in my automated pipeline
    - gold AMI needs to be hardened first (Install AWS Inspector and scan for CIS benchmark then harden it)
    - AMI should be automatically stored in the Amazon AMI repository (is it stored in a bucket? can I specify?)
- GitHub Action to scan (trivy(containers) or semgrep) when merging to man. 
    - GitHub Actions can be found in the .github/workflows
- Be able to migrate this to GitLab?
- Should probably put a Nessus agent and have an EC2 host the server? 

#### Fully automated Pipeline
Following this link - [here](https://www.youtube.com/watch?v=GowFk_5Rx_I)
- GitHub Action -> GitHub OIDC -> Signed JWT -> Access Token from AWS IAM -> GitHub Action Assume Role
- AWS is configured to add GitHub as a Identity Provider using OpenID Connect, create a role 
- Role created in IAM to AssumeRolewithWebIdentity -> limiting the trust policy only to my repo
    - need to lock the role down a bit more (get more granular in terms of the managed policies)
- Storing the Terraform State in an encrypted s3
    - statefile locking?

### FAQ
- GitHub Action(configured in yaml files workflows folder) spins up an ubuntu image on GitHub servers, and runs the following tasks
    - static code analysis via Semgrep (trivy to implement later/ containers scanning),
    - stores the Access Token from AWS IAM
    - installs packer and packer build creates an AMI in the associated AWS Repository
    - installs terraform and terraform apply to update/create the state within AWS

