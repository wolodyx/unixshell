# Разбор аргументов программы

Под аргументами командной строки мы подразумеваем данные, передаваемые запускаемой программе из командной строки.
Аргументы разделяются друг от друга пробелами или табуляцией.
Имя программы составляет первый и обязательный аргумент.

<!-- more -->

`user@host:~$ ls -rhl --all --sort size ~`

Вывод на экран файлов и каталогов (команда `ls`) и скрытого содержимого (опция `--all`) домашнего каталога (операнд `~`) с подробной информацией (опция `-l`), отсортированных по размеру (опция `--sort size`) в обартном порядке (опция `-r`) в удобном для восприятия формате размера (опция `-h`).

Как видим, аргументы командной строки не совпадают с опциями.
Аргумент содежит одновременно 3 опции (-rhl) или только опцию (--sort), но без ее значения (size).
Нужна дополнительная обработка данных, которая бы разобрала и извлекла опции, значения опций и операнды программы.

Каждая утилита UNIX начинает работу с разбора аргументов командной строки.
Чтобы упростить эту работу и прийти к единому соглашению, было решено реализовать общие функции разбора.
Для разбора параметров командной строки воспользуемся существующим решением -- функциями getopt и getopt_long и набором глобальных переменных optarg, optind, opterr, optopt.
Функции входят в состав ОС UNIX в виде библиотеки Си.
Справочная информация man 3 getopt.

Программа на Си начинается с главной функции:
```c
int main(int argc, char** argv)
```
Функция на вход принимает два аргумента:
* `argc`, количество переданных в программу аргументов;
* `argv`, список аргументов.

```c
#include <stdio.h>

int main(int argc, char** argv)
{
  int i;
  for(i = 0; i < argc; ++i)
    printf("argv[%d] = %s\n", i, argv[i]);
  return 0;
}
```

## Разбор коротких опций

Функция getopt разбирает аргументы командной строки на короткие опции.
При этом длинные опции она не поддерживает.
`int getopt(int argc, char* const argv[], const char* optstring)`
Первые два аргумента функции, `argc` и `argv`, определяют количество и массив аргументов командной строки.
Они поставляются главной функцией `main` программы.
Третий аргумент `optstring` задает список всех допустимых опций в виде строки.
При каждом вызове функции `getopt` извлекает из аргументов командной строки следующую опцию и ее значение (если она задана).
Если разбор опций заканчивается, то функция возвращает `-1`.
Цикл разбора будет выглядеть как:

```c
#include <stdio.h>
#include <unistd.h>

int main(int argc, char** argv)
{
  while(1)
  {
    int c = getopt(argc, argv, "ab:c::");
    if(c == -1)
      break;
  }
  return 0;
}
```

Формат `optstring` следующий.
В ней перечислены буквенные символы опций.
Если опция принимает значение, то после нее ставят символ `:`.
Если опция принимает значение, но оно необязательно, то ставят два символа -- `::`.
В примере выше определены три опции `-a`, `-b`, `-c`.
Опция `-a` без параметра, опция `-b` с обязательным параметром, а опция `-c` может иметь или не иметь параметр.
Функция `getopt` возрвщает символ разобранной опции, а ее значение (если оно задано), заносится в глобальную переменную `optarg`.
Если значение на задано, то `optarg=0`.

```c
#include <stdio.h>
#include <unistd.h>

int main(int argc, char** argv)
{
  while(1)
  {
    int c = getopt(argc, argv, "ab:c::");
    if(c == -1)
      break;

    switch(c)
    {
    case 'a':
      break;
    case 'b':
      break;
    case 'c':
      break;
    };
  }
  return 0;
}
```

Если во время разбора встретится опция, которой нет в списке `optstring`, то функция `getopt` вернет символ `?`, а символ опции заносится в `optopt`.
Сообщение об ошибке разбора выведется в `stderr`.
Чтобы заблокировать вывод сообщения об ошибке, глобальная переменная `opterr` устанавливается в `0`.

```c
#include <stdio.h>
#include <unistd.h>

int main(int argc, char** argv)
{
  opterr = 1;
  while(1)
  {
    int c = getopt(argc, argv, "ab:c::");
    if(c == -1)
      break;
    switch(c)
    {
    case '?':
      fprintf(stderr, "Try \"%s\" with options -a, -bParam or -c (-cParam)\n", argv[0]);
      return 1;
    case 'a':
      break;
    case 'b':
      break;
    case 'c':
      break;
    };
  }
  return 0;
}
```

При повторном вызове функции `getopt` нужно знать, где она остановила разбор.
Это состояние хранится в глобальной переменной `optind` -- индекс необработанного аргумента в массиве `argv`.
В самом начале ей назначена `1`.
Если понадобиться разобрать заново аргументы в строке, `optind` устанавливают в 1.
Когда разбор опций заканчивается, т.е. функция getopt возвращает -1, а `optind` указывает на первый аргумент, который не относится к опциям.
За опциями команды следуют параметры команды.
Чтобы их извлечь, воспользуемся кодом:

```c
  while(optind < argc)
    printf("operand = %s\n", argv[optind++]);
```

## Разбор длинных опций

Функция `getopt_long` разбирает не только короткие, но и длинные опции.
Она ведет себя также, как и `getopt`.
`int getopt_long(int argc, char* const argv[], const char* optstring, const struct option* longopts, int* longindex)`
Первые три параметра аналогичны функции `getopt`.
Остальные два аргумента связаны с длинными опциями.
Рассмотрим их подробнее.

Аргумент `longopts` содержит описание всех допустимых длинных опций -- *таблицей длинных опций*.
Это описание задается массивом записей типа `option`, объявленного в заголовочном файле `getopt.h`:

```c
struct option
{
  const char* name;
  int has_arg;
  int* flag;
  int val;
};
```
* `name`, имя длинной опции.
* `has_arg`, признак присутствия аргумента у опции.
Три возможных значения, которые заданы именованными константами: без аргумента (`no_argument`), с аргументом (`required_argument`) или с необязательным аргументов (`optional_argument`).
* `flag`, указывает на переменную, которую необходимо проинициализировать при встрече с опцией.
Переменная инициализируется значением поля `val`.
Если `flag` не задан, то функция `getopt_long` возвращает значение `val`.
* `val`, значение, ассоциированное с опцией.

Последний аргумент массива `longopts` инициализируется структурой `option`, заполненной нулями.
Аргумент `longindex`, если он задан, на выходе инициализируется индексом разобранной опции в структуре `longopts`.
Функция возвращает для длинных опций поле val из структуры option или 0, если задано после `flag`, или символ короктой опции.
-1, если разор опций закончился или `?` если встретились с неизвестной опцией или с опцией без параметра.

## Вопросы для самоконтроля

1. Пусть программа `program` вызвана с тремя опциями `-a`, `-b`, `-c` следующим образом: `./program -abc`.
   Функция `getopt` вызовется три раза, пока не вернет -1.
   Но при первом и втором его вызове глобальная переменная `optind` останется равным 1.
   Каким образом функция узнает, откуда начать разбор.
2. Как передать программе один составной аргумент `hello world`?
   Тогда как `./program hello world` интерпретируется как два аргумента.