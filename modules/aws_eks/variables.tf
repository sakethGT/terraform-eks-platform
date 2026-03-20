variable "stack" {
  description = "The stack name for this build"
  type        = string
  default     = "dev"
}

variable "env" {
  description = "The environment name this account lives in"
  type        = string
}

variable "azs" {
  description = "The number of AZs to be in"
  type        = number
  default     = 3
}

variable "env_tags" {
  description = "Environment tags to include for cost analysis"
  type        = map(string)
}

variable "vpc_id" {
  description = "The VPC ID to use"
  type        = string
}

variable "worker_node_instance_type" {
  description = "The worker node instance type"
  type        = string
  default     = "m5.xlarge"
}

variable "role_admin" {
  description = "Role admin that is used by worker nodes"
  type        = string
  default     = "AdminRole"
}

variable "kubernetes_version" {
  description = "Kubernetes cluster version"
  type        = string
  default     = "1.28"
}

variable "root_volume_size" {
  description = "root volume size"
  type        = string
  default     = "500"
}

variable "asg_min_size" {
  description = "Autoscaling min size"
  type        = string
  default     = "2"
}

variable "asg_desired_capacity" {
  description = "Autoscaling desired capacity to increase or decrease the number of instances in ASG dynamically to meet changing scaling policy"
  type        = string
  default     = "2"
}

variable "asg_max_size" {
  description = "Max number of worker nodes"
  type        = string
  default     = "30"
}
