terraform {
  required_providers {
    ad = {
      source = "hashicorp/ad"
      version = "0.5.0"
    }
  }
}

provider "ad" {
        winrm_hostname         = "192.168.10.10"
        winrm_username         = "Administrator"
        winrm_password         = "P@$$w0rd"
        #krb_realm              = "ahmed.it"
        #winrm_pass_credentials = true
      }
#resource "null_resource" "create_ou" {
#  provisioner "local-exec" {
#    command = <<-EOT
#      powershell.exe -Command "New-ADOrganizationalUnit -Name 'gplinktestOU' -Path 'DC=ahmed,DC=it' -Description 'OU for gplink tests' -ProtectedFromAccidentalDeletion $false"
#    EOT
#  }
#}

#resource "ad_ou" "o" { 
#    name = "gplinktestOU"
#    path = "dc=yourdomain,dc=com"
#    description = "OU for gplink tests"
#    protected = false
#}