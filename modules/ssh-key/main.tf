

resource "tls_private_key" "vm_ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}


resource "google_secret_manager_secret" "ssh_private_key" {
  secret_id = "${var.project_prefix}-ssh-private-key"
  
  replication {
    auto {}
  }
  
  labels = var.labels
}


resource "google_secret_manager_secret_version" "ssh_private_key_version" {
  secret      = google_secret_manager_secret.ssh_private_key.id
  secret_data = tls_private_key.vm_ssh_key.private_key_pem
}

resource "google_secret_manager_secret" "ssh_public_key" {
  secret_id = "${var.project_prefix}-ssh-public-key"
  
  replication {
    auto {}
  }
  
  labels = var.labels
}


resource "google_secret_manager_secret_version" "ssh_public_key_version" {
  secret      = google_secret_manager_secret.ssh_public_key.id
  secret_data = tls_private_key.vm_ssh_key.public_key_openssh
}

resource "local_file" "ssh_directory" {
  content  = "SSH Keys Directory"
  filename = "${path.root}/ssh-keys/.keep"
}


resource "local_file" "private_key" {
  content         = tls_private_key.vm_ssh_key.private_key_pem
  filename        = "${path.root}/ssh-keys/id_rsa"
  file_permission = "0600"
  
  depends_on = [local_file.ssh_directory]
}


resource "local_file" "public_key" {
  content         = tls_private_key.vm_ssh_key.public_key_openssh
  filename        = "${path.root}/ssh-keys/id_rsa.pub"
  file_permission = "0644"
  
  depends_on = [local_file.ssh_directory]
}