# Утилита less

<!--
По умолчанию поиск учитывает регистр символа.
Изменить это позволяет опция `-i`, которая включит регистронезависимый поиск.

```{tip}
Если клавиша `q` не закрывает просмотр, переключите раскладку клавиатуры на английскую.
```
-->

Посмотреть содержимое файла -- значит вывести его на экран, что и выполняет утилита `cat`.
Она по умолчанию отправляет на экран содержимое файлов, переданных через аргументы командной строки.
Если содержимое не влезет на экран, то начало файла скроется.
Эмулятор терминала обладает внутренним буфером, пролистываемый вертикальным ползунком графического окна.
Такой вариант не подойдет, так как буфер может переполниться или отсутствовать, как, например, в виртуальном терминале.
Нужна интерактивная утилита, которая обладает своим буфером и позволяла пролистывать экран.
Для просмотра файлов принято использовать утилиту `less`.
Она получила такое название от более ранней альтернативы `more`, которая позволяла пролистывать содержимое только вниз.

Утилита `less` отображает в терминале текстовые данные, получаемые из файлов или других программ.
Кроме просмотра файлов, она интегрирована в справочную систему `man` для просмотра страниц справки, а также применяется совместно с перенаправлением потоков для перехвата данных из других утилит и их удобного просмотра.
Она не позволяет редактировать текст, поэтому не обладает курсором для позиционирования.
Она работает быстрее по сравнению с текстовыми редакторами, особенно на больших файлах, за счет их фрагментной загрузки и отсутствия сложных структур данных для представления редактируемого текста.

Утилита `less` из командной строки вызывается командой `less filename`.
Чтобы завершить просмотр файла, наберите команду `q`.
Изучим управление отображением текста, перемещение и поиск по файлу.

Отображаемый текст настраивается через опции, передаваемые из командной строки сразу после команды, но до имени файла.
Если их ввести после имени файла, то эффекта они не дадут.
Опции также можно ввести и во время просмотра.
Опция `-s` убирает незаполненное пространство между строками, заменяя подряд идущие пустые строки одной пустой строкой.
По умолчанию строки, не помещающиеся в одну строку, переносятся на следующую строку.
Опция `-S` отсекает длинные строки по ширине экрана вместо переноса на следующую строку.
Если пользователю интересуют номера строк, то опция `-N` отобразит их слева от строк.
Опции могут быть скомбинированы: команда `less -N -S system.log` отобразит файл с нумерацией строк и отсечет длинные строки.

```{note}
Важно! Опции должны располагаться до имени отображаемого файла!
```

Поиск является важным действием при изучении текстовых документов, так как вместо просмотра и изучения всего файла, позволяет найти нужную информацию по ключевому слову.
По умолчанию поиск учитывает регистр символа.
Изменить это позволяет опция `-i`, которая включит поиск без учета регистра.
Фразы для поиска вводят после команды `/` (`/text`) и завершают по клавише `Enter`.
Найденные символы подсвечиваются в тексте.
Перемещением по ним происходит по нажатию на `n` (команда образована сокращением от `next`).
Команда `N` выполняет поиск в обратном направлении (вверх по тексту).

В отличие от текстового редактора в `less` нет курсора.
Поэтому перемещение заключается в пролистывании содержимого вверх и вниз.
Для перемещений подходят клавиши управления курсором `↓`, `↑`, `PgDn`, `PgUp`, `End`, `Home`.
Существуют альтернативные однобуквенные команды, которые перечислены в таблице ниже.

| Клавиша | Команда |     Пролистывание    |
|---------|---------|----------------------|
|    ↓    |   `j`   |на одну строку вниз   |
|    ↑    |   `k`   |на одну строку вверх  |
|  PgUp   |   `w`   |на высоту экран вверх |
|  PgDn   |   `z`   |на высоту экрана вниз |
|   End   |   `G`   |в конец файла         |
|  Home   |   `g`   |в начало файла        |

Команда перемещения повторится несколько раз, если перед ней указать число повтора.
`5j` переместит экран на 5 строк вниз, `2z` пролистает два раза вниз на высоту экрана.

Если известен номер строки, то переход на нее выполняют по команде `<num>g`.

Информация об открытом файле отображается снизу, в строке состояния, по команде `:f`.
В строке состояния уже отображается символ `:` и пользователь вводит только символ `f`.
Введите оба символа.
Команда полезна, если пользователь отвлекся от работы, вернулся к ней позже и успел забыть, какой именно файл он открывал.

Встроенная в утилиту краткая справка по командам (шпаргалка) отображается по команде `h` и исчезает по `q`.
Полную справку об утилите можно получить командой `man less` из терминала.

## Вопросы для самоконтроля

1. Выведите на экран с помощью «cat» содержимое короткого файла.
1. Приведите отличия «less» от текстовых редакторов.
1. Как в отображении текста убрать незаполненное пространство?
1. Как в отображении текста срезать длинные строки?
1. Как в отображении текста включить нумерацию строк?
1. Как выполняется поиск по ключевому слову и переход (вперед и обратно) к следующему слову?
1. Перечислите команды для перемещения по файлу, повторяющие действия клавиш управления курсором.
1. Как повторить команды перемещения?
1. Как перейти на заданную строку?
1. Как узнать информацию об открытом файле?
1. Отобразите шпаргалку по командам, найдите и продемонстрируйте новую для себя команду.

Исходные данные в каталоге less:
* `short_content.txt` -- файл с коротким содержанием;
* `blank_lines.log` -- файл с незаполненным пространством;
* `long_lines.txt` -- файл с длинными строками.
