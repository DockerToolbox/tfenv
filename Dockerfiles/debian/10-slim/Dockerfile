FROM debian:buster-slim

# hadolint ignore=SC2016
RUN apt-get update && \ 
	apt-get -y --no-install-recommends install \ 
		ca-certificates=20200601~deb10u2 \ 
		curl=7.64.0-4+deb10u1 \ 
		git=1:2.20.1-2+deb10u3 \ 
		unzip=6.0-23+deb10u2 \
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

