# Домашнее задание к занятию "6.4. PostgreSQL"

## Задача 1

Используя docker поднимите инстанс PostgreSQL (версию 13). Данные БД сохраните в volume.

Подключитесь к БД PostgreSQL используя `psql`.

Воспользуйтесь командой `\?` для вывода подсказки по имеющимся в `psql` управляющим командам.

**Найдите и приведите** управляющие команды для:
- вывода списка БД
- подключения к БД
- вывода списка таблиц
- вывода описания содержимого таблиц
- выхода из psql

Создадим `docker-compose.yml`.

```dockerfile
version: "3.9"
services:
  db:
    container_name: pg_container
    image: postgres:13
    restart: always
    environment:
      POSTGRES_USER: root
      POSTGRES_PASSWORD: root
      POSTGRES_DB: test_db
    volumes:
    - ./db-data:/var/lib/postgresql/data
    - ./db-backup:/var/lib/postgresql/backup
    ports:
      - "5432:5432"
  pgadmin:
    container_name: pgadmin4_container
    image: dpage/pgadmin4
    restart: always
    environment:
      PGADMIN_DEFAULT_EMAIL: admin@admin.com
      PGADMIN_DEFAULT_PASSWORD: root
    ports:
      - "5050:80"
```

Запустим контейнеры.

```bash
 ✘ addzt@MacBook-Pro-Ivan  ~/PycharmProjects/devops_homeworks/homework_6.4   main ±✚  docker compose up -d
[+] Running 29/29
 ⠿ pgadmin Pulled                                                                                                                                                                                                                               9.4s
   ⠿ 9981e73032c8 Pull complete                                                                                                                                                                                                                 1.0s
   ⠿ 7f7cb6a0ce1d Pull complete                                                                                                                                                                                                                 3.7s
   ⠿ 91d8c230cffd Pull complete                                                                                                                                                                                                                 3.8s
   ⠿ 32861e8378e5 Pull complete                                                                                                                                                                                                                 3.9s
   ⠿ c92a16e2eab6 Pull complete                                                                                                                                                                                                                 3.9s
   ⠿ 313cf15fc817 Pull complete                                                                                                                                                                                                                 3.9s
   ⠿ dcd008e70225 Pull complete                                                                                                                                                                                                                 4.3s
   ⠿ f254d81fec65 Pull complete                                                                                                                                                                                                                 5.0s
   ⠿ 350ccebc502f Pull complete                                                                                                                                                                                                                 5.0s
   ⠿ c6952689af24 Pull complete                                                                                                                                                                                                                 5.1s
   ⠿ b843bf24cd45 Pull complete                                                                                                                                                                                                                 5.2s
   ⠿ 49fe663278cb Pull complete                                                                                                                                                                                                                 5.2s
   ⠿ 57f5f0fd1f1c Pull complete                                                                                                                                                                                                                 5.3s
   ⠿ a85e052ed0c0 Pull complete                                                                                                                                                                                                                 6.4s
 ⠿ db Pulled                                                                                                                                                                                                                                   15.1s
   ⠿ 3b157c852f27 Pull complete                                                                                                                                                                                                                 6.9s
   ⠿ 1d019bcaa138 Pull complete                                                                                                                                                                                                                 7.1s
   ⠿ 80c6496d90a8 Pull complete                                                                                                                                                                                                                 7.1s
   ⠿ 994bae8aa940 Pull complete                                                                                                                                                                                                                 7.2s
   ⠿ 255bac0c560b Pull complete                                                                                                                                                                                                                 7.4s
   ⠿ f605281268d7 Pull complete                                                                                                                                                                                                                 7.5s
   ⠿ f0037c6d2945 Pull complete                                                                                                                                                                                                                 7.6s
   ⠿ 064e9138f07b Pull complete                                                                                                                                                                                                                 7.6s
   ⠿ 641b1590be2a Pull complete                                                                                                                                                                                                                12.0s
   ⠿ 98bb5ef2fdf3 Pull complete                                                                                                                                                                                                                12.0s
   ⠿ d6bda44ce8d7 Pull complete                                                                                                                                                                                                                12.0s
   ⠿ 8bfeb065372a Pull complete                                                                                                                                                                                                                12.1s
   ⠿ 4b2d39c76a1a Pull complete                                                                                                                                                                                                                12.1s
[+] Running 3/3
 ⠿ Network homework_64_default   Created                                                                                                                                                                                                        0.0s
 ⠿ Container pgadmin4_container  Started                                                                                                                                                                                                        0.6s
 ⠿ Container pg_container        Started                                                                                                                                                                                                        0.6s
 addzt@MacBook-Pro-Ivan  ~/PycharmProjects/devops_homeworks/homework_6.4   main ±✚  docker compose ps   
NAME                 COMMAND                  SERVICE             STATUS              PORTS
pg_container         "docker-entrypoint.s…"   db                  running             0.0.0.0:5432->5432/tcp
pgadmin4_container   "/entrypoint.sh"         pgadmin             running             0.0.0.0:5050->80/tcp
```

```bash
addzt@MacBook-Pro-Ivan  ~/PycharmProjects/devops_homeworks/homework_6.4   main ±✚  docker exec -it pg_container bash     
postgres@c4c040ecc2ce:/$ psql -U root -d test_db
psql (13.7 (Debian 13.7-1.pgdg110+1))
Type "help" for help.

test_db=# \?
```

>- вывод списка БД

`\l[+]   [PATTERN]      list databases`

```bash
test_db=# \l
                             List of databases
   Name    | Owner | Encoding |  Collate   |   Ctype    | Access privileges 
-----------+-------+----------+------------+------------+-------------------
 postgres  | root  | UTF8     | en_US.utf8 | en_US.utf8 | 
 template0 | root  | UTF8     | en_US.utf8 | en_US.utf8 | =c/root          +
           |       |          |            |            | root=CTc/root
 template1 | root  | UTF8     | en_US.utf8 | en_US.utf8 | =c/root          +
           |       |          |            |            | root=CTc/root
 test_db   | root  | UTF8     | en_US.utf8 | en_US.utf8 | 
(4 rows)
```

>- подключение к БД

`\c[onnect] {[DBNAME|- USER|- HOST|- PORT|-] | conninfo}
                         connect to new database (currently "test_db")`

```bash
test_db=# \c test_db
You are now connected to database "test_db" as user "root".
```

>- вывод списка таблиц

`  \dt[S+] [PATTERN]      list tables`

```bash
test_db=# \dt
Did not find any relations.
```

>- вывод описания содержимого таблиц

`  \d[S+]  NAME           describe table, view, sequence, or index`

```bash
test_db=# \d
Did not find any relations.
```

>- выход из psql

`  \q                     quit psql`

```bash
test_db=# \q
postgres@c4c040ecc2ce:/$ 
```

## Задача 2

Используя `psql` создайте БД `test_database`.

Изучите [бэкап БД](https://github.com/netology-code/virt-homeworks/tree/master/06-db-04-postgresql/test_data).

Восстановите бэкап БД в `test_database`.

Перейдите в управляющую консоль `psql` внутри контейнера.

Подключитесь к восстановленной БД и проведите операцию ANALYZE для сбора статистики по таблице.

Используя таблицу [pg_stats](https://postgrespro.ru/docs/postgresql/12/view-pg-stats), найдите столбец таблицы `orders` 
с наибольшим средним значением размера элементов в байтах.

**Приведите в ответе** команду, которую вы использовали для вычисления и полученный результат.

Создал пользователя `postgres`, т.к изначально был под `root`.

```postgresql
test_database=# CREATE USER postgres WITH PASSWORD 'postgres';
CREATE ROLE
```

```postgresql
test_db=# CREATE DATABASE "test_database";
CREATE DATABASE
test_db=# \q
root@d605746f0495:/# psql -U root -d test_database < /var/lib/postgresql/backup/test_dump.sql
SET
SET
SET
SET
SET
 set_config 
------------
 
(1 row)

SET
SET
SET
SET
SET
SET
CREATE TABLE
ALTER TABLE
CREATE SEQUENCE
ALTER TABLE
ALTER SEQUENCE
ALTER TABLE
COPY 8
 setval 
--------
      8
(1 row)
```
Подключимся к восстановленной БД.

```postgresql
root@d605746f0495:/# psql -d test_database
psql (13.7 (Debian 13.7-1.pgdg110+1))
Type "help" for help.

test_database=# 
```

Проведем операцию `ANALYZE`.

```postgresql
test_database=# ANALYZE VERBOSE orders;
INFO:  analyzing "public.orders"
INFO:  "orders": scanned 1 of 1 pages, containing 8 live rows and 0 dead rows; 8 rows in sample, 8 estimated total rows
ANALYZE
```

Найдем столбец таблицы `orders` с наибольшим средним значением размера элементов в байтах.

```postgresql
test_database=# SELECT MAX(avg_width) FROM pg_stats WHERE tablename = 'orders';
 max 
-----
  16
(1 row)
```

## Задача 3

Архитектор и администратор БД выяснили, что ваша таблица orders разрослась до невиданных размеров и
поиск по ней занимает долгое время. Вам, как успешному выпускнику курсов DevOps в нетологии предложили
провести разбиение таблицы на 2 (шардировать на orders_1 - price>499 и orders_2 - price<=499).

Предложите SQL-транзакцию для проведения данной операции.

Можно ли было изначально исключить "ручное" разбиение при проектировании таблицы orders?

```postgresql
test_database=# CREATE TABLE orders_1 (CHECK (price > 499)) INHERITS (orders);
CREATE TABLE
test_database=# CREATE TABLE orders_2 (CHECK (price <= 499)) INHERITS (orders);
CREATE TABLE
test_database=# INSERT INTO orders_1 SELECT * FROM orders WHERE price > 499;
INSERT 0 3
test_database=# INSERT INTO orders_2 SELECT * FROM orders WHERE price <= 499;
INSERT 0 5
test_database
```

Исключить "ручное" разбиение можно было путем создания секционированной таблицы.  
Указание секционирования состоит из определения метода секционирования и списка столбцов или выражений, которые будут составлять ключ разбиения.

Необходимо было добавить `PARTITION BY RANGE (price);`

## Задача 4

Используя утилиту `pg_dump` создайте бекап БД `test_database`.

Как бы вы доработали бэкап-файл, чтобы добавить уникальность значения столбца `title` для таблиц `test_database`?

Создадим бэкап.

```bash
root@d605746f0495:/# pg_dump -U root -d test_database > /var/lib/postgresql/backup/new_test_dump.sql
```

Для добавления уникальности значения столбца `title` необходимо использовать атрибут `UNIQUE`.

```postgresql
title CHARACTER VARYING(30) UNIQUE 
```

---