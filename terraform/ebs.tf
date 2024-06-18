# Create an EBS volume
resource "aws_ebs_volume" "ebs-mysql-eu-west-3a" {
  availability_zone = "eu-west-3a" # Replace with your desired Availability Zone
  size              = 10          # Specify the size of the volume in GiB

  tags = {
    Name = "ebs-mysql-a"
  }
}

resource "aws_ebs_volume" "ebs-mysql-eu-west-3b" {
  availability_zone = "eu-west-3b" # Replace with your desired Availability Zone
  size              = 10          # Specify the size of the volume in GiB

  tags = {
    Name = "ebs-mysql-b"
  }
}