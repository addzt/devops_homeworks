# Домашнее задание к занятию "3.3. Операционные системы, лекция 1"

### 1. Какой системный вызов делает команда `cd`? В прошлом ДЗ мы выяснили, что `cd` не является самостоятельной программой, это `shell builtin`, поэтому запустить `strace` непосредственно на `cd` не получится. Тем не менее, вы можете запустить `strace` на `/bin/bash -c 'cd /tmp'`. В этом случае вы увидите полный список системных вызовов, которые делает сам `bash` при старте. Вам нужно найти тот единственный, который относится именно к `cd`. Обратите внимание, что `strace` выдаёт результат своей работы в поток `stderr`, а не в `stdout`.

```bash
vagrant@vagrant:~$ strace /bin/bash -c 'cd /tmp' 2>&1 | grep "/tmp"
execve("/bin/bash", ["/bin/bash", "-c", "cd /tmp"], 0x7ffeda08b7a0 /* 23 vars */) = 0
stat("/tmp", {st_mode=S_IFDIR|S_ISVTX|0777, st_size=4096, ...}) = 0
chdir("/tmp")                           = 0
```

`chdir` изменяет текущий каталог или папку.  
Следовательно, `chdir("/temp") = 0`

### 2. Попробуйте использовать команду `file` на объекты разных типов на файловой системе. Например:
```vagrant@netology1:~$ file /dev/tty
/dev/tty: character special (5/0)
vagrant@netology1:~$ file /dev/sda
/dev/sda: block special (8/0)
vagrant@netology1:~$ file /bin/bash
/bin/bash: ELF 64-bit LSB shared object, x86-64
```
Используя `strace` выясните, где находится база данных `file` на основании которой она делает свои догадки.

```bash
vagrant@vagrant:~$ strace file /dev/tty
```

```bash
stat("/home/vagrant/.magic.mgc", 0x7ffc1d723590) = -1 ENOENT (No such file or directory)
stat("/home/vagrant/.magic", 0x7ffc1d723590) = -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "/etc/magic.mgc", O_RDONLY) = -1 ENOENT (No such file or directory)
stat("/etc/magic", {st_mode=S_IFREG|0644, st_size=111, ...}) = 0
openat(AT_FDCWD, "/etc/magic", O_RDONLY) = 3
```
```bash
openat(AT_FDCWD, "/usr/share/misc/magic.mgc", O_RDONLY) = 3
```

### 3. Предположим, приложение пишет лог в текстовый файл. Этот файл оказался удален (deleted в lsof), однако возможности сигналом сказать приложению переоткрыть файлы или просто перезапустить приложение – нет. Так как приложение продолжает писать в удаленный файл, место на диске постепенно заканчивается. Основываясь на знаниях о перенаправлении потоков предложите способ обнуления открытого удаленного файла (чтобы освободить место на файловой системе).

```bash
vagrant@vagrant:~$ vim 123
vagrant@vagrant:~$ rm .123.swp
vagrant@vagrant:~$ vim 123

[2]+  Stopped                 vim 123
vagrant@vagrant:~$ lsof | grep '(deleted)'
vim       2155                        vagrant    4u      REG              253,0    12288    1048591 /home/vagrant/.123.swp (deleted)
```

```bash
vagrant@vagrant:~$ truncate -s 0 /proc/2155/fd/4
vagrant@vagrant:~$ lsof -p 2155
```

```bash
vim     2155 vagrant    4u   REG  253,0        0 1048591 /home/vagrant/.123.swp (deleted)
```

### 4. Занимают ли зомби-процессы какие-то ресурсы в ОС (CPU, RAM, IO)?

Зомби не занимают памяти (как процессы-сироты), но блокируют записи в таблице процессов, размер которой ограничен для каждого пользователя и системы в целом.  
При достижении лимита записей все процессы пользователя, от имени которого выполняется создающий зомби родительский процесс, не будут способны создавать новые дочерние процессы.  
Кроме этого, пользователь, от имени которого выполняется родительский процесс, не сможет зайти на консоль (локальную или удалённую), или выполнить какие-либо команды на уже открытой консоли (потому что для этого командный интерпретатор sh должен создать новый процесс).

### 5. В iovisor BCC есть утилита `opensnoop`:
```bash
root@vagrant:~# dpkg -L bpfcc-tools | grep sbin/opensnoop
/usr/sbin/opensnoop-bpfcc
```
На какие файлы вы увидели вызовы группы `open` за первую секунду работы утилиты? Воспользуйтесь пакетом `bpfcc-tools` для Ubuntu 20.04. Дополнительные [сведения по установке](https://github.com/iovisor/bcc/blob/master/INSTALL.md).

```bash
sudo apt-get install bpfcc-tools linux-headers-$(uname -r)
```

```bash
vagrant@vagrant:/etc/apt$ sudo opensnoop-bpfcc
PID    COMM               FD ERR PATH
861    vminfo              4   0 /var/run/utmp
653    dbus-daemon        -1   2 /usr/local/share/dbus-1/system-services
653    dbus-daemon        20   0 /usr/share/dbus-1/system-services
653    dbus-daemon        -1   2 /lib/dbus-1/system-services
653    dbus-daemon        20   0 /var/lib/snapd/dbus-1/system-services/
861    vminfo              4   0 /var/run/utmp
653    dbus-daemon        -1   2 /usr/local/share/dbus-1/system-services
653    dbus-daemon        20   0 /usr/share/dbus-1/system-services
653    dbus-daemon        -1   2 /lib/dbus-1/system-services
653    dbus-daemon        20   0 /var/lib/snapd/dbus-1/system-services/
658    irqbalance          6   0 /proc/interrupts
658    irqbalance          6   0 /proc/stat
658    irqbalance          6   0 /proc/irq/20/smp_affinity
658    irqbalance          6   0 /proc/irq/0/smp_affinity
658    irqbalance          6   0 /proc/irq/1/smp_affinity
658    irqbalance          6   0 /proc/irq/8/smp_affinity
658    irqbalance          6   0 /proc/irq/12/smp_affinity
658    irqbalance          6   0 /proc/irq/14/smp_affinity
658    irqbalance          6   0 /proc/irq/15/smp_affinity
861    vminfo              4   0 /var/run/utmp
653    dbus-daemon        -1   2 /usr/local/share/dbus-1/system-services
653    dbus-daemon        20   0 /usr/share/dbus-1/system-services
653    dbus-daemon        -1   2 /lib/dbus-1/system-services
653    dbus-daemon        20   0 /var/lib/snapd/dbus-1/system-services/
```

### 6. Какой системный вызов использует `uname -a`? Приведите цитату из man по этому системному вызову, где описывается альтернативное местоположение в `/proc`, где можно узнать версию ядра и релиз ОС.

```bash
Part of the utsname information is also accessible via
       /proc/sys/kernel/{ostype, hostname, osrelease, version,
       domainname}.
```

```bash
vagrant@vagrant:/$ cat /proc/sys/kernel/version
#102-Ubuntu SMP Fri Nov 5 16:31:28 UTC 2021
```

### 7. Чем отличается последовательность команд через `;` и через `&&` в bash? Например:
```bash
root@netology1:~# test -d /tmp/some_dir; echo Hi
Hi
root@netology1:~# test -d /tmp/some_dir && echo Hi
root@netology1:~#
```
Есть ли смысл использовать в bash `&&`, если применить `set -e`?

`;` - последовательное выполнение команд. Выполнятся обе команды.  
`&&` - вторая команда выполнится в случае успешного выполнения первой.  
`set -e` -e Немедленный выход, если команда завершается с ненулевым статусом.

### 8. Из каких опций состоит режим bash `set -euxo pipefail` и почему его хорошо было бы использовать в сценариях?

`set -e`  
Указав параметр `-e` скрипт немедленно завершит работу, если любая команда выйдет с ошибкой. По-умолчанию, игнорируются любые неудачи и сценарий продолжит выполняться. Если предполагается, что команда может завершиться с ошибкой, но это не критично, можно использовать пайплайн || true.

`set -o pipefail`  
Bash возвращает только код ошибки последней команды в пайпе (конвейере). И параметр `-e` проверяет только его. Если нужно убедиться, что все команды в пайпах завершились успешно, нужно использовать `-o pipefail`.

`set -u`  
Благодаря ему оболочка проверяет инициализацию переменных в скрипте. Если переменной не будет, скрипт немедленно завершиться. Данный параметр достаточно умен, чтобы нормально работать с переменной по-умолчанию `${MY_VAR:-$DEFAULT}` и условными операторами (if, while, и др).

`set -x`
Параметр -x очень полезен при отладке. С помощью него bash печатает в стандартный вывод все команды перед их исполнением. Стоит учитывать, что все переменные будут уже доставлены, и с этим нужно быть аккуратнее, к примеру если используете пароли.

### 9. Используя `-o stat` для `ps`, определите, какой наиболее часто встречающийся статус у процессов в системе. В `man ps` ознакомьтесь (`/PROCESS STATE CODES`) что значат дополнительные к основной заглавной буквы статуса процессов. Его можно не учитывать при расчете (считать S, Ss или Ssl равнозначными).

```bash
vagrant@vagrant:/$ ps -o stat
STAT
Ss
T
T
T
T
R+
```

```bash
PROCESS STATE CODES
       Here are the different values that the s, stat and state output specifiers (header "STAT" or "S") will display to describe
       the state of a process:

               D    uninterruptible sleep (usually IO)
               I    Idle kernel thread
               R    running or runnable (on run queue)
               S    interruptible sleep (waiting for an event to complete)
               T    stopped by job control signal
               t    stopped by debugger during the tracing
               W    paging (not valid since the 2.6.xx kernel)
               X    dead (should never be seen)
               Z    defunct ("zombie") process, terminated but not reaped by its parent

       For BSD formats and when the stat keyword is used, additional characters may be displayed:

               <    high-priority (not nice to other users)
               N    low-priority (nice to other users)
               L    has pages locked into memory (for real-time and custom IO)
               s    is a session leader
               l    is multi-threaded (using CLONE_THREAD, like NPTL pthreads do)
               +    is in the foreground process group
```