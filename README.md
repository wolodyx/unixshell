# Учебное пособие по теме "Командная оболочка UNIX"

[Ссылка](https://wolodyx.github.io/unixshell/intro.html) на собранный учебник.

## Настройка системы для сборки учебника

Учебник создан на базе [jupyter-book](https://jupyterbook.org/intro.html).

На хост-машине следует установить docker, который нужен для построения образа и запуска контейнера.
Для этого введите команды
```
sudo docker build -t unixshell .
sudo docker run --volume $(pwd):/book --rm unixshell
```
Затем откройте бразуером появившийся файлы `_build/html/index.html`.
Файл обновляется после сохранения изменений в исходных файлах.

## Полезные ссылки

* https://habr.com/ru/companies/ruvds/articles/961514/
