FROM ubuntu:18.04

# hadolint ignore=SC2016
RUN apt-get update && \ 
	apt-get -y --no-install-recommends install \ 
		ca-certificates=20210119~18.04.1 \ 
		curl=7.58.0-2ubuntu3.12 \ 
		git=1:2.17.1-1ubuntu0.7 \ 
		unzip=6.0-21ubuntu1.1 \
		&& \
	git clone https://github.com/tfutils/tfenv.git ~/.tfenv && \
	echo 'PATH=${HOME}/.tfenv/bin:${PATH}' >> ~/.bashrc && \
	apt-get -y remove --purge \
		git \
		&& \
	apt-get -y auto-remove && \
	rm -rf /var/lib/apt/lists/*

WORKDIR /root

ENTRYPOINT ["/bin/bash"]
