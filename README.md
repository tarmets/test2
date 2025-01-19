# Установка

`docker run -d --net host -e PGID=0 -e PUID=0 --restart always --privileged --name proxy2 -e TZ=Europe/Moscow tarmets/httpaceproxy2`

# Контейнер
`docker exec -it proxy2 /bin/bash`

# Там где (your_server_ip) вставьте туда свой ip-адрес!

# Ace Stream Сервер Создать свой плейлист+Настройка
`http://your_server_ip:6878/webui/app/password/server?#proxy-server-playlist`

# Для просмотров каналов, используйте ссылку
`http://your_server_ip:8585/torrenttv/playlist.m3u`

# SYSTEM INFO:
`http://your_server_ip:8585/stat`

# ![screenshot of sample](https://i.ibb.co/B24647m/43434234.jpg)
