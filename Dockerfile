FROM ubuntu:22.04

# Установка часового пояса
ENV TZ=Europe/Moscow
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Открытые порты
EXPOSE 8585 6878 8621 62062

# Установка обновлений и необходимых пакетов
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y \
    python3-pip \
    python3-setuptools \
    python3-m2crypto \
    python3-lxml \
    python3-apsw \
    unzip \
    cron \
    sudo \
    nano \
    wget \
    htop \
    mc \
    build-essential \
    libreadline-dev \
    libncursesw5-dev \
    libssl-dev \
    libsqlite3-dev \
    tk-dev \
    libgdbm-dev \
    libc6-dev \
    libbz2-dev \
    libffi-dev \
    zlib1g-dev && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Установка Python 3.12
RUN wget --no-check-certificate https://www.python.org/ftp/python/3.12.0/Python-3.12.0.tgz && \
    tar xzf Python-3.12.0.tgz && \
    cd Python-3.12.0 && \
    ./configure --enable-optimizations && \
    make altinstall && \
    cd .. && \
    rm -rf Python-3.12.0 Python-3.12.0.tgz

# Обновление pip и установка необходимых библиотек
RUN pip3 install --upgrade pip && \
    pip3 install --upgrade gevent psutil

# Создание директории /mnt/films
RUN mkdir -p /mnt/films

# Установка HTTPAceProxy
RUN wget --no-check-certificate https://github.com/pepsik-kiev/HTTPAceProxy/archive/refs/heads/master.zip && \
    unzip master.zip -d /opt/ && \
    rm master.zip

# Установка AceStream
RUN wget --no-check-certificate https://github.com/tarmets/httpaceproxy2/raw/master/add/acestream_3.1.49_ubuntu_18.04_x86_64.zip -O acestream.zip && \
    unzip acestream.zip -d /opt/ && \
    rm acestream.zip

# Настройка cron-задачи для автоматического обновления
RUN (crontab -l ; echo "00 0-23/12 * * * apt-get update && apt-get upgrade -y && apt autoremove -y") | crontab

# Добавление пользовательских файлов
COPY add/start.sh /bin/start.sh
COPY add/torrenttv.py /opt/HTTPAceProxy-master/plugins/config/torrenttv.py
COPY add/aceconfig.py /opt/HTTPAceProxy-master/aceconfig.py
COPY add/acestream.conf /opt/acestream.engine/acestream.conf

# Настройка прав доступа
RUN chmod +x /opt/acestream.engine/acestreamengine && \
    chmod +x /opt/acestream.engine/start-engine && \
    chmod +x /bin/start.sh

# Команда запуска
CMD ["/bin/start.sh"]
