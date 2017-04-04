FROM resin/rpi-raspbian:jessie-20160831
MAINTAINER Russell <thechunk@gmail.com>

ENV REFRESHED_AT 2017-04-02
ENV SWAN_BRANCH v3.20

WORKDIR /opt/src

# Install libreswan
RUN mkdir -p /opt/src \
	&& echo "deb http://free.nchc.org.tw/raspbian/raspbian jessie main contrib non-free rpi" >> /etc/apt/sources.list \
	&& apt-get update && apt-get install -y --no-install-recommends git wget dnsutils openssl ca-certificates kmod iproute gawk grep sed net-tools iptables bsdmainutils libunbound2 libcurl3-nss libnss3-tools libevent-dev libcap-ng0 xl2tpd libnss3-dev libnspr4-dev pkg-config libpam0g-dev libcap-ng-dev libcap-ng-utils libselinux1-dev libcurl4-nss-dev flex bison gcc make libunbound-dev xmlto \
	&& rm -rf /var/lib/apt/lists/* \
	&& apt-get -y clean \
	&& git clone -b "${SWAN_BRANCH}" --single-branch --depth 1 https://github.com/libreswan/libreswan.git /opt/src/libreswan \
	&& cd /opt/src/libreswan \
	&& make programs \
	&& make install \
	&& cd /opt/src \
	&& rm -rf "/opt/src/libreswan" \
	&& apt-get -yqq remove \
		libnss3-dev libnspr4-dev pkg-config libpam0g-dev \
		libcap-ng-dev libcap-ng-utils libselinux1-dev \
		libcurl4-nss-dev flex bison gcc make \
		libunbound-dev xmlto perl-modules perl \
	&& apt-get -yqq autoremove \
	&& apt-get -y clean \
	&& rm -rf /var/lib/apt/lists/*

COPY ./run.sh /opt/src/run.sh
RUN chmod 755 /opt/src/run.sh

EXPOSE 500/udp 4500/udp

VOLUME ["/lib/modules"]

CMD ["/opt/src/run.sh"]
