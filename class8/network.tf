# VPC
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"


  tags = {
    Name = "august-vpc-tf"
  }
}


# Implicit dependency = aws_vpc.main.id



#Public Subnet -2
resource "aws_subnet" "public-1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-1"
  }
}

resource "aws_subnet" "public-2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "public-subnet-2"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "august-bootie-igw"
  }
}

# Public Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "public-route-table"
  }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
}



# Route Table Association with Public Subnet 1
resource "aws_route_table_association" "public_1" {
  subnet_id      = aws_subnet.public-1.id
  route_table_id = aws_route_table.public.id
}

# Route Table Association with Public Subnet 2
resource "aws_route_table_association" "public_2" {
  subnet_id      = aws_subnet.public-2.id
  route_table_id = aws_route_table.public.id
}




# public route table 
# route table association with public subnet 
# routes for public subnet -> internet gateway

#Private Subnet -2

resource "aws_subnet" "private-1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "private-subnet-1"
  }
}

resource "aws_subnet" "private-2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.4.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "private-subnet-2"
  }
}



# Public Route Table
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "private-route-table"
  }
}

# Route Table Association with Private Subnet 1
resource "aws_route_table_association" "private_1" {
  subnet_id      = aws_subnet.private-1.id
  route_table_id = aws_route_table.private.id
}

# Route Table Association with Private Subnet 2
resource "aws_route_table_association" "private_2" {
  subnet_id      = aws_subnet.private-2.id
  route_table_id = aws_route_table.private.id
}



resource "aws_nat_gateway" "example" {
  allocation_id = data.aws_eip.by_allocation_id.id
  subnet_id     = aws_subnet.public-1.id

  tags = {
    Name = "gw NAT"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [
    aws_internet_gateway.main,
    aws_route_table.public
  ]
}

# we commented out below because we need to use NAT gateway for private subnet internet access
# Route for private subnets to NAT Gateway
resource "aws_route" "private_nat_route" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.example.id
}



# nat gateway in public subnet
# elastic ip for nat gateway

# rds private subnet group -2
resource "aws_subnet" "rds-1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.5.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "rds-subnet-1"
  }
}


resource "aws_subnet" "rds-2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.6.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "rds-subnet-2"
  }
}


# internet gateway 

# public route table

