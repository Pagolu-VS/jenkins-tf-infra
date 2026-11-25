
resource "aws_instance" "main" {
  ami                    = local.ami_id
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.main.id]

  root_block_device {
    volume_size = 50
    volume_type = "gp3"
  }

  user_data = file("jenkins.sh")

  tags = {
    Name = var.instance_name
  }
}

resource "aws_instance" "agent" {
  ami                    = local.ami_id
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.main.id]

  root_block_device {
    volume_size = 50
    volume_type = "gp3"
  }

  user_data = file("agent.sh")

  tags = {
    Name = var.agent_name
  }
}

resource "aws_security_group" "main" {
  name        = "jenkins-sg"
  description = "Security group for Jenkins instance"

  # Allow SSH access (restrict CIDR to your IP)
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow Jenkins UI access (restrict CIDR to your IP)
  ingress {
    description = "Jenkins UI"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = var.instance_name
  }
}

resource "aws_route53_record" "main" {
  zone_id = "Z06922472FYLS1CT8N9V4"
  name    = "jenkins.iamvidya.online"
  type    = "A"
  ttl     = 1

  records = [aws_instance.main.public_ip]
}

resource "aws_route53_record" "agent" {
  zone_id = "Z06922472FYLS1CT8N9V4"
  name    = "jenkins-agent.iamvidya.online"
  type    = "A"
  ttl     = 1

  records = [aws_instance.agent.private_ip]
}