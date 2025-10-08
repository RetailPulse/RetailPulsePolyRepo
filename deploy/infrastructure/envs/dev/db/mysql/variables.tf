variable "name_prefix"       { type = string }
variable "vpc_id"            { type = string }
variable "database_subnets"  { type = list(string) }
variable "eks_node_sg_id"    { type = string }

# Sizing / options
variable "instance_class"    {
    type = string
    default = "db.t3.medium"
}
variable "allocated_storage" {
    type = number
    default = 20
}
variable "multi_az"          {
    type = bool
    default = false
}