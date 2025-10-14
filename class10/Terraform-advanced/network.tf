# VPC
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr


  tags = {
    # variable interpolation "${}-vpc" #dev-vpc, prod-vpc, staging-vpc
    Name    = "${var.environment}-vpc",
    project = var.project_name
  }

}


# Implicit dependency = aws_vpc.main.id



#Public Subnet -2
resource "aws_subnet" "public-1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.subnet_cidrs[0]
  availability_zone       = "${data.aws_region.current.name}a"
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.environment}-public-sub1"
  }
}

resource "aws_subnet" "public-2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnet_cidrs[1]
  availability_zone = "${data.aws_region.current.name}b"

  tags = {
    Name = "${var.environment}-public-sub2"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.environment}-igw"
  }
}

# Public Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.environment}-public-rt"
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
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnet_cidrs[2]
  availability_zone = "${data.aws_region.current.name}a"

  tags = {
    Name = "${var.environment}-private-sub1"
  }
}

resource "aws_subnet" "private-2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnet_cidrs[3]
  availability_zone = "${data.aws_region.current.name}b"

  tags = {
    Name = "${var.environment}-private-sub2"
  }
}



# Public Route Table
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.environment}-private-rt"
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





# elastic ip for nat gateway
resource "aws_eip" "nat" {

  tags = {
    Name = "${var.environment}-nat-eip"
  }

}

resource "aws_nat_gateway" "example" {
  #allocation_id = data.aws_eip.by_allocation_id.id before line since we introduce the code above we change to the code below
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public-1.id

  tags = {
    Name = "${var.environment}-NAT"
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


# rds private subnet group -2
resource "aws_subnet" "rds-1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnet_cidrs[4]
  availability_zone = "${data.aws_region.current.name}a"

  tags = {
    Name = "${var.environment}-rds-sub1"
  }
}


resource "aws_subnet" "rds-2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnet_cidrs[5]
  availability_zone = "${data.aws_region.current.name}b"

  tags = {
    Name = "${var.environment}-rds-sub2"
  }
}


# internet gateway 

# public route table

