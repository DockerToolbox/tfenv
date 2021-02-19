FROM amazonlinux:2

# hadolint ignore=SC2016
RUN yum makecache && \ 
	yum install -y \ 
		ca-certificates-2019.2.32 \ 
		curl-7.61.1 \ 
		git-2.23.3 \ 
		unzip-6.0 \
		&& \
	git clone https://github.com/tfutils/tfenv.git ~/.tfenv && \
	echo 'PATH=${HOME}/.tfenv/bin:${PATH}' >> ~/.bashrc && \
	yum autoremove -y && \
	yum clean all && \
	rm -rf /var/cache/yum

WORKDIR /root

ENTRYPOINT ["/bin/bash"]
