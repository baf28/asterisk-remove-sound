#!/bin/sh

#Скрипт удаления старых файлов при переполнении диска
# $1 - доспустимый размер занятого места в процентах, например 90, без знака процентов %    
# $2 - точка монтирования, например /var 
# $3 - имя каталога для очистки старых файлов, например /var/spool/asterisk/monitor/
# $4 - количество удаляемых файлов
# запускать так sh remove-old.sh 85 /var /var/spool/asterisk/monitor/ 1000
# Скрипт создал BAF mail: ya.baf28@yandex.kz tel: 87054516620
# @daily /var/lib/asterisk/bin/remove-old.sh 80 /var /var/spool/asterisk/monitor/ 1000 >> /var/log/asterisk/remove-old.log 2>&1
# https://linux-freebsd.ru/linux/linux-pro4ee/skript-proverki-svobodnogo-diskovogo-prostranstva-v-linux/
# https://www.linux.org.ru/forum/admin/11261088

if [ "$#" -eq 4 ]
   then

#Определяем переменные из аргуметов переданных скрипту
NOT_MORE_PERCENT=$1
MOUNT_POINT=$2
TARGET_DIRECTORY=$3
N_FILES=$4

#Выводим дату начала очистки диска
DATE=`date "+%F %T"`
echo "$DATE приступаю к очистки диска"

#Определяем процент занятого места на диске по точке монтирования этого диска
REAL_PERCENT=$(df -h | grep $MOUNT_POINT | awk '{print $5}' | sed 's/.$//')

#В случае если реальный процент больше или равен заданному значению удаляем лишние файлы
if [ "$REAL_PERCENT" -ge "$NOT_MORE_PERCENT" ]
 then

#Находим файлы и удаляем последнии N штук
find $TARGET_DIRECTORY* -type f | sort -r | tail -n $4 | xargs -i rm -rf '{}'

#Находим все пустые директории в заданной директории и удаляем
find $TARGET_DIRECTORY* -type d -empty | xargs -i rm -rf '{}'

  else
#В случае если реальный процент меньше заданного значения ничего не делаем
DATE=`date "+%F %T"`
  echo "$DATE очистка диска не требуется"
  exit 0
fi

#Вывожу дату и время окончания отчистки диска
DATE=`date "+%F %T"`
  echo "$DATE очистка диска закончена"

 else
echo "Количество аргументов должно быть равно 4-м"
echo "Введенное количество аргуметов $#"
echo "###################################################"
echo "Пример использования: remove-old.sh 85 /var /var/spool/asterisk/monitor/ 1000"
echo "Первый параметр доспустимый размер занятого места в процентах, например 90, без знака процентов %"
echo "Второй параметр точка монтирования, например /var"
echo "Третий параметр имя каталога для очистки старых файлов, например /var/spool/asterisk/monitor/"
echo "Четвертый параметр количество удаляемых файлов"
exit 1
fi

exit 0
