resource "aws_instance" "my_vm" {
 ami                       = "ami-053b0d53c279acc90" //Ubuntu AMI
 instance_type             = "t2.micro"

 tags = {
   Name = "My EC2 instance",
 }
}