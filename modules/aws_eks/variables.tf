variable "stack" {
  description = "The stack name for this build"
  default     = "dev"
}

variable "env" {
  description = "The environment name this account lives in"
}

variable "azs" {
  description = "The number of AZs to be in"
  default     = 3
}

variable "env_tags" {
  description = "Environment tags to include for cost analysis"
  type        = "map"
}

variable "vpc_id" {
  description = "The VPC ID to use"
}

variable "worker_node_instance_type" {
  description = "The worker node instance type"
  default     = "m5.xlarge"
}

variable "role_admin" {
  description = "Role admin that is used by worker nodes"
  default     = "OktaAdmin"
}

variable "kubernetes_version" {
  description = "Kubernetes cluster version"
  default     = "1.12"
}

variable "root_volume_size" {
  description = "root volume size"
  default     = "500"
}

variable "asg_min_size" {
  description = "Autoscaling min size"
  default     = "2"
}

variable "asg_desired_capacity" {
  description = "Autoscaling desired capacity to increase or decrease the number of instances in ASG dynamically to meet changing scaling policy"
  default     = "2"
}

variable "asg_max_size" {
  description = "Max number of worker nodes"
  default     = "30"
}
