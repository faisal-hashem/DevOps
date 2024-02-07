locals {
  extra_vars_string = length(var.ansible_extra_vars) > 0 ? join(" ", formatlist("%s='%s'", keys(var.ansible_extra_vars), values(var.ansible_extra_vars))) : ""
}

#This adds the Ansible Control Nodes Public SSH Key to the Azure VM we are running a Ansible Playbook against
#Needed for connectivity from Ansible Control Node to VMs

resource "null_resource" "add_ssh_key" {

  triggers = {
    instance_id = var.vm_id
  }

  provisioner "remote-exec" {
    inline = [
      "echo '${var.ansible_key}' >> ~/.ssh/authorized_keys"
    ]

    connection {
      type        = "ssh"
      host        = var.vmprivateip
      user        = var.adminuser
      password    = var.adminpassword
      agent       = false
    }
  }
}


#Establishes connectivity with Anisble Control Node via Bossaccount from Build Agent and runs Ansible-Playbook command against the VM we are deploying to
#SSH Key from previous resource is needed to perform this task
#Temp_vault_pass is the password to access the Ansible Vault. Just incase we need to call out any passwords directly from Ansible Vault to Ansible Playbooks

resource "null_resource" "ansible_run" {
  depends_on = [null_resource.add_ssh_key]

  triggers = {
    instance_id = var.vm_id
    name = var.playbook_file
  }

  connection {
    type        = "ssh"
    host        = var.ansible_control_ip
    user        = var.adminuser
    password    = var.adminpassword
    agent       = false
  }

  provisioner "remote-exec" {
    inline = [
      "echo '${var.adminpassword}' > ~/temp_vault_pass.txt",
      "ansible-playbook ~/ansible/playbooks/Install/${var.playbook_file} -i ${var.vmprivateip},${local.extra_vars_string != "" ? " -e '${local.extra_vars_string}'" : ""} --vault-password-file ~/temp_vault_pass.txt",
      "rm -f ~/temp_vault_pass.txt"
    ]
  }

}