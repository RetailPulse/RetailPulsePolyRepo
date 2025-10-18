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


# Allow selecting the ALB by exact name or by ARN (one of them must be provided)
variable "alb_name" {
  type        = string
  description = "Exact name of the ALB (e.g., k8s-retailpulseapi-26d97fdd85 or a stable name if set via Ingress annotation). Leave empty if using alb_arn."
  default     = ""
}

variable "alb_arn" {
  type        = string
  description = "ARN of the ALB. Leave empty if using alb_name."
  default     = ""
}

locals {
  use_alb_arn = length(var.alb_arn) > 0
}

# Lookup by name (when alb_arn is not set)
data "aws_lb" "by_name" {
  count = local.use_alb_arn ? 0 : 1
  name  = var.alb_name
}

# Lookup by ARN (when provided)
data "aws_lb" "by_arn" {
  count = local.use_alb_arn ? 1 : 0
  arn   = var.alb_arn
}

# Unified ALB ARN reference
locals {
  lb_arn = local.use_alb_arn ? data.aws_lb.by_arn[0].arn : data.aws_lb.by_name[0].arn
}

# Listener discovery now uses the resolved ALB ARN
data "aws_lb_listener" "https" {
  load_balancer_arn = local.lb_arn
  port              = 443
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
  integration_uri    = data.aws_lb_listener.https.arn
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
