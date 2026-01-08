packer {
  required_plugins {
    vagrant = {
      version = "~> 1"
      source  = "github.com/hashicorp/vagrant"
    }
    virtualbox = {
      version = "~> 1"
      source  = "github.com/hashicorp/virtualbox"
    }
  }
}

variable "box_version" {
  type    = string
  default = "1.0.0"
}

variable "vagrant_cloud_token" {
  type      = string
  default   = env("VAGRANT_CLOUD_TOKEN")
  sensitive = true
}

source "virtualbox-iso" "ubuntu" {
  guest_os_type    = "Ubuntu_64"
  iso_url          = "https://releases.ubuntu.com/22.04/ubuntu-22.04.3-live-server-amd64.iso"
  iso_checksum     = "sha256:a4acfda10b18da50e2ec50ccaf860d7f20b389df8765611142305c0e911d16fd"
  ssh_username     = "vagrant"
  ssh_password     = "vagrant"
  ssh_timeout      = "20m"
  shutdown_command = "echo 'vagrant' | sudo -S shutdown -P now"
  
  vboxmanage = [
    ["modifyvm", "{{.Name}}", "--memory", "2048"],
    ["modifyvm", "{{.Name}}", "--cpus", "2"]
  ]
}

build {
  sources = ["source.virtualbox-iso.ubuntu"]

  provisioner "shell" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y build-essential"
    ]
  }

  post-processor "vagrant" {
    output = "output/package.box"
  }
}