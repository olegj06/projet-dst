output "vpc_id" {
  value       = aws_vpc.main.id
  description = "VPC id."
  # Setting an output value as sensitive prevents Terraform from showing its value in plan and apply.
  sensitive = false
  
}

output "NAT1_data" {
value          = aws_eip.nat1
description = "nat1 ip"
sensitive = false
}

output "NAT2_data" {
value          = aws_eip.nat2
description = "nat2 ip"
sensitive = false
}

output "loadbalancer_dns" {
value         = aws_lb.eks_lb.dns_name
description = "aws lb"
sensitive   = false

}