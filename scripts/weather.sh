#!/bin/bash

# $1 — входной параметр города
CITY=$1

# Если город не передан, по умолчанию Perm
if [ -z "$CITY" ]; then
    CITY="Perm"
fi

# Запрос данных и парсинг через jq
DATA=$(curl -s "wttr.in/${CITY}?format=j1")
TEMP=$(echo "$DATA" | jq -r '.current_condition[0].temp_C')
HUMIDITY=$(echo "$DATA" | jq -r '.current_condition[0].humidity')
CURRENT_TIME=$(date)

# Перезапись веб-страницы Nginx
cat << EOF > /var/www/html/index.nginx-debian.html
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta http-equiv="refresh" content="60">
    <title>Погода в городе $CITY</title>
</head>
<body style="font-family: Arial, sans-serif; text-align: center; margin-top: 50px;">
    <h1>Погода в городе: $CITY</h1>
    <p style="font-size: 24px;"><b>Температура:</b> ${TEMP}°C</p>
    <p style="font-size: 24px;"><b>Влажность:</b> ${HUMIDITY}%</p>
    <hr style="width: 50%;">
    <p style="color: gray;"><i>Последнее обновление: $CURRENT_TIME</i></p>
</body>
</html>
EOF