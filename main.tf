provider "aws" {
  access_key = var.AWS_ACCESS_KEY
  secret_key = var.AWS_SECRET_ACCESS_KEY
  region     = "us-east-1"
}


resource "aws_security_group" "DockerWebSG" { #Vamos a crear un grupo de seguridad
  name = "sg_reglas_firewall_Docker-Swarm"
  ingress {                     #Reglas de firewall de entrada
    cidr_blocks = ["0.0.0.0/0"] #Se aplicará a todas las direcciones
    description = "SG HTTP"     #Descripción
    from_port   = 80            #Del puerto
    to_port     = 80            #Al puerto
    protocol    = "tcp"         #Protocolo
  }
  ingress {
    cidr_blocks = ["0.0.0.0/0"] #Se aplicará a todas las direcciones
    description = "SG HTTPS"    #Descripción
    from_port   = 443           #Del puerto
    to_port     = 443           #Al puerto
    protocol    = "tcp"         #Protocolo
  }
  ingress {
    cidr_blocks = ["0.0.0.0/0"] #Se aplicará a todas las direcciones
    description = "SG SSH"      #Descripción
    from_port   = 22            #Del puerto
    to_port     = 22            #Al puerto
    protocol    = "tcp"         #Protocolo
  }
  egress {                                  #Reglas de firewall de salida
    cidr_blocks = ["0.0.0.0/0"]             #Se aplicará a todas las direcciones
    description = "SG All Traffic Outbound" #Descripción
    from_port   = 0                         #Del puerto
    to_port     = 0                         #Al puerto
    protocol    = "-1"                      #Protocolo
  }
}
resource "aws_instance" "Docker-Swarm" {
  instance_type = "t2.micro"
  count         = 3
  ami           = "ami-08d4ac5b634553e16"
  tags = {
    "name" = "Node-${count.index}"
  }
  key_name               = "Rsoclave"
  user_data              = filebase64("${path.module}/scripts/docker2.sh")
  vpc_security_group_ids = [aws_security_group.DockerWebSG.id]
}
output "public_ip" {
  value = join(",", aws_instance.Docker-Swarm.*.public_ip)
}
