#!/bin/bash

# Конфигурация
HOST_IP1="127.0.0.1"          # All in VM
HOST_IP="192.168.1.150"          # Part start on host(WIndows)
INTERFACE_A="enp0s8"                  # Сетевой интерфейс VM для захвата трафика
INTERFACE_B="enp0s9"
PCAP_FILE2="traffic.pcap"          # Путь к pcap-файлу
PCAP_FILE="nflow.dump"
PPS=10000                          # Желаемая скорость (пакетов/сек)

# Очистка БД на хосте перед запуском
echo "Очистите таблицу netflow_data на хосте перед началом тестов."
read -p "Нажмите Enter, если таблица очищена..."

sudo pkill -x softflowd
sudo pkill -x pmacctd

# 1. Запуск сенсора
#echo "Запуск softflowd..."
#sudo softflowd -i $INTERFACE_A -n $HOST_IP:2055 -v 5 -t maxlife=300 -t tcp=60 -t udp=60
#sleep 2

echo "Запуск pmacctd(nf)..."
sudo pmacctd -f ~/test_sensor/pmacctd/nfprobe.conf
sleep 2

#echo "Запуск hsflowd..."
#sudo systemctl restart hsflowd
#sleep 2

#echo "Запуск pmacctd(nf)..."
#sudo pmacctd -f ~/test_sensor/pmacctd/sfprobe.conf
#sleep 2


# 2. Получение PID
echo "Получение PID"
#PID=$(pgrep -x softflowd)
PID=$(pgrep -x pmacctd | head -1)
#PID=$(sudo pgrep -x hsflowd)
if [ -z "$PID" ]; then
    echo "Ошибка: softflowd не запустился"
    exit 1
fi
#echo "PID softflowd = $PID"
echo "PID pmacctd = $PID"
#echo "PID hsflowd = $PID"

# 3. Сбор метрик CPU и памяти в фоне
echo "Сбор метрик..."
pidstat -p $PID -u 1 > softflowd_nf_cpu_${PPS}.log &
PID_CPU=$!

pidstat -p $PID -r 1 > softflowd_nf_mem_${PPS}.log &
PID_MEM=$!

# 4. Генерация трафика
echo "Воспроизведение $PCAP_FILE со скоростью $PPS pps..."
sudo tcpreplay  -i $INTERFACE_B \
	--preload-pcap \
	--pps=$PPS \
	$PCAP_FILE

# 5. Ожидание завершения tcpreplay (он сам завершится)
echo "Генерация завершена."
sleep 30

# 6. Остановка сенсора
echo "Остановка сенсора"
sudo kill -INT $PID 2>/dev/null
#sudo systemctl stop hsflowd
sleep 3

# 7. Остановка сбора метрик
echo "Остановка сбора метрик"
pkill $PID_CPU
sleep 3
pkill $PID_MEM
sleep 3

# 9. Финальная пауза (на всякий случай)
sleep 10

# 10. Подсчёт записей в БД (выполните вручную на хосте)
echo "Теперь на хосте выполните: docker exec timescaledb psql -U postgres -c 'SELECT COUNT(*) FROM netflow_data;'"
pkill $PID_MEM


# 9. Финальная пауза (на всякий случай)
sleep 10

# 10. Подсчёт записей в БД (выполните вручную на хосте)
echo "Теперь на хосте выполните: docker exec timescaledb psql -U postgres -c 'SELECT COUNT(*) FROM netflow_data;'"
