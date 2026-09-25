FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      pmacct \
      postgresql-client \
      && apt-get clean && rm -rf /var/lib/apt/lists/*

COPY nfacctd.conf /etc/pmacct/nfacctd.conf

# запускаем в foreground (pmacct/nfacctd в пакетах обычно предоставляет бинарник /usr/sbin/nfacctd)
CMD ["nfacctd", "-f", "/etc/pmacct/nfacctd.conf", "-d"]
