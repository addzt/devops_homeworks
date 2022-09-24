# CREATE INVENTORY.INI FILE

resource "local_file" "inventory" {

  content = <<-DOC

    [nginx]
    addzt.ru ansible_host=${yandex_compute_instance.virtual_machine-1.network_interface.0.nat_ip_address}

    [db01]
    db01.addzt.ru ansible_host=${yandex_compute_instance.virtual_machine-2[0].network_interface.0.ip_address} mysql_replication_role=master

    [db02]
    db02.addzt.ru ansible_host=${yandex_compute_instance.virtual_machine-2[1].network_interface.0.ip_address} mysql_replication_role=slave

    [wordpress]
    app.addzt.ru ansible_host=${yandex_compute_instance.virtual_machine-2[2].network_interface.0.ip_address}

    [gitlab]
    gitlab.addzt.ru ansible_host=${yandex_compute_instance.virtual_machine-2[3].network_interface.0.ip_address}

    [runner]
    runner.addzt.ru ansible_host=${yandex_compute_instance.virtual_machine-2[4].network_interface.0.ip_address}

    [monitoring]
    monitoring.addzt.ru ansible_host=${yandex_compute_instance.virtual_machine-2[5].network_interface.0.ip_address}

    [all:children]
    nginx
    db01
    db02
    wordpress
    gitlab
    runner
    monitoring

    [db:children]
    db01
    db02

    [node_exporter:children]
    nginx
    db01
    db02
    wordpress
    runner
    monitoring

    [all:vars]
    domain_name             = ${var.domain_name}
    ip_nginx                = ${yandex_compute_instance.virtual_machine-1.network_interface.0.ip_address}
    ip_db1                  = ${yandex_compute_instance.virtual_machine-2[0].network_interface.0.ip_address}
    ip_db02                 = ${yandex_compute_instance.virtual_machine-2[1].network_interface.0.ip_address}
    ip_wordpress            = ${yandex_compute_instance.virtual_machine-2[2].network_interface.0.ip_address}
    ip_gitlab               = ${yandex_compute_instance.virtual_machine-2[3].network_interface.0.ip_address}
    ip_runner               = ${yandex_compute_instance.virtual_machine-2[4].network_interface.0.ip_address}
    ip_monitoring           = ${yandex_compute_instance.virtual_machine-2[5].network_interface.0.ip_address}

    [nginx:vars]
    letsencrypt_email               = ${var.default_email}

    [db:vars]
    db_name                         = ${var.db_name}
    db_user                         = ${var.db_user}
    db_password                     = ${var.db_password}
    mysql_replication_master        = db01.addzt.ru
    mysql_replication_user          = replication_user
    mysql_replication_user_password = "replication_user"

    [db01:vars]
    ansible_ssh_common_args = '-o StrictHostKeyChecking=no -o ProxyCommand="ssh -W %h:%p -q ubuntu@${yandex_compute_instance.virtual_machine-1.network_interface.0.nat_ip_address}"'

    [db02:vars]
    ansible_ssh_common_args = '-o StrictHostKeyChecking=no -o ProxyCommand="ssh -W %h:%p -q ubuntu@${yandex_compute_instance.virtual_machine-1.network_interface.0.nat_ip_address}"'

    [wordpress:vars]
    ansible_ssh_common_args = '-o StrictHostKeyChecking=no -o ProxyCommand="ssh -W %h:%p -q ubuntu@${yandex_compute_instance.virtual_machine-1.network_interface.0.nat_ip_address}"'

    [gitlab:vars]
    ansible_ssh_common_args = '-o StrictHostKeyChecking=no -o ProxyCommand="ssh -W %h:%p -q ubuntu@${yandex_compute_instance.virtual_machine-1.network_interface.0.nat_ip_address}"'

    [runner:vars]
    ansible_ssh_common_args = '-o StrictHostKeyChecking=no -o ProxyCommand="ssh -W %h:%p -q ubuntu@${yandex_compute_instance.virtual_machine-1.network_interface.0.nat_ip_address}"'

    [monitoring:vars]
    ansible_ssh_common_args = '-o StrictHostKeyChecking=no -o ProxyCommand="ssh -W %h:%p -q ubuntu@${yandex_compute_instance.virtual_machine-1.network_interface.0.nat_ip_address}"'

    DOC

  filename = "../ansible/inventory.ini"

  depends_on = [
                yandex_compute_instance.virtual_machine-1,
                yandex_compute_instance.virtual_machine-2[1],
                yandex_compute_instance.virtual_machine-2[2],
                yandex_compute_instance.virtual_machine-2[3],
                yandex_compute_instance.virtual_machine-2[4],
                yandex_compute_instance.virtual_machine-2[5],
                yandex_compute_instance.virtual_machine-2[6]
    ]
}