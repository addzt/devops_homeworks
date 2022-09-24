# USE ANSIBLE VIA TERRAFORM

resource "null_resource" "sleep" {
  provisioner "local-exec" {
    command  = "sleep 20"
  }
  depends_on = [local_file.inventory]
}

resource "null_resource" "nginx" {
  provisioner "local-exec" {
    command  = "ansible-playbook -i ../ansible/inventory.ini ../ansible/nginx/nginx.yml"
  }
  depends_on = [null_resource.sleep]
}

resource "null_resource" "db" {
  provisioner "local-exec" {
    command  = "ansible-playbook -i ../ansible/inventory.ini ../ansible/db/db.yml"
  }
  depends_on = [null_resource.nginx]
}

resource "null_resource" "wordpress" {
  provisioner "local-exec" {
    command  = "ansible-playbook -i ../ansible/inventory.ini ../ansible/wordpress/wordpress.yml"
  }
  depends_on = [null_resource.db]
}

resource "null_resource" "gitlab" {
  provisioner "local-exec" {
    command = "ansible-playbook -i ../ansible/inventory.ini ../ansible/gitlab/gitlab.yml"
  }
  depends_on = [null_resource.wordpress]
}

resource "null_resource" "runner" {
  provisioner "local-exec" {
    command  = "ansible-playbook -i ../ansible/inventory.ini ../ansible/runner/runner.yml"
  }
  depends_on = [null_resource.gitlab]
}

resource "null_resource" "node_exporter" {
  provisioner "local-exec" {
    command  = "ansible-playbook -i ../ansible/inventory.ini ../ansible/node_exporter/node_exporter.yml"
  }
  depends_on = [null_resource.runner]
}

resource "null_resource" "monitoring" {
  provisioner "local-exec" {
    command  = "ansible-playbook -i ../ansible/inventory.ini ../ansible/monitoring/monitoring.yml"
  }
  depends_on = [null_resource.node_exporter]
}
