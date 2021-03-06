variable "region-master" {
  type    = string
  default = "eu-west-2"
}

variable "project" {
  type        = map(string)
  description = "name of the project for consistent naming"
}

variable "instance-type" {
  type        = map(string)
  description = "The instance type that we will use"
}