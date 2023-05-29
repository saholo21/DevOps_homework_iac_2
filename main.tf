provider "aws" {
  region = "us-east-1"
}

resource "aws_key_pair" "ssh_key" {
  key_name   = "ssh-key"
  public_key = file("files/key/id_rsa.pub")
}

resource "aws_security_group" "ingress-https" {
  name = "allow-https-connection"
  ingress {
      cidr_blocks = [
        "0.0.0.0/0"
      ]
      from_port = 80
      to_port = 80
      protocol = "tcp"
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "ingress-http" {
  name = "allow-http-connection"
  ingress {
      cidr_blocks = [
        "0.0.0.0/0"
      ]
      from_port = 8082
      to_port = 8082
      protocol = "tcp"
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "ingress-ssh" {
  name = "allow-ssh-connection"
  ingress {
      cidr_blocks = [
        "0.0.0.0/0"
      ]
      from_port = 22
      to_port = 22
      protocol = "tcp"
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "app_server" {
  ami           = "ami-0715c1897453cabd1"  #
  instance_type = "t2.micro"     
  associate_public_ip_address = true
  key_name      = aws_key_pair.ssh_key.key_name
  vpc_security_group_ids = ["${aws_security_group.ingress-ssh.id}", "${aws_security_group.ingress-http.id}"]
  user_data = file("files/agent_setup.sh")
  tags = { Name = "app server" }

}

resource "aws_instance" "web_server" {
  ami           = "ami-0715c1897453cabd1"  #
  instance_type = "t2.micro"     
  associate_public_ip_address = true
  key_name      = aws_key_pair.ssh_key.key_name
  vpc_security_group_ids = ["${aws_security_group.ingress-ssh.id}", "${aws_security_group.ingress-http.id}"]
  user_data = file("files/agent_setup.sh")
  tags = { Name = "web server" }

}

resource "aws_instance" "reverse_proxy" {
  ami           = "ami-0715c1897453cabd1"  #
  instance_type = "t2.micro"
  associate_public_ip_address = true
  key_name      = aws_key_pair.ssh_key.key_name
  vpc_security_group_ids = ["${aws_security_group.ingress-ssh.id}", "${aws_security_group.ingress-http.id}", "${aws_security_group.ingress-https.id}"]
  user_data = file("files/agent_setup.sh")
  tags = { Name = "reverse proxy server" }

}
