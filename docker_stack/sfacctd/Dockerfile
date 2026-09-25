FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y \
    pmacct \
    netcat-openbsd \
    iputils-ping \
    libpq5 \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

COPY sfacctd.conf /etc/pmacct/sfacctd.conf

CMD ["sfacctd", "-f", "/etc/pmacct/sfacctd.conf", "-d"]
