packer {
  required_version = ">= 1.7.0"
}

source "virtualbox-iso" "ubuntu" {
  iso_url      = "https://releases.ubuntu.com/20.04/ubuntu-20.04-live-server-amd64.iso"

  # CHECKSUM OBLIGATOIRE
  iso_checksum = "sha256:93bdab204067321ff131f560879db46bee3b994bf24836bb78538640f689e58f"

  ssh_username     = "vagrant"
  ssh_password     = "vagrant"
  ssh_wait_timeout = "20m"

  shutdown_command = "echo 'vagrant' | sudo -S shutdown -P now"
}

build {
  name    = "vagrant-box"
  sources = ["source.virtualbox-iso.ubuntu"]

  post-processor "vagrant" {
    output = "builds/ubuntu-20.04.box"
  }
}
