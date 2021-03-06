terraform {
  backend "s3" {
    bucket                      = "avans-terraform-state"
    key                         = "avans-terraform.tfstate"
    access_key                  = "__doAccessKey__"
    secret_key                  = "__doSecretKey__"
    endpoint                    = "https://ams3.digitaloceanspaces.com"
    region                      = "eu-west-1"
    skip_credentials_validation = true
    skip_metadata_api_check     = true
  }

  required_providers {
    digitalocean = {
      source = "terraform-providers/digitalocean"
    }
  }
  required_version = ">= 0.13"
}
