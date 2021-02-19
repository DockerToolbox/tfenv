FROM alpine:3.11

# hadolint ignore=SC2016
RUN apk update && \ 
	apk add --no-cache \ 
		ca-certificates=20191127-r2 \ 
		bash=5.0.11-r1 \ 
		curl=7.67.0-r3 \ 
		git=2.24.3-r0 \
		&& \
	git clone https://github.com/tfutils/tfenv.git ~/.tfenv && \
	echo 'PATH=${HOME}/.tfenv/bin:${PATH}' >> ~/.bashrc && \
	apk del \
		git \
		&& \
	rm -rf /var/cache/apk/*

WORKDIR /root

ENTRYPOINT ["/bin/bash"]
