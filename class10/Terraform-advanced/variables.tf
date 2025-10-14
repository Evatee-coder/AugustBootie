# To make our Terraform configuration more dynamic, flexible and reusable, we can define variables.

variable "environment" {
  description = "The deployment environment (e.g., dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "project_name" {
  description = "The name of the project"
  type        = string
  default     = "augustbootie-studentportal"
}

variable "app" {
  description = "The name of the application"
  type        = string
  default     = "studentportal"
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_cidrs" {
  description = "A list of CIDR blocks for the subnets"
  type        = list(string)
  default = [
    "10.0.1.0/24",
    "10.0.2.0/24",
    "10.0.3.0/24",
    "10.0.4.0/24",
    "10.0.5.0/24",
    "10.0.6.0/24"
  ]

}


variable "rds_defaults" {
  description = "Default settings for RDS instance"
  type        = map(string)
  default = {
    allocated_storage     = "30"
    max_allocated_storage = "50"
    engine                = "postgres"
    engine_version        = "14.15"
    instance_class        = "db.t3.micro"
    username              = "postgres"
  }

}

variable "ecs-app-values" {
  description = "Environment variables for the ECS application"
  type        = map(string)
  default = {
    container_name = "studentportal"
    container_port = "8000"
    cpu            = "256"
    memory         = "512"
    DESIRED_COUNT  = "1"
    launch_type    = "FARGATE"
    protocol       = "HTTP"
    domain_name    = "eva-tee.com"
    subdomain_name = "studentportal"

  }
}