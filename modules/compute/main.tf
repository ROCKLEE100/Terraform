
resource "google_service_account" "vm_service_account" {
  account_id   = "${var.project_prefix}-vm-sa"
  display_name = "Service Account for Compute VMs"
  description  = "Service account used by compute instances"
}



resource "google_compute_instance" "public_vm" {
  name         = "${var.project_prefix}-public-vm"
  machine_type = var.machine_type
  zone         = var.zone
  
  tags = ["public-vm", "web-server", "ssh-enabled"]
  
  boot_disk {
    initialize_params {
      image = var.vm_image
      size  = var.boot_disk_size
      type  = var.boot_disk_type
    }
  }
  
  
  network_interface {
    subnetwork = var.public_subnet_self_link
    
    
    access_config {
      
      network_tier = "PREMIUM"
    }
  }
  
  
  metadata = {
    ssh-keys               = "${var.ssh_username}:${var.ssh_public_key}"
    enable-oslogin         = "FALSE"
    block-project-ssh-keys = "FALSE"
  }
  
  
  metadata_startup_script = <<-EOF
    #!/bin/bash
    set -e
    
    # Update system
    apt-get update
    apt-get install -y nginx curl htop net-tools
    
    # Get instance metadata
    HOSTNAME=$(hostname)
    INTERNAL_IP=$(hostname -I | awk '{print $1}')
    ZONE=$(curl -s "http://metadata.google.internal/computeMetadata/v1/instance/zone" -H "Metadata-Flavor: Google" | awk -F'/' '{print $NF}')
    
    # Create custom NGINX index page
    cat > /var/www/html/index.html <<HTML
    <!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Public VM - NGINX Server</title>
        <style>
            * { margin: 0; padding: 0; box-sizing: border-box; }
            body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                min-height: 100vh;
                display: flex;
                align-items: center;
                justify-content: center;
                padding: 20px;
            }
            .container {
                background: white;
                padding: 40px;
                border-radius: 20px;
                box-shadow: 0 20px 60px rgba(0,0,0,0.3);
                max-width: 600px;
                width: 100%;
            }
            h1 {
                color: #667eea;
                margin-bottom: 20px;
                font-size: 2.5em;
                text-align: center;
            }
            .info-box {
                background: #f7fafc;
                padding: 20px;
                border-radius: 10px;
                margin: 15px 0;
                border-left: 4px solid #667eea;
            }
            .info-label {
                font-weight: bold;
                color: #4a5568;
                margin-bottom: 5px;
            }
            .info-value {
                color: #2d3748;
                font-family: 'Courier New', monospace;
                word-break: break-all;
            }
            .status {
                text-align: center;
                color: #48bb78;
                font-size: 1.2em;
                margin-top: 20px;
                padding: 15px;
                background: #f0fff4;
                border-radius: 10px;
            }
            .footer {
                text-align: center;
                margin-top: 30px;
                color: #718096;
                font-size: 0.9em;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <h1>🚀 Public VM</h1>
            
            <div class="info-box">
                <div class="info-label">Hostname:</div>
                <div class="info-value">$HOSTNAME</div>
            </div>
            
            <div class="info-box">
                <div class="info-label">Internal IP:</div>
                <div class="info-value">$INTERNAL_IP</div>
            </div>
            
            <div class="info-box">
                <div class="info-label">Zone:</div>
                <div class="info-value">$ZONE</div>
            </div>
            
            <div class="info-box">
                <div class="info-label">Server:</div>
                <div class="info-value">NGINX (Public Subnet)</div>
            </div>
            
            <div class="info-box">
                <div class="info-label">Deployment Time:</div>
                <div class="info-value">$(date)</div>
            </div>
            
            <div class="status">
                ✅ NGINX Server Running Successfully
            </div>
            
            <div class="footer">
                Deployed with Terraform | GCP Infrastructure
            </div>
        </div>
    </body>
    </html>
    HTML
    
    # Configure NGINX
    systemctl enable nginx
    systemctl restart nginx
    
    # Log successful deployment
    echo "Public VM setup completed at $(date)" >> /var/log/startup-script.log
  EOF
  
  service_account {
    email  = google_service_account.vm_service_account.email
    scopes = ["cloud-platform"]
  }
  
  labels = merge(
    var.labels,
    {
      vm_type = "public"
      role    = "web-server"
    }
  )
  
  allow_stopping_for_update = true
}



resource "google_compute_instance" "private_vm" {
  name         = "${var.project_prefix}-private-vm"
  machine_type = var.machine_type
  zone         = var.zone
  
  tags = ["private-vm", "ssh-enabled"]
  
  boot_disk {
    initialize_params {
      image = var.vm_image
      size  = var.boot_disk_size
      type  = var.boot_disk_type
    }
  }
  
  
  network_interface {
    subnetwork = var.private_subnet_self_link
    
  }
  

  metadata = {
    ssh-keys               = "${var.ssh_username}:${var.ssh_public_key}"
    enable-oslogin         = "FALSE"
    block-project-ssh-keys = "FALSE"
  }
  
  
  metadata_startup_script = <<-EOF
    #!/bin/bash
    set -e
    
    # Update system
    apt-get update
    apt-get install -y curl htop net-tools dnsutils
    
    # Get instance metadata
    HOSTNAME=$(hostname)
    INTERNAL_IP=$(hostname -I | awk '{print $1}')
    ZONE=$(curl -s "http://metadata.google.internal/computeMetadata/v1/instance/zone" -H "Metadata-Flavor: Google" | awk -F'/' '{print $NF}')
    
    # Create info file
    cat > /tmp/vm-info.txt <<INFO
    ========================================
    PRIVATE VM INFORMATION
    ========================================
    Hostname: $HOSTNAME
    Internal IP: $INTERNAL_IP
    Zone: $ZONE
    Subnet: Private (No External IP)
    Internet Access: Via Cloud NAT (outbound only)
    Deployment Time: $(date)
    ========================================
    INFO
    
    # Test outbound internet connectivity
    if curl -s --max-time 10 https://www.google.com > /dev/null; then
        echo "✅ Internet connectivity: OK (via Cloud NAT)" >> /tmp/vm-info.txt
    else
        echo "❌ Internet connectivity: FAILED" >> /tmp/vm-info.txt
    fi
    
    # Log successful deployment
    echo "Private VM setup completed at $(date)" >> /var/log/startup-script.log
    
    # Display info on login
    cat >> /etc/profile.d/vm-info.sh <<'PROFILE'
    if [ -f /tmp/vm-info.txt ]; then
        cat /tmp/vm-info.txt
    fi
    PROFILE
  EOF
  
  service_account {
    email  = google_service_account.vm_service_account.email
    scopes = ["cloud-platform"]
  }
  
  labels = merge(
    var.labels,
    {
      vm_type = "private"
      role    = "backend"
    }
  )
  
  allow_stopping_for_update = true
}