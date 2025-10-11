variable "name_prefix"       { type = string }
variable "vpc_id"            { type = string }
variable "database_subnets"  { type = list(string) }
variable "eks_node_sg_id"    { type = string }

variable "engine_version"    {
    type = string
    default = "5.0.0"
}
variable "instance_class"    {
    type = string
    default = "db.t3.medium"
}
variable "instances"         {
    type = number
    default = 1
}

variable "master_username" {
  description = "Master username for the DocDB cluster"
  type        = string
  default     = "docdb_admin"
}

variable "port" {
  description = "DocDB port"
  type        = number
  default     = 27017
}