
provider "aws" {
  region     = "ap-south-1"
}

data "aws_ami" "example" {
  executable_users = ["self"]
  most_recent      = true
  name_regex       = "^myami-\\d{3}"
  owners           = ["self"]

  filter {
    name = "name"
    values = ["myami-*"]
  }

  filter {
    name = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }
}


resource "aws_launch_configuration" "node_app_lc" {
  image_id      = "${data.aws_ami.node_app_ami.id}"
  instance_type = "t2.micro"
  security_groups = ["${aws_security_group.node_app_websg.id}"]
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "node_app_websg" {
  name = "security_group_for_node_app_websg"
  ingress {
    from_port = 3000
    to_port = 3000
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }
}


