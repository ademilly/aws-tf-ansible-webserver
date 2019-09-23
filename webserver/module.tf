data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-*-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

variable "vpc_id" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "cidr" {
  type = list(string)
}

variable "name" {
  type    = string
  default = "webserver"
}

resource "aws_security_group" "webserver" {
  name        = "webserver"
  description = "webserver access"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.cidr
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "webserver" {
  key_name   = "aws-deploy-webserver"
  public_key = "${file("aws-deploy-webserver.pub")}"
}

resource "aws_instance" "webserver" {
  ami           = "${data.aws_ami.ubuntu.id}"
  instance_type = "t2.nano"
  subnet_id     = var.subnet_id

  key_name               = "${aws_key_pair.webserver.key_name}"
  vpc_security_group_ids = ["${aws_security_group.webserver.id}"]

  tags = {
    Name = var.name
  }
}

resource "local_file" "ansible-inventory" {
  filename = "hosts"
  content  = <<EOF
[webserver]
${aws_instance.webserver.public_ip}
[webserver:vars]
ansible_user=ubuntu
ansible_ssh_private_key_file=${aws_key_pair.webserver.key_name}
ansible_ssh_extra_args='-o StrictHostKeyChecking=no'
EOF
}
