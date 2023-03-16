# Golden-image
### Overall Plan
1. Packer to create base hardened images (cloud + provider agnostic).
2. Ansible to configure the base images (optional).
3. Terraform to pull the Packer Image and provision in the cloud (cloud agnostic).
4. CI/CD Pipeline with GitHub Actions/GitLab to scan on each pull request, prior to provisioning. 


### 1. Packer AMI
- Create a gold ami and then automatically push the ami to the cloud for it to be used later in my automated pipeline
    - gold AMI needs to be hardened first (Install AWS Inspector and follow the instructiosn for CIS)
    - AMI should be automatically stored in the Amazon AMI repository (is it stored in a bucket? can I specify?)


#### Fully automated Pipeline
Following this link - [here](https://www.youtube.com/watch?v=GowFk_5Rx_I)
- GitHub Action -> GitHub OIDC -> Signed JWT -> Access Token from AWS IAM -> GitHub Action Assume Role
- AWS is configured to add GitHub as a Identity Provider using OpenID Connect, create a role 
- Role created in IAM to AssumeRolewithWebIdentity -> limiting the trust policy only to my repo
    - need to lock the role down a bit more (get more granular in terms of the managed policies)
- Storing the Terraform State in an encrypted s3
    - statefile locking?




GitHub Action, specified in terraform.yml, creates an ubuntu image(within the github action), installs terraform and then "terraform apply" to create an ec2 instance in AWS

Workflow -> Pull request changes terraform file, terraform pulls the latest ami -> reprovisions the ec2?