# Домашнее задание к занятию "3.2. Работа в терминале, лекция 2"

### 1. Какого типа команда `cd`? Попробуйте объяснить, почему она именно такого типа; опишите ход своих мыслей, если считаете что она могла бы быть другого типа. 

```bash
vagrant@vagrant:~$ type cd
cd is a shell builtin
```
Shell builtin представляет собой команду или функцию, вызываемую из оболочки, которая выполняется непосредственно в самой оболочке, а не во внешней исполняемой программе, которую оболочка загружает и выполняет.
Встроенные оболочки работают значительно быстрее, чем внешние программы, потому что нет накладных расходов на загрузку программ. Однако их код изначально присутствует в оболочке, поэтому для их изменения или обновления требуются модификации оболочки. Встроенные оболочки обычно используются для простых, почти тривиальных функций, таких как вывод текста. Из-за особенностей некоторых операционных систем, некоторые функции обязательно должны быть реализованы в виде встроенных оболочек. Наиболее ярким примером является команда `cd`, которая изменяет рабочий каталог оболочки. Поскольку каждая исполняемая программа запускается в отдельном процессе, а рабочие каталоги специфичны для каждого процесса, загрузка `cd` как внешней программы не повлияет на рабочий каталог оболочки, которая ее загрузила.

### 2. Какая альтернатива без pipe команде `grep <some_string> <some_file> | wc -l`? `man grep` поможет в ответе на этот вопрос. Ознакомьтесь с [документом](http://www.smallo.ruhr.de/award.html) о других подобных некорректных вариантах использования pipe.

```bash
wc --help
```
```bash
-l, --lines            print the newline counts
```

```bash
man grep
```
```bash
-c, --count
      Suppress  normal  output; instead print a count of matching lines for each input file.  With the -v, --invert-match
      option (see below), count non-matching lines.
```
Следовательно, команда `grep -c <some_string> <some_file>`

### 3. Какой процесс с PID `1` является родителем для всех процессов в вашей виртуальной машине Ubuntu 20.04?

```bash
pstree -p
```
```bash
systemd(1)─┬─VBoxService(876)─┬─{VBoxService}(878)
           │                  ├─{VBoxService}(879)
           │                  ├─{VBoxService}(880)
           │                  ├─{VBoxService}(881)
           │                  ├─{VBoxService}(882)
           │                  ├─{VBoxService}(883)
           │                  ├─{VBoxService}(884)
           │                  └─{VBoxService}(885)
           ├─accounts-daemon(629)─┬─{accounts-daemon}(631)
           │                      └─{accounts-daemon}(698)
           ├─agetty(691)
           ├─atd(661)
           ├─cron(637)
           ├─dbus-daemon(638)
           ├─fwupd(2630)─┬─{fwupd}(2642)
           │             ├─{fwupd}(2643)
           │             ├─{fwupd}(2644)
           │             └─{fwupd}(2645)
           ├─irqbalance(644)───{irqbalance}(645)
           ├─multipathd(539)─┬─{multipathd}(540)
           │                 ├─{multipathd}(541)
           │                 ├─{multipathd}(542)
           │                 ├─{multipathd}(543)
           │                 ├─{multipathd}(544)
           │                 └─{multipathd}(545)
           ├─networkd-dispat(646)
           ├─polkitd(709)─┬─{polkitd}(710)
           │              └─{polkitd}(716)
           ├─rsyslogd(647)─┬─{rsyslogd}(671)
           │               ├─{rsyslogd}(672)
           │               └─{rsyslogd}(673)
           ├─snapd(1805)─┬─{snapd}(1817)
           │             ├─{snapd}(1818)
           │             ├─{snapd}(1819)
           │             ├─{snapd}(1820)
           │             ├─{snapd}(1821)
           │             ├─{snapd}(1824)
           │             ├─{snapd}(1826)
           │             ├─{snapd}(1827)
           │             ├─{snapd}(1843)
           │             ├─{snapd}(1848)
           │             ├─{snapd}(1850)
           │             ├─{snapd}(1851)
           │             ├─{snapd}(1852)
           │             ├─{snapd}(1853)
           │             ├─{snapd}(1855)
           │             └─{snapd}(1936)
           ├─sshd(675)───sshd(2473)───sshd(2527)───bash(2528)───pstree(2672)
           ├─systemd(2485)───(sd-pam)(2486)
           ├─systemd-journal(356)
           ├─systemd-logind(655)
           ├─systemd-network(612)
           ├─systemd-resolve(614)
           ├─systemd-udevd(392)
           ├─udisksd(658)─┬─{udisksd}(683)
           │              ├─{udisksd}(699)
           │              ├─{udisksd}(734)
           │              └─{udisksd}(773)
           └─upowerd(2646)─┬─{upowerd}(2648)
                           └─{upowerd}(2649)
```
Процесс `systemd`.

### 4. Как будет выглядеть команда, которая перенаправит вывод stderr `ls` на другую сессию терминала?

Поток stderr зарезервирован для вывода диагностических и отладочных сообщений в текстовом виде.  Командная оболочка позволяет изменять цель этого потока с помощью конструкции «2>».  
Узнаем путь текущего терминала:
```bash
vagrant@vagrant:~$ tty
/dev/pts/0
```
Создадим новую сессию терминала
```bash
vagrant@vagrant:~$ tty
/dev/pts/1
```
Используем команду 
```bash
ls -l \root 2>/dev/pts/1
```
Посмотрим вывод в новой сессии
```bash
vagrant@vagrant:~$ ls: cannot open directory 'root': Permission denied
```

### 5. Получится ли одновременно передать команде файл на stdin и вывести ее stdout в другой файл? Приведите работающий пример.

```bash
vagrant@vagrant:~$ cat 123
test
test
tested
vagrant@vagrant:~$ cat <123 >123out
vagrant@vagrant:~$ cat 123out
test
test
tested
```

### 6. Получится ли находясь в графическом режиме, вывести данные из PTY в какой-либо из эмуляторов TTY? Сможете ли вы наблюдать выводимые данные?

```bash
vagrant@vagrant:/$ echo "Hello, world!" > /dev/pts/1
```

### 7. Выполните команду `bash 5>&1`. К чему она приведет? Что будет, если вы выполните `echo netology > /proc/$$/fd/5`? Почему так происходит?

Команда `bash 5>&1` создает дескриптор с номером 5 и перенаправит его в stdout.

```bash
vagrant@vagrant:/$ echo netology > /proc/$$/fd/5
netology
```

### 8. Получится ли в качестве входного потока для pipe использовать только stderr команды, не потеряв при этом отображение stdout на pty? Напоминаем: по умолчанию через pipe передается только stdout команды слева от `|` на stdin команды справа. Это можно сделать, поменяв стандартные потоки местами через промежуточный новый дескриптор, который вы научились создавать в предыдущем вопросе.

Направляем созданный дескриптор на 2, а 2 на 1.

```bash
vagrant@vagrant:/$ ls -l root 5>&2 2>&1 | grep "Permission denied" -c
1
```

### 9. Что выведет команда `cat /proc/$$/environ`? Как еще можно получить аналогичный по содержанию вывод?

Переменные окружения. Можно получить используя `env`.

### 10. Используя man, опишите что доступно по адресам `/proc/<PID>/cmdline`, `/proc/<PID>/exe`.
```bash
vagrant@vagrant:/$ man proc | grep -n -A 5 -B 5 cmdline
```

```bash
215:       /proc/[pid]/cmdline
216-              This read-only file holds the complete command line for the process, unless the process is a zombie.  In the latter
217-              case, there is nothing in this file: that is, a read on this file will return 0 characters.  The command-line argu‐
218-              ments  appear  in  this file as a set of strings separated by null bytes ('\0'), with a further null byte after the
219-              last string.
```
Этот файл только для чтения, содержит полную командную строку для процесса, если процесс не является зомби.

```bash
vagrant@vagrant:/$ man proc | grep -n -A 5 -B 5 exe
```

```bash
266:       /proc/[pid]/exe
267:              Under Linux 2.2 and later, this file is a symbolic link containing the actual pathname  of  the  executed  command.
268:              This symbolic link can be dereferenced normally; attempting to open it will open the executable.  You can even type
269:              /proc/[pid]/exe to run another copy of the same executable that is being run by process [pid].  If the pathname has
270-              been  unlinked, the symbolic link will contain the string '(deleted)' appended to the original pathname.  In a mul‐
271-              tithreaded process, the contents of this symbolic link are not available if the main thread has already  terminated
272-              (typically by calling pthread_exit(3)).
```

Этот файл представляет собой символическую ссылку, содержащую фактический путь к выполняемой команде.

### 11. Узнайте, какую наиболее старшую версию набора инструкций SSE поддерживает ваш процессор с помощью `/proc/cpuinfo`.

```bash
vagrant@vagrant:/$ cat /proc/cpuinfo | grep sse
```

```bash
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx rdtscp lm constant_tsc rep_good nopl xtopology nonstop_tsc cpuid tsc_known_freq pni ssse3 pcid sse4_1 sse4_2 hypervisor lahf_lm invpcid_single pti fsgsbase invpcid md_clear flush_l1d arch_capabilities
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx rdtscp lm constant_tsc rep_good nopl xtopology nonstop_tsc cpuid tsc_known_freq pni ssse3 pcid sse4_1 sse4_2 hypervisor lahf_lm invpcid_single pti fsgsbase invpcid md_clear flush_l1d arch_capabilities
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx rdtscp lm constant_tsc rep_good nopl xtopology nonstop_tsc cpuid tsc_known_freq pni ssse3 pcid sse4_1 sse4_2 hypervisor lahf_lm invpcid_single pti fsgsbase invpcid md_clear flush_l1d arch_capabilities
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx rdtscp lm constant_tsc rep_good nopl xtopology nonstop_tsc cpuid tsc_known_freq pni ssse3 pcid sse4_1 sse4_2 hypervisor lahf_lm invpcid_single pti fsgsbase invpcid md_clear flush_l1d arch_capabilities
```

`sse4_2`

### 12. При открытии нового окна терминала и `vagrant ssh` создается новая сессия и выделяется pty. Это можно подтвердить командой `tty`, которая упоминалась в лекции 3.2. Однако:
```bash
vagrant@netology1:~$ ssh localhost 'tty'
not a tty
```
### Почитайте, почему так происходит, и как изменить поведение.


По умолчанию, когда вы запускаете команду на удаленном компьютере с помощью ssh, TTY не выделяется для удаленного сеанса. Это позволяет передавать двоичные данные и т. д. Без необходимости работать с причудами TTY.  
Однако, когда вы запускаете ssh без удаленной команды, он выделяет TTY, потому что вы, скорее всего, будете запускать сеанс оболочки.  
Если вы хотите включить оболочку, необходимо использовать флаг `-t`.

### 13. Бывает, что есть необходимость переместить запущенный процесс из одной сессии в другую. Попробуйте сделать это, воспользовавшись `reptyr`. Например, так можно перенести в `screen` процесс, который вы запустили по ошибке в обычной SSH-сессии.

```bash
vagrant@vagrant:/$ sudo apt-get install reptyr
```
Для начала необходимо запустить процесс и приостановить его.
```bash
vagrant@vagrant:~$ top
top - 14:45:44 up  1:14,  1 user,  load average: 0.08, 0.02, 0.01
Tasks: 128 total,   1 running, 124 sleeping,   3 stopped,   0 zombie
%Cpu(s):  1.4 us,  2.8 sy,  0.0 ni, 95.8 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st
MiB Mem :   1987.1 total,   1264.5 free,    170.2 used,    552.3 buff/cache
MiB Swap:   1962.0 total,   1962.0 free,      0.0 used.   1669.8 avail Mem
```

`CTRL+z`

```bash
disown top
```

```bash
screen
```

```bash
reptyr $(pgrep top)
```

```bash
Unable to attach to pid 1748: Operation not permitted
The kernel denied permission while attaching. If your uid matches
the target's, check the value of /proc/sys/kernel/yama/ptrace_scope.
For more information, see /etc/sysctl.d/10-ptrace.conf
```
Редактируем файл

```bash
sudo nano /proc/sys/kernel/yama/ptrace_scope
```

Повторяем

```bash
reptyr $(pgrep top)
```

Вывод

```bash
  GNU nano 4.8                                     /proc/sys/kernel/yama/ptrace_scope
top - 18:16:26 up  2:00,  2 users,  load average: 0.01, 0.01, 0.00
Tasks: 135 total,   1 running, 132 sleeping,   1 stopped,   1 zombie
%Cpu(s):  0.2 us,  0.4 sy,  0.0 ni, 99.3 id,  0.0 wa,  0.0 hi,  0.1 si,  0.0 st
MiB Mem :   1987.1 total,   1254.9 free,    176.3 used,    555.9 buff/cache
MiB Swap:   1962.0 total,   1962.0 free,      0.0 used.   1662.6 avail Mem
```

### 14. `sudo echo string > /root/new_file` не даст выполнить перенаправление под обычным пользователем, так как перенаправлением занимается процесс shell'а, который запущен без `sudo` под вашим пользователем. Для решения данной проблемы можно использовать конструкцию `echo string | sudo tee /root/new_file`. Узнайте что делает команда `tee` и почему в отличие от `sudo echo` команда с `sudo tee` будет работать.

Команда `tee` читает из стандартного ввода и записывает как в стандартный вывод, так и в один или несколько файлов одновременно.
Синтаксис
```bash
tee [OPTIONS] [FILE]
```
Sudo echo не будет работать, так как sudo не перенаправляет вывод. Перенаправление выполняется как непривилегированный пользователь. `tee` получит вывод команды `echo`, повысит права на `sudo` и запишет в файл.
Использование `tee` в сочетании с `sudo` позволяет записывать в файлы, принадлежащие другим пользователям.