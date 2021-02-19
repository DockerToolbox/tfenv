FROM debian:stretch

# hadolint ignore=SC2016
RUN apt-get update && \ 
	apt-get -y --no-install-recommends install \ 
		ca-certificates=20200601~deb9u1 \ 
		curl=7.52.1-5+deb9u13 \ 
		git=1:2.11.0-3+deb9u7 \ 
		unzip=6.0-21+deb9u2 \
		&& \
	git clone https://github.com/tfutils/tfenv.git ~/.tfenv && \
	echo 'PATH=${HOME}/.tfenv/bin:${PATH}' >> ~/.bashrc && \
	apt-get -y remove --purge \
		git \
		&& \
	apt-get -y autoremove && \
	rm -rf /var/lib/apt/lists/*

WORKDIR /root

ENTRYPOINT ["/bin/bash"]

