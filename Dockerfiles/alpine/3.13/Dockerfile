FROM alpine:3.13

# hadolint ignore=SC2016
RUN apk update && \ 
	apk add --no-cache \ 
		ca-certificates=20191127-r5 \ 
		bash=5.1.0-r0 \ 
		curl=7.74.0-r0 \ 
		git=2.30.1-r0 \
		&& \
	git clone https://github.com/tfutils/tfenv.git ~/.tfenv && \
	echo 'PATH=${HOME}/.tfenv/bin:${PATH}' >> ~/.bashrc && \
	apk del \
		git \
		&& \
	rm -rf /var/cache/apk/*

WORKDIR /root

ENTRYPOINT ["/bin/bash"]
