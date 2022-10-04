# rasdark_microservices

rasdark microservices repository

## Выполнено ДЗ №18

<details>
  <summary>Решение</summary>

- [x] Основное ДЗ
- [x] Дополнительное ДЗ

## В процессе сделано

- Собран и исследован кубер-кластер "вручную"
- Запущены недоделанные подики приложения
- Дополнительное задание: разврачивание кубер-кластера terraform + ansible

## Как проверить

Развернуть кубер-кластер

```bash
cd kubernetes/terraform && terraform init && terraform apply
```

Подключиться к мастеру

```bash
ssh -i ~/.ssh/appuser ubuntu@178.154.205.54
```

Посмотреть список нод:

```bash
kubectl get nodes
```

</details>

## Выполнено ДЗ №17

<details>
  <summary>Решение</summary>

- [x] Основное ДЗ
- [x] Дополнительное ДЗ

## В процессе сделано

- Всё по методичке
- Все дополнительные задания

## Как проверить

Создаём инстанс

```bash
yc compute instance create   --name logging   --memory=6   --zone ru-central1-a   --network-interface subnet-name=default-ru-central1-a,nat-ip-version=ipv4   --create-boot-disk image-folder-id=standard-images,image-family=ubuntu-1804-lts,size=15   --ssh-key ~/.ssh/appuser.pub
```

Создаём докер-машин

```bash
docker-machine create   --driver generic   --generic-ip-address=130.193.49.159   --generic-ssh-user yc-user   --generic-ssh-key ~/.ssh/appuser   logging
```

Подключаемся

```bash
eval $(docker-machine env docker-host)
```

Выполняем всё по методичке. Доходим удивительного опыта траблшутинга с помощью системы логирования и зипкина.

Собираем образы контейнеров с багованным кодом, правим docker_build скрипт (тегируем bugged), поднимаем новые контейнеры с приложением.

Идём на основную страничку - ок. Идём в любой пост - видим что описанная проблема реальна. Проваливаемся в зипкин и..

![ci-1](./logging/images/logging-1.png)

Видим реальную задержку, видим в каком контейнере (post), видим эндпоинт (/post) и зипкин спан нэйм (db_find_single_post).

Открываем основной код post-py (post_app.py), ищем по зипкин спан нейм, всматриваемся в код и видим, что какой-то молодец установил задержку в 3 сек с помощью sleep.

Убираем строчку (или камментим), пересобираем образ контейнера post, поднимаем контейнер, пытаемся воспроизвести баг - а его больше нет =)
</details>

## Выполнено ДЗ №16

<details>
  <summary>Решение</summary>

- [x] Основное ДЗ
- [x] Дополнительное ДЗ

## В процессе сделано

- Всё по методичке
- Все дополнительные задания

## Как проверить

Создаём инстанс

```bash
yc compute instance create   --name docker-host   --memory=8   --zone ru-central1-a   --network-interface subnet-name=default-ru-central1-a,nat-ip-version=ipv4   --create-boot-disk image-folder-id=standard-images,image-family=ubuntu-1804-lts,size=50   --ssh-key ~/.ssh/appuser.pub
```

Создаём докер-машин

```bash
docker-machine create   --driver generic   --generic-ip-address=51.250.10.50   --generic-ssh-user yc-user   --generic-ssh-key ~/.ssh/appuser   docker-host
```

Подключаемся

```bash
eval $(docker-machine env docker-host)
```

Собираем образы, пушим в хаб, запускаем докеры

```bash
cd monitoring && make
```

</details>

## Выполнено ДЗ №15

<details>
  <summary>Решение</summary>

- [x] Основное ДЗ
- [x] Дополнительное ДЗ

## В процессе сделано

- Все по методичке

## Возникшие проблемы

В процессе работы возникла только одна проблема: не хватка памяти при запуске теста в раннере.
Решение: пересоздать инстанс в облаке с 8Гб ОЗУ.

## Как проверить

Создаем инстанс

```bash
yc compute instance create   --name gitlab-host   --memory=8   --zone ru-central1-a   --network-interface subnet-name=default-ru-central1-a,nat-ip-version=ipv4   --create-boot-disk image-folder-id=standard-images,image-family=ubuntu-1804-lts,size=50   --ssh-key ~/.ssh/appuser.pub
```

Правим инвентори

Разворачиваем GitLab

```bash
cd gitlab-ci/ansible && ansible-playbook gitlab_prepare.yml
```

Ждём пару-тройку минут. Идём по урлу <http://внешний_адрес_>инстанса - ГитЛаб работает.

Ищём рутовй пароль гитлаба, вариантов несколько, самый простой, в лоб:

```bash
ssh -i ~/.ssh/appuser yc-user@178.154.203.135 sudo grep -i "password:" /srv/gitlab/config/initial_root_password
```

Логинимся в гитлаб, отключаем регистрацию, ищем токен регистрации раннера.

Создаём контейнер с раннером и регистрируем в гитлабе.

```bash
ansible-playbook -e 'GITLAB_TOKEN="GR1348941BHDrqFq_t8zrTJ2P3jsq"' gitlab_runner.yml
```

![runner](./gitlab-ci/images/runner.png)

Сразу добавляем интеграцию со слак: зовём webhook integration, получаем вебхук урл, вгоняем в настройки в гитлаб интегрейшен, жмякаем кнопки на что тригерриться гитлабу, сохраняем.

Работу моего веб-хука посмотреть можно тут: [C03KQ35UW4A](https://devops-team-otus.slack.com/archives/)

![ci-1](./gitlab-ci/images/ci-1.png)
![ci-3](./gitlab-ci/images/ci-3.png)
![envs](./gitlab-ci/images/envs.png)

</details>

## Выполнено ДЗ №14

<details>
  <summary>Решение</summary>

- [x] Основное ДЗ
- [x] Дополнительное ДЗ: docker-compose.override

## В процессе сделано

- Разобрался с работой сетей в докере
- Работа с docker-compose
- docker-compose.override

### Docker Compose

Параметризация осуществляется путем создания из .env.example - .env с заполнением переменных.

Имя проекта формируется из имени корневой папки для docker-compose.yml (src). Переопределить можно
2мя способами:

```bash
docker-compose -p Имя-проекта up -d
```

Задание переменной COMPOSE_PROJECT_NAME в .env

### Docker-compose.override

Чтобы не тащить каталоги проекта на docker-host, сборку сделал на localhost.

</details>

## Выполнено ДЗ №13

<details>
  <summary>Решение</summary>

- [x] Основное ДЗ
- [x] Дополнительное ДЗ: переопределение сетевых алиасов и запуск контейнеров с передачей переменных окружения
- [x] Дополнительное ДЗ: оптимизация образов с использованием в качестве базового alpine

## В процессе сделано

- Подготовка docker-host.
  Так как в предыдущем ДЗ работали с packer (который в процессе работы создаёт сеть), сети все
  удалили. Поэтому сперва создадим их:

  ```shell
  yc vpc network create default --description "Default network"
  yc vpc subnet create default-ru-central1-a --zone ru-central1-a --network-name default --range 10.121.0.0/24
  ```

  Создадим инстанс в Ya.Cloud

  ```shell
  yc compute instance create \
    --name docker-host \
    --zone ru-central1-a \
    --network-interface subnet-name=default-ru-central1-a,nat-ip-version=ipv4 \
    --create-boot-disk image-folder-id=standard-images,image-family=ubuntu-1804-lts,size=15 \
    --ssh-key ~/.ssh/appuser.pub
  ```

  Затем я столкнулся с проблемой при добавлении хоста в docker-machine (отуствие **netstat** на хосте).
  Которая решается просто:

  ```shell
  ssh -i ~/.ssh/appuser yc-user@51.250.78.165 'sudo apt install net-tools'
  ```

  После этого с docker-machine всё хорошо =)

  ```shell
  docker-machine create \
    --driver generic \
    --generic-ip-address=51.250.78.165 \
    --generic-ssh-user yc-user \
    --generic-ssh-key ~/.ssh/appuser \
    docker-host
  ```

- Подготовка исходников микросервисов, подготовка и сборка докер-образов.

  На этом этапе столкнулся с проблемой:
  При попытке собрать образ сервиса post-py словил ошибку установки модуля MarkupSafe.
  Ошибка решилась просто добавлением шага обновление pip в докер-файле (древниве версии pip не умеют в Python-Requires метаданные)

- Создание сети, запуск контейнеров в указанной сети. Проверка работы приложения
- Задание с * (переопределение сетевых алиасов и запуск контейнеров с передачей переменных окружения)

```shell
docker run -d --network=reddit --network-alias=my_post_db --network-alias=my_comment_db mongo:latest

docker run -d --network=reddit --network-alias=my_post --env POST_DATABASE_HOST=my_post_db rasdark/post:1.0
docker run -d --network=reddit --network-alias=my_comment --env COMMENT_DATABASE_HOST=my_comment_db  rasdark/comment:1.0
docker run -d --network=reddit -p 9292:9292 --env POST_SERVICE_HOST=my_post --env COMMENT_SERVICE_HOST=my_comment rasdark/ui:1.0
```

- Оптимизация образа сервиса ui с использованием в качестве базового образа - ubuntu:16

  Результат:

  ```shell
  REPOSITORY        TAG            IMAGE ID       CREATED          SIZE
  rasdark/ui        2.0            35c85db41635   17 seconds ago   464MB
  rasdark/ui        1.0            b7c473ac91ba   17 minutes ago   771MB
  ```

- Задание с *: оптимизация образов с использованием в качестве базового alpine

  Результат UI:

  ```shell
  REPOSITORY        TAG            IMAGE ID       CREATED          SIZE
  rasdark/ui        3.0            3741e0adbefc   5 seconds ago    266MB
  rasdark/ui        2.0            35c85db41635   11 minutes ago   464MB
  rasdark/ui        1.0            b7c473ac91ba   28 minutes ago   771MB
  ```

  Результат COMMENT:

  ```shell
  REPOSITORY        TAG            IMAGE ID       CREATED          SIZE
  rasdark/comment   2.0            7fde219e1bfb   11 seconds ago   263MB
  rasdark/comment   1.0            21dae36d6770   35 minutes ago   769MB
  ```

  С сервисом POST-PY накладочка =) В методичке уже был оптимизированный образ на базе alpine

  Итого:

  ```shell
  CONTAINER ID   IMAGE                 COMMAND                  CREATED         STATUS         PORTS            NAMES
  1767fa65cb7f   rasdark/comment:2.0   "puma"                   3 seconds ago   Up 1 second                       lucid_lumiere
  b2f46f7beb32   rasdark/ui:3.0        "puma"                   5 minutes ago   Up 4 minutes   0.0.0.0:9292->9292/tcp, :::9292->9292/tcp   loving_ritchie
  72eeb0576601   rasdark/post:1.0      "python3 post_app.py"    5 minutes ago   Up 5 minutes                       agitated_jepsen
  9b50aa8faadb   mongo:latest          "docker-entrypoint.s…"   5 minutes ago   Up 5 minutes   27017/tcp           mystifying_fermi
  ```

- Создание тома, подключение тома к контейнеру с монгой, проверка работы приложения в целом (с остановкой контейнера с базой)

</details>

## Выполнено ДЗ №12

<details>
  <summary>Решение</summary>

- [x] Основное ДЗ
- [x] Дополнительное ДЗ: сказ о разнице между образом и контейнером
- [x] Дополнительное ДЗ: инфраструктура приложения с помощью packer, terraform, ansible

### В процессе сделано

- Установка, настройка, работа с docker, docker-machine
- Настройка docker-machine для работы с докером внутри виртуалки в Яндекс.Облако
- Сборка образа на хосте в Облаке
- Работа с Docker Hub (регистрация, пуш, пул в локальную среду для проверки)
- Разработана инфраструктура приложения с помощью packer, terraform, ansible

### Задания с *

Разница между образом и контейнером описана в файле docker-1.log

Инфраструктура подготовлена в **infra/**

Для проверки работы инфраструктуры необходимо:

- Создать базовый образ с установленным докером с помощью packer.

```shell
cd infra/packer
packer build -var-file=variables.json docker.json
```

- Указать необходимое число инстансов в terraform.tfvars (переменная instance_count)
- Подготовить инстансы с помощью terraform

```shell
cd ../terraform
terraform apply
```

- Задеплоить приложение с помощью ansible

```shell
cd ../ansible
ansible-playbook playbooks/docker_run.yml
```

</details>
