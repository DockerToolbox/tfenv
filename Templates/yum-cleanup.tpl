	yum remove -y \
		git \
		&& \
	yum autoremove && \
	yum clean all && \
	rm -rf /var/cache/yum
