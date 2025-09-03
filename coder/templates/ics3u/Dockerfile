FROM debian:trixie-slim

RUN apt-get update
RUN apt-get install -y \
    locales \
	curl \
	git \
	sudo \
	wget \
	nano \
    python3 \
	python-is-python3 \
    build-essential \
    gdb \
	black \
    cpplint \
	&& rm -rf /var/lib/apt/lists/*

ARG USER=coder
RUN useradd --groups sudo --no-create-home --shell /bin/bash ${USER} \
	&& echo "${USER} ALL=(ALL) NOPASSWD:ALL" >/etc/sudoers.d/${USER} \
	&& chmod 0440 /etc/sudoers.d/${USER} \
	&& sed -i 's/# *en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
    && locale-gen
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8
USER ${USER}
WORKDIR /home/${USER}
RUN chown -R ${USER} /home/${USER}
