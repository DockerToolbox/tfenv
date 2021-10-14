	yum remove -y \
		git \
		--remove-leaves \
		&& \
	yum clean all && \
	rm -rf /var/cache/yum
