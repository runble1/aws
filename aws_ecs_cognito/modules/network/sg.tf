resource "aws_security_group" "vpc_endpoint" {
  name   = "${var.env}-${var.service}-vpc-endpoint-sg"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.main.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" #念のため
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.service}-vpc-endpoint-sg"
  }
}
