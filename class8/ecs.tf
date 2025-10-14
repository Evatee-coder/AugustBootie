# ECS cluster
resource "aws_ecs_cluster" "ecs" {
  name = "august-ecs-cluster"
}

# Task definition
resource "aws_ecs_task_definition" "ecs" {
  #checkov:skip=CKV_AWS_336: The ECS task needs write access to system
  family     = "august-task-def"
  container_definitions = jsonencode(
    [
      {
        "name" : "august-container",
        "image" : "216989097838.dkr.ecr.us-east-1.amazonaws.com/student-portal-main-repo:1.0",
        "portMappings" = [
        {
          "containerPort" = 8000
          "hostPort"      = 8000
        }
        ],
        "essential" : true,
        "logConfiguration" : {
          "logDriver" : "awslogs",
          "options" : {
            "awslogs-group" : aws_cloudwatch_log_group.ecs.name,
            "awslogs-region" : data.aws_region.current.name,
            "awslogs-stream-prefix" : "ecs"
          },
        },
        "environment" : [
          {
            "name" : "DB_LINK",
            "value" : "postgresql://${aws_db_instance.postgres.username}:${random_password.dbs_random_string.result}@${aws_db_instance.postgres.address}:${aws_db_instance.postgres.port}/${aws_db_instance.postgres.db_name}"
          },
    
        ]
      }
  ])

  cpu = 256
  # role for task to pull the ecr image
  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn
  memory             = 512
  network_mode       = "awsvpc"
  requires_compatibilities = [
    "FARGATE",
  ]

}

# ECS service
resource "aws_ecs_service" "ecs" {
  name                       = "august-service"
  cluster                    = aws_ecs_cluster.ecs.id   #mapping to the cluster created above
  task_definition            = aws_ecs_task_definition.ecs.arn #mapping to the task definition
  desired_count              = 2
  deployment_maximum_percent = 250 # 
  launch_type                = "FARGATE"

  network_configuration {
    security_groups  = [aws_security_group.ecs_service_sg.id]
    subnets          = [aws_subnet.private-1.id, aws_subnet.private-2.id] #from private subnets created in other file.
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.alb.arn
    container_name   = "august-container"   #must be the same as in task definition
    container_port   = 8000
  }

  depends_on = [
    aws_iam_role.ecs_task_execution_role,
  ]

}

# ECS security group (inbound port 8000 from ALB SG only)

resource "aws_security_group" "ecs_service_sg" {
  name        = "ecs-service-sg"
  description = "Allow inbound 8000 from ALB SG only"
  vpc_id      = aws_vpc.main.id

  ingress {
    description     = "Allow ALB to access ECS on port 8000"
    from_port       = 8000
    to_port         = 8000
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]  # only from LB

  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ecs-service-sg"
  }
}