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
        winrm_port             = 5986
        winrm_proto            = "http"
        winrm_pass_credentials = true
}
#resource "null_resource" "create_ou" {
#  provisioner "local-exec" {
#    command = <<-EOT
#      powershell.exe -Command "New-ADOrganizationalUnit -Name 'gplinktestOU' -Path 'DC=ahmed,DC=it' -Description 'OU for gplink tests' -ProtectedFromAccidentalDeletion $false"
#    EOT
#  }
#}

resource "ad_user" "new_user" {
  principal_name            = "terraform"
  sam_account_name          = "terraform"
  display_name              = "Terraform Test User"
  container                 = "CN=Users,DC=ahmed,DC=it"
  initial_password          = "Password"
  city                      = "City"
  company                   = "Company"
  country                   = "us"
  department                = "Department"
  description               = "Description"
  division                  = "Division"
  email_address             = "some@email.com"
  employee_id               = "id"
  employee_number           = "number"
  fax                       = "Fax"
  given_name                = "GivenName"
  home_directory            = "HomeDirectory"
  home_drive                = "HomeDrive"
  home_phone                = "HomePhone"
  home_page                 = "HomePage"
  initials                  = "Initia"
  mobile_phone              = "MobilePhone"
  office                    = "Office"
  office_phone              = "OfficePhone"
  organization              = "Organization"
  other_name                = "OtherName"
  po_box                    = "POBox"
  postal_code               = "PostalCode"
  state                     = "State"
  street_address            = "StreetAddress"
  surname                   = "Surname"
  title                     = "Title"
  smart_card_logon_required = false
  trusted_for_delegation    = true
}