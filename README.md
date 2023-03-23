### Golden Image Overview
1. Packer to create base hardened images (cloud + provider agnostic).
2. Ansible to configure the base images (optional).
3. Terraform to pull the Packer Image and provision in the cloud (cloud agnostic).
4. CI/CD Pipeline with GitHub Actions/GitLab to scan on pull request, prior to provisioning. 
--
### AWS
--
### Step 1 AWS AMI Creation
- Create a gold ami and then automatically push the image to the cloud for it to be used later in my automated pipeline
    - gold image needs to be hardened first (Install AWS Inspector and scan for CIS benchmark then harden it)
    - AMI should be automatically stored in the Amazon AMI repository (is it stored in a bucket? can I specify?)
- GitHub Action to scan (trivy(containers) or semgrep) when merging to man. 
    - GitHub Actions can be found in the .github/workflows
- Be able to migrate this to GitLab?
- Should probably put a Nessus agent and have an EC2 host the server? 

#### Step 2. AWS Fully automated Pipeline
Following this link - [here](https://www.youtube.com/watch?v=GowFk_5Rx_I)
- GitHub Action -> GitHub OIDC -> Signed JWT -> Access Token from AWS IAM -> GitHub Action Assume Role
- AWS is configured to add GitHub as a Identity Provider using OpenID Connect, create a role 
- Role created in IAM to AssumeRolewithWebIdentity -> limiting the trust policy only to my repo
    - need to lock the role down a bit more (get more granular in terms of the managed policies)
- Storing the Terraform State in an encrypted s3
    - statefile locking?

 Workflow:
 PR on packer file -> packer spins up a EC2 -> AMI is created off that state and stores it in the AWS AMI repository
 PR on terraform file -> terraform pulls the latest AMI -> reprovisions the ec2 based on statefile

#### Step 3. AMI Hardening using AWS Inspector (CIS)
- inspector.sh installs AWS Inspector agent on the ec2 image. 
- using findings from the 
--
### GCP
--
### Step 1. GCP VM Creation

--
### Docker
--
### Step 1. Docker Creation


### GitHub Action (CI/CD Pipeline)
- GitHub Action(configured in yaml files workflows folder) spins up an ubuntu image on GitHub servers, and runs the following tasks
    - static code analysis via Semgrep (trivy to implement later/containers scanning),
    - stores the Access Token from AWS IAM
    - installs packer and packer build creates an AMI in the associated AWS Repository
    - installs terraform and terraform apply to update/create the state within AWS

