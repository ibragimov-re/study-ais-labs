# Учебная работа по дисциплине "Администрирование информационных систем"

> [!TIP]
> ## Среда выполнения для всех лабораторных работ
> - Контейнеризация: `Docker Engine`
> - Хост-система: `Linux, Fedora 43 KDE Plasma Desktop`
> - Командная оболочка: `bash`

> [!NOTE]
> ## Прогресс выполнения
> - [x] Лабораторная 1 (IP)
> - [x] Лабораторная 2 (Backup)
> - [x] Лабораторная 3 (Scheduling)
> - [x] Лабораторная 4 (PacketFiltering)
> - [ ] Лабораторная 5 (eBPF)

---

## Лабораторная 1. IP
### Задание:
- Написать скрипт на sh/bash/zsh, который будет принимать на вход IP адрес и, опционально, маску сети в любой из форм: 192.168.0.1 или 192.168.0.1/24 или 192.168.0.1/255.255.255.0 и на выходе печатать этот IP адрес и маску в стандартной форме: 192.168.0.1/24.
- Если маска не указана, то ее необходимо вычислить, понимая к какому классу сетей принадлежит IP (т.е. к A, B или C)

> [!TIP]
> ### Решение:
> Реализован скрипт, который:
> 1. Принимает аргумент в виде IP адреса и маски;
> 2. Разделяет IP и маску, проверяет их по отдельности на правильность написания;
> 3. Вычисляет CIDR маски, если не задано;
> 4. Выводит результат с IP-адресом и CIDR маски.

> [!IMPORTANT]
> ### Использование
> ```bash
> TO DO
> ```

> [!NOTE]
> ### Пример вывода
> ```
> TO DO
> ```

---

## Лабораторная 2. Backup
### Задание:
- Написать скрипт бэкапа каталога с периодам раз в 5 минут, в каталог архивов с именем типа dir-date-time.tgz, где:
  - `dir` - имя каталога;
  - `date` - дата создания архива вида 2021-01-01;
  - `time` - время создания архива вида 23:15.
- Скрипт получает на вход один аргумент, полное имя каталога: /path/to/dir. Необходимо выводить ошибку, если путь будет относительным или аргумент - не каталог.
- В качестве архиватора можно использовать tar (.tar, .tgz) или cpio.

> [!TIP]
> ### Решение:
> Реализован скрипт, который каждые 5 минут будет сохранять архив, используя цикл с задержкой, без использования `cron` или `systemd`.

> [!IMPORTANT]
> ### Использование
> ```bash
> /Labs/Lab2_Backup/backup.sh /Labs/Lab2_Backup/TestFiles/
> ```

> [!NOTE]
> ### Пример вывода
> ```
> Backup created: ./archives/TestFiles-2025-12-04-02:11.tgz
> Backup created: ./archives/TestFiles-2025-12-04-02:16.tgz
> ```

---

## Лабораторная 3. Scheduling
### Задание:
- На основе предыдущего скрипта (Лабораторная 2) сделать систему бэкапа каталога с периодом раз в 5 минут на основе cron и systemd (для systemd проще всего использовать его таймеры).

> [!TIP]
> ### Решение:
> Реализован скрипт, который каждые 5 минут будет сохранять архив, используя планировщик задач cron.

> [!IMPORTANT]
> ### Использование
> ```bash
> /Labs/Lab3_Scheduling/install_backup_cron.sh /Labs/Lab3_Scheduling/TestFiles/
> ```

> [!NOTE]
> ### Пример вывода
> ```
> Starting periodic command scheduler: cron.
> Cron backup job is installed to run every 5 minutes for directory: /Labs/Lab3_Scheduling/TestFiles/
> ```

---

## Лабораторная 4. Packet Filtering
### Задание:
- Создать конфигурацию из Apache2 (или nginx) и iptables для линукса с двумя сетевыми картами, которая:
  - блокирует весь входящий трафик на первом адаптере кроме TCP на порту 80 и UDP на порту 53;
  - позволит подключаться ssh'ем к этому серверу только со второй сетевой карты;
  - все входящие пакеты на UDP порт 10000 второго адаптера, перенаправляет на UDP порт 20000 первого адаптера.

> [!TIP]
> ### Решение:
> Реализован скрипт, который настраивает `iptables` в контейнере `Docker` с двумя сетевыми адаптерами в соответствии с пунктами в задании.
> Для проверки был также реализован контейнер `ais-lab4-tester` чтобы с него можно было делать запросы `curl` и подключение через `ssh`.

> [!IMPORTANT]
> ### Использование
> При старте контейнер сразу запускает скрипт с настройкой `iptables`. Ниже написаны команды для проверки конфигурации сетевых адаптеров.
> Команды следует начать выполнять из контейнера `ais-debian`, который сразу подключается к терминалу при запуске скрипта `run.sh`
> ```bash
> ip addr show # Вывести информацию о сетевых интерфейсах
> ```
> ```bash
> iptables -L -v -n # Вывести правила фильтрации
> ```
> ```bash
> iptables -t nat -L PREROUTING -v -n # Вывести правила перенаправления (DNAT)
> ```
> ```bash
> exit # Выйти из контейнера
> ```
> ```bash
> sudo docker exec -it ais-lab4-tester bash # Зайти в контейнер для тестирования
> ```
> ```bash
> curl http://172.10.0.10 # Запрос к nginx через eth0 (Разрешено)
> ```
> ```bash
> curl http://172.11.0.10 # Запрос к nginx через eth1 (Разрешено)
> ```
> ```bash
> ssh root@172.10.0.10 # Подключиться к shh через eth0 (Заблокировано)
> ```
> ```bash
> ssh root@172.11.0.10 # Подключиться к shh через eth1 (Разрешено)
> ```


> [!NOTE]
> ### Пример вывода
<details>
  <summary>Вывод команды ip addr show</summary>
  
```
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: eth0@if370: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default 
    link/ether f2:b6:b1:74:ab:7b brd ff:ff:ff:ff:ff:ff link-netnsid 0
    inet 172.10.0.10/24 brd 172.10.0.255 scope global eth0
       valid_lft forever preferred_lft forever
3: eth1@if371: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default 
    link/ether 86:9d:d1:eb:73:0e brd ff:ff:ff:ff:ff:ff link-netnsid 0
    inet 172.11.0.10/24 brd 172.11.0.255 scope global eth1
       valid_lft forever preferred_lft forever
```
</details>


<details>
  <summary>Вывод команды iptables -L -v -n</summary>
  
```
Chain INPUT (policy ACCEPT 0 packets, 0 bytes)
 pkts bytes target     prot opt in     out     source               destination         
    0     0 ACCEPT     17   --  eth0   *       0.0.0.0/0            0.0.0.0/0            udp dpt:53
    0     0 ACCEPT     6    --  eth0   *       0.0.0.0/0            0.0.0.0/0            tcp dpt:80
    0     0 ACCEPT     0    --  *      *       0.0.0.0/0            0.0.0.0/0            state RELATED,ESTABLISHED
    0     0 ACCEPT     0    --  lo     *       0.0.0.0/0            0.0.0.0/0           
    0     0 DROP       0    --  eth0   *       0.0.0.0/0            0.0.0.0/0           
    0     0 ACCEPT     6    --  eth1   *       0.0.0.0/0            0.0.0.0/0            tcp dpt:22

Chain FORWARD (policy ACCEPT 0 packets, 0 bytes)
 pkts bytes target     prot opt in     out     source               destination         
    0     0 ACCEPT     17   --  eth1   eth0    0.0.0.0/0            0.0.0.0/0            udp dpt:20000

Chain OUTPUT (policy ACCEPT 0 packets, 0 bytes)
 pkts bytes target     prot opt in     out     source               destination         
    0     0 ACCEPT     0    --  *      lo      0.0.0.0/0            0.0.0.0/0
```
</details>


<details>
  <summary>Вывод команды iptables -t nat -L PREROUTING -v -n</summary>
  
```
Chain PREROUTING (policy ACCEPT 0 packets, 0 bytes)
 pkts bytes target     prot opt in     out     source               destination         
    0     0 DNAT       17   --  eth1   *       0.0.0.0/0            0.0.0.0/0            udp dpt:10000 to:172.10.0.10:20000
```
</details>


<details>
  <summary>Вывод команды curl http://172.10.0.10</summary>

```
...
<title>Welcome to nginx!</title>
...
```
</details>


<details>
  <summary>Вывод команды curl http://172.11.0.10</summary>

```
...
<title>Welcome to nginx!</title>
...
```
</details>


<details>
  <summary>Вывод команды ssh root@172.10.0.10</summary>

```
ssh: connect to host 172.10.0.10 port 22: Connection timed out
```
</details>


<details>
  <summary>Вывод команды ssh root@172.11.0.10</summary>

```
</details>
  root@172.11.0.10's password:
```
</details>

---

## Лабораторная 5. eBPF
### Задание:
- Используя eBPF собрать статистику по количеству запущенных процессов/тредов в системе за период 10 минут в разрезе какой процесс/сколько запускает.
- Учесть, что запустить новый процесс можно несколькими способами.

> [!TIP]
> ### Решение:


> [!IMPORTANT]
> ### Использование
> ```bash
> 
> ```

> [!NOTE]
> ### Пример вывода
> ```
> 
> ```
