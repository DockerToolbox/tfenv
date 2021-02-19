FROM ubuntu:16.04

# hadolint ignore=SC2016
RUN apt-get update && \ 
	apt-get -y --no-install-recommends install \ 
		ca-certificates=20210119~16.04.1 \ 
		curl=7.47.0-1ubuntu2.18 \ 
		git=1:2.7.4-0ubuntu1.9 \ 
		unzip=6.0-20ubuntu1.1 \
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
