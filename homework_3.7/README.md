# Домашнее задание к занятию "3.7. Компьютерные сети, лекция 2"

### 1. Проверьте список доступных сетевых интерфейсов на вашем компьютере. Какие команды есть для этого в Linux и в Windows?

**Windows:**

- `ipconfig /all`

```bash
C:\Users\Xiaomi Air>ipconfig /all

Настройка протокола IP для Windows

   Имя компьютера  . . . . . . . . . : DESKTOP-1BBATRT
   Основной DNS-суффикс  . . . . . . :
   Тип узла. . . . . . . . . . . . . : Гибридный
   IP-маршрутизация включена . . . . : Нет
   WINS-прокси включен . . . . . . . : Нет

Адаптер Ethernet VirtualBox Host-Only Network:

   DNS-суффикс подключения . . . . . :
   Описание. . . . . . . . . . . . . : VirtualBox Host-Only Ethernet Adapter #2
   Физический адрес. . . . . . . . . : 0A-00-27-00-00-16
   DHCP включен. . . . . . . . . . . : Нет
   Автонастройка включена. . . . . . : Да
   Локальный IPv6-адрес канала . . . : fe80::3df4:f52f:6e79:318d%22(Основной)
   IPv4-адрес. . . . . . . . . . . . : 192.168.56.1(Основной)
   Маска подсети . . . . . . . . . . : 255.255.255.0
   Основной шлюз. . . . . . . . . :
   IAID DHCPv6 . . . . . . . . . . . : 638189607
   DUID клиента DHCPv6 . . . . . . . : 00-01-00-01-25-A5-17-21-DC-FB-48-3F-C1-54
   DNS-серверы. . . . . . . . . . . : fec0:0:0:ffff::1%1
                                       fec0:0:0:ffff::2%1
                                       fec0:0:0:ffff::3%1
   NetBios через TCP/IP. . . . . . . . : Включен
```

- `netsh interface show interface`

```bash
C:\Users\Xiaomi Air>netsh interface show interface

Состояние адм.  Состояние     Тип              Имя интерфейса
---------------------------------------------------------------------
Разрешен       Подключен      Выделенный       VirtualBox Host-Only Network
Разрешен       Подключен      Выделенный       Ethernet 2
Разрешен       Подключен      Выделенный       Ethernet 3
Разрешен       Подключен      Выделенный       Ethernet 4
Разрешен       Подключен      Выделенный       Ethernet 5
Разрешен       Подключен      Выделенный       Беспроводная сеть
Запрещен       Отключен       Выделенный       vEthernet (Default Switch)
```

- `netsh interface ip show interfaces`

```bash
C:\Users\Xiaomi Air>netsh interface ip show interfaces

Инд     Мет         MTU          Состояние               Имя
---  ----------  ----------  ------------  ---------------------------
  1          75  4294967295  connected     Loopback Pseudo-Interface 1
 11          50        1500  connected     Беспроводная сеть
 20          25        1500  disconnected  Подключение по локальной сети* 9
 12          25        1500  disconnected  Подключение по локальной сети* 10
 22          25        1500  connected     VirtualBox Host-Only Network
 18          25        1500  connected     Ethernet 2
 25          25        1500  connected     Ethernet 3
 13          25        1500  connected     Ethernet 4
  4          25        1500  connected     Ethernet 5
```

- `wmic nic get NetConnectionID`

```bash
NetConnectionID
Беспроводная сеть
VirtualBox Host-Only Network
Ethernet 2
vEthernet (Default Switch)
Ethernet 3
Ethernet 4
Ethernet 5
```

**Linux:**

- `ifconfig`

```bash
vagrant@vagrant:~$ ifconfig
eth0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 10.0.2.15  netmask 255.255.255.0  broadcast 10.0.2.255
        inet6 fe80::a00:27ff:feb1:285d  prefixlen 64  scopeid 0x20<link>
        ether 08:00:27:b1:28:5d  txqueuelen 1000  (Ethernet)
        RX packets 135782  bytes 194427368 (194.4 MB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 10797  bytes 988157 (988.1 KB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
        inet 127.0.0.1  netmask 255.0.0.0
        inet6 ::1  prefixlen 128  scopeid 0x10<host>
        loop  txqueuelen 1000  (Local Loopback)
        RX packets 216  bytes 16742 (16.7 KB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 216  bytes 16742 (16.7 KB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
```

- `ip a`

```bash
vagrant@vagrant:~$ ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 08:00:27:b1:28:5d brd ff:ff:ff:ff:ff:ff
    inet 10.0.2.15/24 brd 10.0.2.255 scope global dynamic eth0
       valid_lft 81644sec preferred_lft 81644sec
    inet6 fe80::a00:27ff:feb1:285d/64 scope link
       valid_lft forever preferred_lft forever
```

- `/sbin/ifconfig`

```bash
vagrant@vagrant:~$ /sbin/ifconfig
eth0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 10.0.2.15  netmask 255.255.255.0  broadcast 10.0.2.255
        inet6 fe80::a00:27ff:feb1:285d  prefixlen 64  scopeid 0x20<link>
        ether 08:00:27:b1:28:5d  txqueuelen 1000  (Ethernet)
        RX packets 135823  bytes 194430548 (194.4 MB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 10817  bytes 991643 (991.6 KB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
        inet 127.0.0.1  netmask 255.0.0.0
        inet6 ::1  prefixlen 128  scopeid 0x10<host>
        loop  txqueuelen 1000  (Local Loopback)
        RX packets 216  bytes 16742 (16.7 KB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 216  bytes 16742 (16.7 KB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
```

- `ip link show`

```bash
vagrant@vagrant:~$ ip link show
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP mode DEFAULT group default qlen 1000
    link/ether 08:00:27:b1:28:5d brd ff:ff:ff:ff:ff:ff
```

- `ls /sys/class/net`

```bash
vagrant@vagrant:~$ ls /sys/class/net
eth0  lo
```

### 2. Какой протокол используется для распознавания соседа по сетевому интерфейсу? Какой пакет и команды есть в Linux для этого?

`Link Layer Discovery Protocol (LLDP)` — протокол канального уровня, позволяющий сетевому оборудованию оповещать оборудование, работающее в локальной сети, о своём существовании и передавать ему свои характеристики, а также получать от него аналогичные сведения.

В Linux пакет называется `lldpd`.

Для работы Link Discovery и возможности получать информацию о линках через SNMP необходимо установить два пакета `snmpd` и `lldpd`.

```bash
apt install -y snmpd lldpd
systemctl enable lldpd
service lldpd start
echo "# enable agentx for lldp
master agentx" >> /etc/snmp/snmpd.conf
echo 'DAEMON_ARGS="-x -c -s -e"' >> /etc/default/lldpd
service lldpd restart
service snmpd restart
```

```bash
root@vagrant:~# lldpctl
-------------------------------------------------------------------------------
LLDP neighbors:
-------------------------------------------------------------------------------
```

### 3. Какая технология используется для разделения L2 коммутатора на несколько виртуальных сетей? Какой пакет и команды есть в Linux для этого? Приведите пример конфига.

Технология `VLAN`.

VLAN (Virtual Local Area Network) — виртуальная локальная компьютерная сеть. Представляет собой группу хостов с общим набором требований, которые взаимодействуют так, как если бы они были подключены к широковещательному домену независимо от их физического местонахождения. VLAN имеет те же свойства, что и физическая локальная сеть, но позволяет конечным членам группироваться вместе, даже если они не находятся в одной физической сети.

В Linux пакет называется `vlan`.

```bash
sudo apt-get install vlan
```

Все настройки указываются в файле `/etc/network/interfaces`.

```bash
auto vlan1400
iface vlan1400 inet static
        address 192.168.1.1
        netmask 255.255.255.0
        vlan_raw_device eth0
```

### 4. Какие типы агрегации интерфейсов есть в Linux? Какие опции есть для балансировки нагрузки? Приведите пример конфига.

Типы агрегации интерфейсов в Linux:

`Mode-0(balance-rr)` – Данный режим используется по умолчанию. Balance-rr обеспечивается балансировку нагрузки и отказоустойчивость. В данном режиме сетевые пакеты отправляются “по кругу”, от первого интерфейса к последнему. Если выходят из строя интерфейсы, пакеты отправляются на остальные оставшиеся. Дополнительной настройки коммутатора не требуется при нахождении портов в одном коммутаторе. При разностных коммутаторах требуется дополнительная настройка.

`Mode-1(active-backup)` – Один из интерфейсов работает в активном режиме, остальные в ожидающем. При обнаружении проблемы на активном интерфейсе производится переключение на ожидающий интерфейс. Не требуется поддержки от коммутатора.

`Mode-2(balance-xor)` – Передача пакетов распределяется по типу входящего и исходящего трафика по формуле ((MAC src) XOR (MAC dest)) % число интерфейсов. Режим дает балансировку нагрузки и отказоустойчивость. Не требуется дополнительной настройки коммутатора/коммутаторов.

`Mode-3(broadcast)` – Происходит передача во все объединенные интерфейсы, тем самым обеспечивая отказоустойчивость. Рекомендуется только для использования MULTICAST трафика.

`Mode-4(802.3ad)` – динамическое объединение одинаковых портов. В данном режиме можно значительно увеличить пропускную способность входящего так и исходящего трафика. Для данного режима необходима поддержка и настройка коммутатора/коммутаторов.

`Mode-5(balance-tlb)` – Адаптивная балансировки нагрузки трафика. Входящий трафик получается только активным интерфейсом, исходящий распределяется в зависимости от текущей загрузки канала каждого интерфейса. Не требуется специальной поддержки и настройки коммутатора/коммутаторов.

`Mode-6(balance-alb)` – Адаптивная балансировка нагрузки. Отличается более совершенным алгоритмом балансировки нагрузки чем Mode-5). Обеспечивается балансировку нагрузки как исходящего так и входящего трафика. Не требуется специальной поддержки и настройки коммутатора/коммутаторов.

Пример конфига:

```bash
uto bond0
iface bond0 inet dhcp
   bond-slaves eth0 eth1
   bond-mode active-backup
   bond-miimon 100
   bond-primary eth0 eth1
```

### 5. Сколько IP адресов в сети с маской /29 ? Сколько /29 подсетей можно получить из сети с маской /24. Приведите несколько примеров /29 подсетей внутри сети 10.10.10.0/24.

Ставим `ipcalc`.

```bash
root@vagrant:~# apt-get install ipcalc
Reading package lists... Done
Building dependency tree       
Reading state information... Done
The following NEW packages will be installed:
  ipcalc
0 upgraded, 1 newly installed, 0 to remove and 1 not upgraded.
Need to get 25.9 kB of archives.
After this operation, 64.5 kB of additional disk space will be used.
Get:1 http://us.ports.ubuntu.com/ubuntu-ports focal/universe arm64 ipcalc all 0.41-5 [25.9 kB]
Fetched 25.9 kB in 1s (36.3 kB/s) 
Selecting previously unselected package ipcalc.
(Reading database ... 111665 files and directories currently installed.)
Preparing to unpack .../archives/ipcalc_0.41-5_all.deb ...
Unpacking ipcalc (0.41-5) ...
Setting up ipcalc (0.41-5) ...
Processing triggers for man-db (2.9.1-1) ...
```

Считаем:

```bash
root@vagrant:~# ipcalc 192.168.0.1/29
Address:   192.168.0.1          11000000.10101000.00000000.00000 001
Netmask:   255.255.255.248 = 29 11111111.11111111.11111111.11111 000
Wildcard:  0.0.0.7              00000000.00000000.00000000.00000 111
=>
Network:   192.168.0.0/29       11000000.10101000.00000000.00000 000
HostMin:   192.168.0.1          11000000.10101000.00000000.00000 001
HostMax:   192.168.0.6          11000000.10101000.00000000.00000 110
Broadcast: 192.168.0.7          11000000.10101000.00000000.00000 111
Hosts/Net: 6                     Class C, Private Internet
```

- 6 хостов
- 8 IP-адресов

```bash
root@vagrant:~# ipcalc 192.168.0.1/24
Address:   192.168.0.1          11000000.10101000.00000000. 00000001
Netmask:   255.255.255.0 = 24   11111111.11111111.11111111. 00000000
Wildcard:  0.0.0.255            00000000.00000000.00000000. 11111111
=>
Network:   192.168.0.0/24       11000000.10101000.00000000. 00000000
HostMin:   192.168.0.1          11000000.10101000.00000000. 00000001
HostMax:   192.168.0.254        11000000.10101000.00000000. 11111110
Broadcast: 192.168.0.255        11000000.10101000.00000000. 11111111
Hosts/Net: 254                   Class C, Private Internet
```

- 254 хостов
- 256 IP-адресов

Количество подсетей `/29` в подсети `/24` 2⁵=32

Примеры `/29` сетей:

```bash
10.10.10.0/29
10.10.10.8/29
10.10.10.16/29
```

### 6. Задача: вас попросили организовать стык между 2-мя организациями. Диапазоны 10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16 уже заняты. Из какой подсети допустимо взять частные IP адреса? Маску выберите из расчета максимум 40-50 хостов внутри подсети.

Из подсети `100.64.0.0/10`. 

В соответствии с RFC6598, используется как транслируемый блок адресов для межпровайдерских взаимодействий и Carrier Grade NAT. Особенно полезен как общее свободное адресное IPv4-пространство RFC1918, необходимое для интеграции ресурсов провайдеров, а также для выделения немаршрутизируемых адресов абонентам.

```bash
root@vagrant:~# ipcalc 100.64.0.0/26
Address:   100.64.0.0           01100100.01000000.00000000.00 000000
Netmask:   255.255.255.192 = 26 11111111.11111111.11111111.11 000000
Wildcard:  0.0.0.63             00000000.00000000.00000000.00 111111
=>
Network:   100.64.0.0/26        01100100.01000000.00000000.00 000000
HostMin:   100.64.0.1           01100100.01000000.00000000.00 000001
HostMax:   100.64.0.62          01100100.01000000.00000000.00 111110
Broadcast: 100.64.0.63          01100100.01000000.00000000.00 111111
Hosts/Net: 62                    Class A

```

`ipcalc 100.64.0.0/26`

### 7. Как проверить ARP таблицу в Linux, Windows? Как очистить ARP кеш полностью? Как из ARP таблицы удалить только один нужный IP?

ARP таблица в `Linux`:

```bash
root@vagrant:~# apt install net-tools
```

```bash
root@vagrant:~# arp -n
Address                  HWtype  HWaddress           Flags Mask            Iface
192.168.16.2             ether   00:50:56:ff:ba:76   C                     eth0
192.168.16.254           ether   00:50:56:ed:1e:c6   C                     eth0
192.168.16.1             ether   f6:d4:88:26:5a:65   C                     eth0
```

Очистить ARP кеш полностью:

```bash
root@vagrant:~# ip -s neigh flush all

*** Round 1, deleting 3 entries ***
*** Flush is complete after 1 round ***
root@vagrant:~# arp -n
Address                  HWtype  HWaddress           Flags Mask            Iface
192.168.16.1             ether   f6:d4:88:26:5a:65   C                     eth0
```

Удалить один нужный IP:

```bash
arp -d <ip-address>
```

В `Windows`:

ARP таблица: `arp -a`;  

Очистить ARP кеш полностью: `arp -d -a`;  

Удалить один нужный IP: `arp -d <ip-address>`.

 ---
## Задание для самостоятельной отработки (необязательно к выполнению)

### 8*. Установите эмулятор EVE-ng.
 
 Инструкция по установке - https://github.com/svmyasnikov/eve-ng

 Выполните задания на lldp, vlan, bonding в эмуляторе EVE-ng. 
 

