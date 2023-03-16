{
    "builders": [
        {
            "type": "amazon-ebs",
            "region": "us-east-1",
            "source_ami": "ami-044855ba95c71c991",
            "instance_type": "t2.micro",
            "ssh_username": "ec2-user",
            "ami_name": "amazon-linux-{{timestamp}}"
        }
    ],
    "provisioners": [
        {
            "type": "shell",
            "inline": [
                "sudo yum update -y",
                "sudo yum install -y nginx"
            ]
        }
    ]
}