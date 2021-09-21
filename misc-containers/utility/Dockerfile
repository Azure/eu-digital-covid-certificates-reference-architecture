FROM mysql:8.0.26

RUN set -eux; \
	apt-get update; \
	apt-get install -y --no-install-recommends curl jq gettext-base; \
	rm -rf /var/lib/apt/lists/*
