variable "key_name" {
  description = "Name of keypair to ssh"
  default     = "key"
}
variable "cidr_block_vpc" {
  description = "CIDR Block for VPC"
  default     = "10.0.0.0/16"
}
variable "cidr_block_public" {
  description = "CIDR Block for Public Subnet 1"
  default     = "10.0.1.0/24"
}
variable "cidr_block_public2" {
  description = "CIDR Block for Public Subnet 2"
  default     = "10.0.100.0/24"
}
variable "cidr_block_private" {
  description = "CIDR Block for Private Subnet 1"
  default     = "10.0.3.0/24"
}
variable "cidr_block_private2" {
  description = "CIDR Block for Private Subnet 2"
  default     = "10.0.200.0/24"
}
variable "cidr_block" {
  description = "CIDR Block for Access from and to Internet"
  default     = "0.0.0.0/0"
}
variable "AvailabilityZone" {
  default = "eu-central-1a"
}
variable "AvailabilityZone2" {
  default = "eu-central-1b"
}