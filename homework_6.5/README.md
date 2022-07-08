# Домашнее задание к занятию "6.5. Elasticsearch"

## Задача 1

В этом задании вы потренируетесь в:
- установке elasticsearch
- первоначальном конфигурировании elastcisearch
- запуске elasticsearch в docker

Используя докер образ [centos:7](https://hub.docker.com/_/centos) как базовый и 
[документацию по установке и запуску Elastcisearch](https://www.elastic.co/guide/en/elasticsearch/reference/current/targz.html):

- составьте Dockerfile-манифест для elasticsearch
- соберите docker-образ и сделайте `push` в ваш docker.io репозиторий
- запустите контейнер из получившегося образа и выполните запрос пути `/` c хост-машины

Требования к `elasticsearch.yml`:
- данные `path` должны сохраняться в `/var/lib`
- имя ноды должно быть `netology_test`

В ответе приведите:
- текст Dockerfile манифеста
- ссылку на образ в репозитории dockerhub
- ответ `elasticsearch` на запрос пути `/` в json виде

Подсказки:
- возможно вам понадобится установка пакета perl-Digest-SHA для корректной работы пакета shasum
- при сетевых проблемах внимательно изучите кластерные и сетевые настройки в elasticsearch.yml
- при некоторых проблемах вам поможет docker директива ulimit
- elasticsearch в логах обычно описывает проблему и пути ее решения

Далее мы будем работать с данным экземпляром elasticsearch.

---

`Dockerfile`:

```dockerfile
FROM centos:7

LABEL Ivan Gavryushin <addzt@yandex.ru>

EXPOSE 9200 9300

RUN yum update -y && yum upgrade -y && \
    yum -y install perl-Digest-SHA wget curl

RUN wget -c https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-8.1.0-linux-x86_64.tar.gz && \
    wget -c https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-8.1.0-linux-x86_64.tar.gz.sha512 && \
    shasum -a 512 -c elasticsearch-8.1.0-linux-x86_64.tar.gz.sha512 && \
    tar -xzf elasticsearch-8.1.0-linux-x86_64.tar.gz 

RUN groupadd elasticsearch && \
    useradd -g elasticsearch elasticsearch && \ 
    chown -R elasticsearch:elasticsearch /elasticsearch-8.1.0 && \
    mkdir /var/lib/logs && \
    chown elasticsearch:elasticsearch /var/lib/logs && \    
    mkdir /var/lib/data && \
    chown elasticsearch:elasticsearch /var/lib/data

COPY elasticsearch.yml /elasticsearch-8.1.0/config

WORKDIR /elasticsearch-8.1.0

USER elasticsearch

CMD ["./bin/elasticsearch"]
```

```bash
PS C:\homework_6.5> docker push addzt/elastic
Using default tag: latest
The push refers to repository [docker.io/addzt/elastic]
5f70bf18a086: Pushed
caa3983f9461: Pushed
b6cc298b25ad: Pushed
53c96044ef5d: Pushed
e6591a3b2360: Pushed
174f56854903: Mounted from library/centos
latest: digest: sha256:1bc56533c2c7f14b3f04641c993c854c747f7889f6b95aa2950ebdca1836197f size: 1582
```

[ссылка на hub.docker.com](https://hub.docker.com/r/addzt/elastic)

`elasticsearch.yml`:

```yaml
discovery.type: single-node
node.name: netology_test
path.data: /var/lib/data
path.logs: /var/lib/logs
network.host: 0.0.0.0
http.port: 9200
xpack.security.enabled: false
xpack.security.http.ssl.enabled: false
xpack.security.transport.ssl.enabled: false
```

Вывод: `curl http://localhost:9200/`.

```bash
PS C:\homework_6.5> docker exec -it elasticsearch /bin/sh
sh-4.2$ curl http://localhost:9200/
{
  "name" : "netology_test",
  "cluster_name" : "elasticsearch",
  "cluster_uuid" : "inETjWMOQzmAHgaaehIRUw",
  "version" : {
    "number" : "8.1.0",
    "build_flavor" : "default",
    "build_type" : "tar",
    "build_hash" : "3700f7679f7d95e36da0b43762189bab189bc53a",
    "build_date" : "2022-03-03T14:20:00.690422633Z",
    "build_snapshot" : false,
    "lucene_version" : "9.0.0",
    "minimum_wire_compatibility_version" : "7.17.0",
    "minimum_index_compatibility_version" : "7.0.0"
  },
  "tagline" : "You Know, for Search"
}
```

## Задача 2

В этом задании вы научитесь:
- создавать и удалять индексы
- изучать состояние кластера
- обосновывать причину деградации доступности данных

Ознакомтесь с [документацией](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-create-index.html) 
и добавьте в `elasticsearch` 3 индекса, в соответствии со таблицей:

| Имя | Количество реплик | Количество шард |
|-----|-------------------|-----------------|
| ind-1| 0 | 1 |
| ind-2 | 1 | 2 |
| ind-3 | 2 | 4 |

Получите список индексов и их статусов, используя API и **приведите в ответе** на задание.

Получите состояние кластера `elasticsearch`, используя API.

Как вы думаете, почему часть индексов и кластер находится в состоянии yellow?

Удалите все индексы.

**Важно**

При проектировании кластера elasticsearch нужно корректно рассчитывать количество реплик и шард,
иначе возможна потеря данных индексов, вплоть до полной, при деградации системы.

---

```bash
sh-4.2$ curl -XPUT "http://localhost:9200/ind-1" -H 'Content-Type: application/json' -d'{  "settings": { "number_of_shar
ds": 1, "number_of_replicas": 0 }}'
sh-4.2$ curl -XPUT "http://localhost:9200/ind-2" -H 'Content-Type: application/json' -d'{  "settings": { "number_of_shar
ds": 2, "number_of_replicas": 1 }}'
sh-4.2$ curl -XPUT "http://localhost:9200/ind-3" -H 'Content-Type: application/json' -d'{  "settings": { "number_of_shar
ds": 4, "number_of_replicas": 2 }}'"
```

Получим список индексов и их статусов.

```bash
sh-4.2$ curl -XGET http://localhost:9200/_cat/indices
green  open ind-1 hTlZRLaXRDynsYuqwemzVQ 1 0 0 0 225b 225b
yellow open ind-3 VhrrpbwkT6i0lqE0tHDRiA 4 2 0 0 900b 900b
yellow open ind-2 7Fz9MOXCRZ-LdXS2jRMmfg 2 1 0 0 450b 450b
```

Получим состояние кластера `elasticsearch`.

```bash
sh-4.2$ curl http://localhost:9200/_cluster/health?pretty
{
  "cluster_name" : "elasticsearch",
  "status" : "yellow",
  "timed_out" : false,
  "number_of_nodes" : 1,
  "number_of_data_nodes" : 1,
  "active_primary_shards" : 8,
  "active_shards" : 8,
  "relocating_shards" : 0,
  "initializing_shards" : 0,
  "unassigned_shards" : 10,
  "delayed_unassigned_shards" : 0,
  "number_of_pending_tasks" : 0,
  "number_of_in_flight_fetch" : 0,
  "task_max_waiting_in_queue_millis" : 0,
  "active_shards_percent_as_number" : 44.44444444444444
}
```

У первого индекса указано количество реплик `0`, поэтому его статус `green`. Остальным индексам некуда реплицировать.

Удалим все индексы.

```bash
sh-4.2$ curl -XDELETE 'http://localhost:9200/ind*'
```

---

## Задача 3

В данном задании вы научитесь:
- создавать бэкапы данных
- восстанавливать индексы из бэкапов

Создайте директорию `{путь до корневой директории с elasticsearch в образе}/snapshots`.

Используя API [зарегистрируйте](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-register-repository.html#snapshots-register-repository) 
данную директорию как `snapshot repository` c именем `netology_backup`.

**Приведите в ответе** запрос API и результат вызова API для создания репозитория.

Создайте индекс `test` с 0 реплик и 1 шардом и **приведите в ответе** список индексов.

[Создайте `snapshot`](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-take-snapshot.html) 
состояния кластера `elasticsearch`.

**Приведите в ответе** список файлов в директории со `snapshot`ами.

Удалите индекс `test` и создайте индекс `test-2`. **Приведите в ответе** список индексов.

[Восстановите](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-restore-snapshot.html) состояние
кластера `elasticsearch` из `snapshot`, созданного ранее. 

**Приведите в ответе** запрос к API восстановления и итоговый список индексов.

Подсказки:
- возможно вам понадобится доработать `elasticsearch.yml` в части директивы `path.repo` и перезапустить `elasticsearch`

---

Пересоберем образ `Docker`.

```dockerfile
FROM centos:7

LABEL Ivan Gavryushin <addzt@yandex.ru>

EXPOSE 9200 9300

RUN yum update -y && yum upgrade -y && \
    yum -y install perl-Digest-SHA wget curl

RUN wget -c https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-8.1.0-linux-x86_64.tar.gz && \
    wget -c https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-8.1.0-linux-x86_64.tar.gz.sha512 && \
    shasum -a 512 -c elasticsearch-8.1.0-linux-x86_64.tar.gz.sha512 && \
    tar -xzf elasticsearch-8.1.0-linux-x86_64.tar.gz

RUN groupadd elasticsearch && \
    useradd -g elasticsearch elasticsearch && \
    chown -R elasticsearch:elasticsearch /elasticsearch-8.1.0 && \
    mkdir /var/lib/logs && \
    chown elasticsearch:elasticsearch /var/lib/logs && \
    mkdir /var/lib/data && \
    chown elasticsearch:elasticsearch /var/lib/data && \
    mkdir /elasticsearch-8.1.0/snapshots && \
    chown elasticsearch:elasticsearch /elasticsearch-8.1.0/snapshots

COPY elasticsearch.yml /elasticsearch-8.1.0/config

WORKDIR /elasticsearch-8.1.0

USER elasticsearch

CMD ["./bin/elasticsearch"]
```

```yaml
discovery.type: single-node
node.name: netology_test
path.data: /var/lib/data
path.logs: /var/lib/logs
path.repo: /elasticsearch-8.1.0/snapshots
network.host: 0.0.0.0
http.port: 9200
xpack.security.enabled: false
xpack.security.http.ssl.enabled: false
xpack.security.transport.ssl.enabled: false
```

Зарегистрируем директорию как `snapshot repository`.

```bash
sh-4.2$ curl -XPUT http://localhost:9200/_snapshot/netology_backup?pretty -H 'content-type: application/json' -d'{ "type": "fs", "settings": { "location": "/elasticsearch-8.1.0/snapshots"}}'
{
  "acknowledged" : true
}
```

```bash
sh-4.2$ curl -XGET http://localhost:9200/_snapshot/netology_backup?pretty
{
  "netology_backup" : {
    "type" : "fs",
    "settings" : {
      "location" : "/elasticsearch-8.1.0/snapshots"
    }
  }
}
```

Создадим индекс `test` с 0 реплик и 1 шардом.

```bash
sh-4.2$ curl -XPUT "http://localhost:9200/test" -H 'Content-Type: application/json' -d'{  "settings": { "number_of_shards":
1, "number_of_replicas": 0 }}'
{"acknowledged":true,"shards_acknowledged":true,"index":"test"}
```

```bash
sh-4.2$ curl -XGET http://localhost:9200/_cat/indices
green open test SYzg09NAQlqMr-w5YsQW2Q 1 0 0 0 225b 225b
```

Создадим `snapshot`.

```bash
sh-4.2$ curl -XPUT http://localhost:9200/_snapshot/netology_backup/first_snapshot?wait_for_completion=true
{"snapshot":{"snapshot":"first_snapshot","uuid":"oepeIbb2SHyc22VSBpMl6A","repository":"netology_backup","version_id":8010099,"version":"8.1.0","indices":[".geoip_databases","test"],"data_streams":[],"include_global_state":true,"state":"SUCCESS","start_time":"2022-07-08T23:01:42.249Z","start_time_in_millis":1657321302249,"end_time":"2022-07-08T23:01:43.250Z","end_time_in_millis":1657321303250,"duration_in_millis":1001,"failures":[],"shards":{"total":2,"failed":0,"successful":2},"feature_states":[{"feature_name":"geoip","indices":[".geoip_databases"]}]}}
```

Список файлов в директории.

```bash
sh-4.2$ pwd
/elasticsearch-8.1.0
sh-4.2$ cd /elasticsearch-8.1.0/snapshots
sh-4.2$ ls -lha
total 48K
drwxr-xr-x 1 elasticsearch elasticsearch 4.0K Jul  8 23:01 .
drwxr-xr-x 1 elasticsearch elasticsearch 4.0K Jul  8 22:13 ..
-rw-r--r-- 1 elasticsearch elasticsearch  847 Jul  8 23:01 index-0
-rw-r--r-- 1 elasticsearch elasticsearch    8 Jul  8 23:01 index.latest
drwxr-xr-x 4 elasticsearch elasticsearch 4.0K Jul  8 23:01 indices
-rw-r--r-- 1 elasticsearch elasticsearch  18K Jul  8 23:01 meta-oepeIbb2SHyc22VSBpMl6A.dat
-rw-r--r-- 1 elasticsearch elasticsearch  351 Jul  8 23:01 snap-oepeIbb2SHyc22VSBpMl6A.dat
```

Удалим индекс `test` и создадим индекс `test-2`.

```bash
sh-4.2$ curl -XDELETE 'http://localhost:9200/test'
{"acknowledged":true}
```

```bash
sh-4.2$ curl -XPUT "http://localhost:9200/test-2" -H 'Content-Type: application/json' -d'{  "settings": { "number_of_shards
": 1, "number_of_replicas": 0 }}'
{"acknowledged":true,"shards_acknowledged":true,"index":"test-2"}
```

```bash
sh-4.2$ curl -XGET http://localhost:9200/_cat/indices
green open test-2 HXFNAPZ_RiW5EYojTq3cNA 1 0 0 0 225b 225b
```

Восстановим состояние из снапшота.

```bash
sh-4.2$ curl -XPOST localhost:9200/_snapshot/netology_backup/first_snapshot/_restore?pretty -H 'content-type: application/json'
{
  "accepted" : true
}
```

```bash
sh-4.2$ curl -XGET http://localhost:9200/_cat/indices
green open test-2 HXFNAPZ_RiW5EYojTq3cNA 1 0 0 0 225b 225b
green open test   iVDS5F2BR-en_c56Qf3GCA 1 0 0 0 225b 225b
```

