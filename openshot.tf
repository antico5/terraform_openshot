provider "aws" {
  region  = "us-east-1"
  version = "~> 3.11.0"
}

data "aws_ami" "openshot_ami" {
  most_recent = true
  owners      = ["aws-marketplace"]

  filter {
    name   = "name"
    values = ["*OpenShot*"]
  }
}

resource "aws_security_group" "openshot_allow_http_ssh" {
  name        = "openshot_allow_http_ssh"
  description = "Allow http and ssh into openshot instance"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


}

resource "aws_instance" "web" {
  ami             = data.aws_ami.openshot_ami.id
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.openshot_allow_http_ssh.name]
  key_name        = "openshot-ssh"
  user_data       = file("./openshot.sh")

  tags = {
    Name = "HelloWorld"
  }
}

output "IP" {
  value = aws_instance.web.public_ip
}
