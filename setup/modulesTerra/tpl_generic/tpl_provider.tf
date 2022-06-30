variable "vsphere_server" {
  description     = "You need to export TF_VAR_vsphere_server. Same for other vars"
  type            = string
}

variable "provider_user"      {}
variable "provider_password"  {}

provider "vsphere" {
  vsphere_server        = var.vsphere_server
  user                  = var.provider_user
  password              = var.provider_password
  allow_unverified_ssl  = true
}
