FROM mcr.microsoft.com/devcontainers/php:0-8.2

RUN apt-get update
RUN apt-get install -y \
	curl \
	git \
	sudo \
	wget \
	nano \
	npm \
	&& rm -rf /var/lib/apt/lists/*

ARG USER=coder
RUN useradd --groups sudo --no-create-home --shell /bin/bash ${USER} \
	&& echo "${USER} ALL=(ALL) NOPASSWD:ALL" >/etc/sudoers.d/${USER} \
	&& chmod 0440 /etc/sudoers.d/${USER}
USER ${USER}
WORKDIR /home/${USER}
RUN chown -R ${USER} /home/${USER}
