### Master Node ###

resource "aws_security_group" "bakson_master" {
  name        = "bakson"
  description = "Cluster communication with worker nodes"
  vpc_id      = aws_vpc.bakson.id
}

resource "aws_vpc_security_group_ingress_rule" "bakson_master_public_inbound" {
  security_group_id = aws_security_group.bakson_master.id

  description = "Allow public inbound traffic."
  from_port   = 443
  to_port     = 443
  ip_protocol = "tcp"
  cidr_ipv4   = "0.0.0.0/0"
}

resource "aws_vpc_security_group_egress_rule" "eks_cluster_outbound" {
  security_group_id = aws_security_group.bakson_master.id

  description = "Allow all outbound traffic."
  from_port   = 0
  to_port     = 0
  ip_protocol = "tcp"
  cidr_ipv4   = "0.0.0.0/0"
}

resource "aws_vpc_security_group_ingress_rule" "eks_cluster_vpc" {
  security_group_id = aws_security_group.bakson_master.id

  description = "Allow all inbound traffic within VPC."
  from_port   = 0
  to_port     = 0
  ip_protocol = "tcp"
  cidr_ipv4   = aws_vpc.bakson.cidr_block
}

resource "aws_vpc_security_group_egress_rule" "eks_cluster_vpc" {
  security_group_id = aws_security_group.bakson_master.id

  description = "Allow all outbound VPC traffic."
  from_port   = 0
  to_port     = 0
  ip_protocol = "tcp"
  cidr_ipv4   = aws_vpc.bakson.cidr_block
}

### End Master Node ###

### Worker Node ###

resource "aws_security_group" "bakson_worker" {
  name        = "bakson_worker"
  description = "Security group for all worker nodes in the cluster"
  vpc_id      = aws_vpc.bakson.id
}

resource "aws_vpc_security_group_ingress_rule" "bakson_worker_vpc" {
  security_group_id = aws_security_group.bakson_worker.id

  description = "Allow all traffic within VPC."
  from_port   = 0
  to_port     = 0
  ip_protocol = "tcp"
  cidr_ipv4   = aws_vpc.bakson.cidr_block
}

resource "aws_vpc_security_group_egress_rule" "bakson_worker_outbound_vpc" {
  security_group_id = aws_security_group.bakson_worker.id

  description = "Allow outgoing VPC traffic for worker nodes"
  from_port   = 0
  to_port     = 0
  ip_protocol = "tcp"
  cidr_ipv4   = aws_vpc.bakson.cidr_block
}

### End Worker Node ###
