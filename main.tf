provider "aws" {
  region = "us-east-1"
}

resource "aws_key_pair" "ssh_key" {
  key_name   = "ssh-key"
  public_key = file("files/key/id_rsa.pub")
}

resource "aws_security_group" "devops" {
  count       = length(var.security_groups)
  name        = var.security_groups[count.index].name
  description = var.security_groups[count.index].description

  ingress {
    from_port   = var.security_groups[count.index].ports[0]
    to_port     = var.security_groups[count.index].ports[1]
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "app_server" {
  ami           = "ami-0715c1897453cabd1"  #
  instance_type = "t2.micro"
  count         = length(var.instance_names)     
  associate_public_ip_address = true
  key_name      = aws_key_pair.ssh_key.key_name
  vpc_security_group_ids = ["${aws_security_group.devops[0].id}", "${aws_security_group.devops[1].id}"]
  user_data = file("files/agent_setup.sh")
  tags = { Name = element(var.instance_names, count.index) }

}

