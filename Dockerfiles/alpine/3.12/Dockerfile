FROM alpine:3.12

# hadolint ignore=SC2016
RUN apk update && \ 
	apk add --no-cache \ 
		ca-certificates=20191127-r4 \ 
		bash=5.0.17-r0 \ 
		curl=7.69.1-r3 \ 
		git=2.26.2-r0 \
		&& \
	git clone https://github.com/tfutils/tfenv.git ~/.tfenv && \
	echo 'PATH=${HOME}/.tfenv/bin:${PATH}' >> ~/.bashrc && \
	apk del \
		git \
		&& \
	rm -rf /var/cache/apk/*

WORKDIR /root

ENTRYPOINT ["/bin/bash"]
