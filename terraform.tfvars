# Connection Variables
## username & password are set as environment variables
# nutanix_username     = "admin"
# nutanix_password     = "Nutanix/123456"
nutanix_endpoint     = "nutanix.example.com"
nutanix_port         = 9440
nutanix_insecure     = true
nutanix_wait_timeout = 10

# Virtual Machine Variables
vm_name              = "testvm1"
os                   = "2022"
subnet_name          = "network-1"

# Windows Guest Variables
## these variables can be set as environment variables eg:
## PS> $ENV:TF_VAR_domain_pw = "p@ssword"
## $ TF_VAR_domain_pw = "p@ssword"

timezone             = "GMT Standard Time"
# admin_password       = "p@ssw0rd"
domain               = "example.local"
domain_user          = "administrator"
# domain_pw            = "p@ssw0rd"
ou_path              = "OU=Servers,DC=example,DC=local"
first_run_script_uri = "http://webserver.example.com/scripts/runonce.ps1"