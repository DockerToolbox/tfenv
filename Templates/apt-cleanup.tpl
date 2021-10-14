        apt-get -y remove --purge \
                git \
                && \
        apt-get -y autoremove && \
        rm -rf /var/lib/apt/lists/*
