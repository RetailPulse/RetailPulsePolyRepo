variable "name_prefix" {
  type        = string
  description = "Prefix for naming resources"
}

variable "project" {
  type        = string
  description = "Project name for tagging"
}

variable "env" {
  type        = string
  description = "Environment name (e.g., dev, prod)"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID where the VPC Link will be created"
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "Private subnet IDs for the VPC Link"
}

variable "alb_sg_id" {
  type        = string
  description = "Security group ID for the ALB"
}

variable "services" {
  type = list(object({
    name         = string
    path_prefix  = string
    listener_arn = string
  }))
  description = "List of microservices with path prefixes and ALB listener ARNs"
}

locals {
  service_map = { for svc in var.services : svc.name => svc }
}

resource "aws_apigatewayv2_api" "multi_service_api" {
  name          = "${var.name_prefix}-api"
  protocol_type = "HTTP"

  cors_configuration {
    allow_origins = ["https://app.retailpulse.dev"]
    allow_methods = ["GET", "POST", "OPTIONS", "PUT", "DELETE"]
    allow_headers = ["Authorization", "Content-Type"]
  }

  tags = {
    Project = var.project
    Env     = var.env
  }
}

resource "aws_apigatewayv2_vpc_link" "vpc_link" {
  name               = "${var.name_prefix}-vpc-link"
  security_group_ids = [var.alb_sg_id]
  subnet_ids         = var.private_subnet_ids
}

resource "aws_apigatewayv2_integration" "service" {
  for_each = local.service_map

  api_id             = aws_apigatewayv2_api.multi_service_api.id
  integration_type   = "HTTP_PROXY"
  integration_method = "ANY"
  integration_uri    = each.value.listener_arn
  connection_type    = "VPC_LINK"
  connection_id      = aws_apigatewayv2_vpc_link.vpc_link.id
}

resource "aws_apigatewayv2_route" "service" {
  for_each = local.service_map

  api_id    = aws_apigatewayv2_api.multi_service_api.id
  route_key = "ANY ${each.value.path_prefix}/{proxy+}"
  target    = "integrations/${aws_apigatewayv2_integration.service[each.key].id}"
}

resource "aws_apigatewayv2_stage" "prod" {
  api_id      = aws_apigatewayv2_api.multi_service_api.id
  name        = "prod"
  auto_deploy = true

  tags = {
    Project = var.project
    Env     = var.env
  }
}

output "api_base_url" {
  description = "Base URL for API Gateway"
  value       = "${aws_apigatewayv2_api.multi_service_api.api_endpoint}/prod"
}
