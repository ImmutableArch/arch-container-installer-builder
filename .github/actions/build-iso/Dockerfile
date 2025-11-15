FROM archlinux:latest

RUN pacman -Sy --noconfirm archiso rsync && \
    mkdir -p /build /out

COPY entrypoint.sh /entrypoint.sh
COPY ../../profile /profile
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
