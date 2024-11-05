provider "aws" {
  region = "eu-north-1"  
}

# Création du VPC
resource "aws_vpc" "main_vpc" {
  cidr_block = "10.0.0.0/16"
}

# Création d'un sous-réseau
resource "aws_subnet" "main_subnet" {
  vpc_id                   = aws_vpc.main_vpc.id
  cidr_block               = "10.0.1.0/24"
  availability_zone        = "eu-north-1a"  
  map_public_ip_on_launch  = true           
}

# Création du groupe de sécurité
resource "aws_security_group" "main_sg" {
  vpc_id = aws_vpc.main_vpc.id

  # Autorise SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Autorise le trafic HTTP
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Autorise tout le trafic sortant
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Création de l'instance EC2 pour le serveur HTTP
resource "aws_instance" "http_instance" {
  ami                         = "ami-03c2970bdb10a9e99"  
  instance_type               = "t3.micro"               
  key_name                    = "new_ec2_key"            
  subnet_id                   = aws_subnet.main_subnet.id
  vpc_security_group_ids      = [aws_security_group.main_sg.id]
  associate_public_ip_address = true                     

  tags = {
    Name = "HTTP-Instance"
  }
}

# Création de l'instance EC2 pour le serveur SCRIPT
resource "aws_instance" "script_instance" {
  ami                         = "ami-03c2970bdb10a9e99"  
  instance_type               = "t3.micro"               
  key_name                    = "new_ec2_key"            
  subnet_id                   = aws_subnet.main_subnet.id
  vpc_security_group_ids      = [aws_security_group.main_sg.id]
  associate_public_ip_address = true                    

  tags = {
    Name = "SCRIPT-Instance"
  }
}

# Outputs pour les adresses IP
output "http_instance_ip" {
  value = aws_instance.http_instance.public_ip
}

output "script_instance_ip" {
  value = aws_instance.script_instance.public_ip
}
