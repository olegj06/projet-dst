resource "aws_security_group" "load_balancer_sg" {
  vpc_id = aws_vpc.main.id


# Define your security group rules here

name= "eks-elb-sg"
#incoming traffic
ingress {
 from_port =  22
 to_port = 22
 protocol = "tcp"
cidr_blocks = ["0.0.0.0/0"]  // replace it with your ip address
}

ingress  { 
 from_port =  80
 to_port = 80
 protocol = "tcp"
 cidr_blocks = ["0.0.0.0/0"]  // replace it with your ip address
}

ingress  { 
 from_port =  443
 to_port = 443
 protocol = "tcp"
 cidr_blocks = ["0.0.0.0/0"]  // replace it with your ip address
}


#outgoing traffic
egress {
 from_port =  0
 protocol = "-1"
 to_port =  0
 cidr_blocks = ["0.0.0.0/0"]
}
}

resource "aws_lb" "eks_lb" {
  name               = "eks-lb"
  internal           = false
  load_balancer_type = "application"
  subnets            = [aws_subnet.private_1.id, aws_subnet.private_2.id]
  security_groups    = [aws_security_group.load_balancer_sg.id]
}

resource "aws_lb_target_group" "eks_target_group" {
  name     = "eks-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
}

resource "aws_lb_listener"  "listener" {

  load_balancer_arn = aws_lb.eks_lb.arn
  port              = 80
  protocol          = "HTTP"
  #ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  #certificate_arn   = aws_acm_certificate.certificate.arn
  

  default_action {
  type = "forward"
  target_group_arn = aws_lb_target_group.eks_target_group.arn
  # type = "redirect"
  #   redirect {
    
  #     status_code = "HTTP_301"
  #     host = "fr.yahoo.com"
  #     port = 80
  #     protocol = "HTTP"

  #   }
  
  }

}


# Route53 config

# resource "aws_route53_zone" "primary" {
#   name = "projetr.ddns.net"
# }



# resource "aws_route53_record" "eks_lb_alias" {
#   zone_id = aws_route53_zone.primary.zone_id
#   name    = "projetr.ddns.net"
#   type    = "A"
#   alias {
#     name                   = aws_lb.eks_lb.dns_name
#     zone_id                = aws_lb.eks_lb.zone_id 
#     evaluate_target_health = true
#   }
# }


/* resource "aws_lb_target_group_attachment" "eks_target_attachment" {
target_group_arn = aws_lb_target_group.eks_target_group.arn
  target_id        =  
} */
# Update your EKS cluster configuration to use the load balancer
# Example: aws_eks_service.my_service.load_balancer_arn = aws_lb.eks_lb.arn
