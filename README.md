# Golden Image Overview
1. Packer to create base hardened images (cloud + provider agnostic).
2. Ansible to configure the base images (optional).
3. Terraform to pull the Packer Image and provision in the cloud (cloud agnostic).
4. CI/CD Pipeline with GitHub Actions/GitLab to scan on pull request, prior to provisioning. 


## AWS

 Workflow:
 - PR on packer file -> packer spins up a EC2 -> AMI is created off that state and stores it in the AWS AMI repository
 - PR on terraform file -> terraform pulls the latest AMI(stored by packer) -> reprovisions the ec2 based on statefile

### Step 1. AWS AMI Creation/Configuration
- Create a gold ami within image.pkr.hcl using Amazon Linux 2 as a base image
    - gold image needs to be hardened first (Install AWS Inspector and scan for CIS benchmark then harden it)
    - AMI should be automatically stored in the Amazon AMI repository (is it stored in a bucket? can I specify?)
- GitHub Action to scan (trivy(containers) or semgrep) when merging to main. 
    - GitHub Actions can be found in the .github/workflows
- Be able to migrate this to GitLab?
- Should probably put a Nessus agent and have an EC2 host the server? 

### Step 2. GitHub Actions OIDC with AWS for deployment 
Following this link - [here](https://www.youtube.com/watch?v=GowFk_5Rx_I)
- GitHub Action -> GitHub OIDC -> Signed JWT -> Access Token from AWS IAM -> GitHub Action Assume Role
- AWS is configured to add GitHub as a Identity Provider using OpenID Connect, create a role 
- Role created in IAM to AssumeRolewithWebIdentity -> limiting the trust policy only to my repo
    - need to lock the role down a bit more (get more granular in terms of the managed policies)

### Step 3. AMI Creation in AWS (Packer + GitHub Actions)
- AWS spins up the EC2 and saves it in the AMI repository

### Step 4. AMI Creation in AWS (Terraform + GitHub Actions)
- Changes to the AMI, causes terraform to reprovision the ec2 based off of the latest ami
- Stored the Terraform State in an encrypted s3
    - statefile locking?

### Step 5. AMI Hardening using AWS Inspector (CIS)
- inspector.sh installs AWS Inspector agent on the ec2 image. 
- using findings from the AWS Inspector (CIS Standard) in order to lock down AMI

### Step 6. Rinse and Repeat

## GCP
### Step 1. GCP VM Creation
- 

## Docker
### Step 1. Docker Creation
- 

## GitHub Action (CI/CD Pipeline)
- GitHub Action(configured in yaml files workflows folder) spins up an ubuntu image on GitHub servers, and runs the following tasks
    - static code analysis via Semgrep (trivy to implement later/containers scanning),
    - stores the Access Token from AWS IAM
    - installs packer and packer build creates an AMI in the associated AWS Repository
    - installs terraform and terraform apply to update/create the state within AWS

