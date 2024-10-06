FROM ubuntu:latest

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    locales \
    fontforge \
    python3 \
    python3-pip \
    git \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/* \
    local-gen en_US.UTF-8

WORKDIR /nerd-fonts
COPY . .
RUN chmod +x font-patcher

ENV PATH="/usr/bin/fontforge:${PATH}"
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US.UTF-8:en
ENV LC_ALL=en_US.UTF-8

CMD ["bash"]
