# rasdark_microservices
rasdark microservices repository

# Выполнено ДЗ №12

 - [x] Основное ДЗ
 - [x] Дополнительное ДЗ: сказ о разнице между образом и контейнером
 - [x] Дополнительное ДЗ: инфраструктура приложения с помощью packer, terraform, ansible

## В процессе сделано
 - Установка, настройка, работа с docker, docker-machine
 - Настройка docker-machine для работы с докером внутри виртуалки в Яндекс.Облако
 - Сборка образа на хосте в Облаке
 - Работа с Docker Hub (регистрация, пуш, пул в локальную среду для проверки)
 - Разработана инфраструктура приложения с помощью packer, terraform, ansible

## Задания с *

Разница между образом и контейнером описана в файле docker-1.log

Инфраструктура подготовлена в **infra/**

Для проверки работы инфраструктуры необходимо:

- Создать базовый образ с установленным докером с помощью packer.
```
cd infra/packer
packer build -var-file=variables.json docker.json
```

- Указать необходимое число инстансов в terraform.tfvars (переменная instance_count)
- Подготовить инстансы с помощью terraform
```
cd ../terraform
terraform apply
```

- Задеплоить приложение с помощью ansible
```
cd ../ansible
ansible-playbook playbooks/docker_run.yml
```

