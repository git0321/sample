provider "aws" {
    access_key = "AKIAZTIMJ7JHPVODYVZA"
    secret_key = "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"
    region = "${var.region}" 
}
/*
resource "aws_instance" "pinkcloudterraform" {
  ami = "ami-06358f49b5839867c"
  instance_type = "t2.medium"
  key_name = "${aws_key_pair.pinkkey.id}"
  tags = {
      Name = "kajalinstance"
  }
  vpc_security_group_ids = ["${aws_security_group.pinksecurityterraform.id}"]

  provisioner "local-exec" {
    when = "create"
    command = "echo ${aws_instance.pinkcloudterraform.public_ip}>sample.txt"
    } 


 
}
*/

resource "aws_eip" "elasticcloudterraform" {
  tags = {
      Name = "kajaleipinstance"
  }
   instance = "${aws_instance.purplecloudterraform.id}"
}



output "kajalpublicip" {
    value = "${aws_instance.purplecloudterraform.public_ip}"
}

resource "aws_key_pair" "pinkkey" {
    key_name = "kajalkeypair"
    public_key = "${file("C:\\Kajal\\kajalkey.pub")}"
}

resource "aws_security_group" "pinksecurityterraform" {
    name = "kajalsecurity"
    description = "To allow traffic"

    ingress{
        from_port = "0"
        to_port = "0"
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress{
        from_port = "0"
        to_port = "0"
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}


resource "aws_instance" "purplecloudterraform" {
  ami = "ami-06358f49b5839867c"
  instance_type = "t2.micro"

  tags = {
      Name = "kajalinstance"
  } 

 provisioner "chef" {

      connection {
          host = "${self.public_ip}"
          type = "ssh"
          user = "ubuntu"
          private_key = "${file("C:\\Kajal\\kajalkey.pem")}"
        }
        client_options = [ "chef_license 'accept'" ]
        run_list = ["createfilebook::default"]
        recreate_client = true
        node_name = "node.kajal.come"
        server_url = "https://manage.chef.io/organizations/ayla"
        user_name = "chefkajal"
        user_key = "${file("C:\\Kajal\\chef-repo\\.chef\\chefkajal.pem")}"
        ssl_verify_mode = ":verify_none"
   }
}


provider "azurerm" {
}


resource "aws_s3_bucket" "lalabucket" {
  bucket = "aylabucket"
  acl = "private"
  force_destroy = "true"
}

terraform {
  backend "s3" {
    bucket = "aylabucket"
    key = "terraform.tfstate"
    region = "eu-west-1"
}
}


























