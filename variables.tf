# Connection Variables
variable "nutanix_endpoint" { type = string }
variable "nutanix_port" { type = string }
variable "nutanix_insecure" { type = bool }
variable "nutanix_wait_timeout" { type = number }

# VM Variables
variable "subnet_name" { type = string }
variable "vm_name" { type = string }
variable "os" { type = string }

# Windows Variables
variable "timezone" { type = string }
variable "admin_password" { type = string }
variable "domain" { type = string }
variable "domain_shortname" { type = string }
variable "domain_user" { type = string }
variable "domain_pw" { type = string }
variable "ou_path" { type = string }
variable "first_run_script_uri" { type = string }