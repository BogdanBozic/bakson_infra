resource "aws_vpc" "bakson" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "bakson"
  }
}

resource "aws_subnet" "bakson_control_plane" {
  count = 2

  map_public_ip_on_launch = true
  availability_zone = data.aws_availability_zones.azs.names[count.index]
  cidr_block        = "10.0.${count.index}.0/24"
  vpc_id            = aws_vpc.bakson.id

  tags = {
    Name = "bakson-control-plane-${count.index}"
  }
}

resource "aws_internet_gateway" "bakson" {
  vpc_id = aws_vpc.bakson.id
  tags = {
    Name = "bakson"
  }
}

resource "aws_route_table" "bakson" {
  vpc_id = aws_vpc.bakson.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.bakson.id
  }

  tags = {
    Name = "bakson"
  }
}

resource "aws_route_table_association" "bakson" {
  count = 2

  subnet_id      = aws_subnet.bakson_control_plane[count.index].id
  route_table_id = aws_route_table.bakson.id
}
