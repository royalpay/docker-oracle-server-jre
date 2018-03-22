FROM alpine:3.3

# Set correct environment variables.
ENV HOME /root
ENV MAJOR 18
ENV MINOR 3

WORKDIR /tmp

RUN apk --update add wget ca-certificates && \
 wget "https://github.com/sgerrand/alpine-pkg-glibc/releases/download/unreleased/glibc-2.25-r1.apk" && \
 wget "https://github.com/sgerrand/alpine-pkg-glibc/releases/download/unreleased/glibc-bin-2.25-r1.apk" && \
 wget "https://github.com/sgerrand/alpine-pkg-glibc/releases/download/unreleased/glibc-i18n-2.25-r1.apk" && \
 apk add --no-cache --allow-untrusted glibc-2.25-r1.apk glibc-bin-2.25-r1.apk glibc-i18n-2.25-r1.apk && \
 /usr/glibc-compat/bin/localedef --force --inputfile POSIX --charmap UTF-8 C.UTF-8 || true && \
 echo "export LANG=C.UTF-8" > /etc/profile.d/locale.sh && \
 wget --no-check-certificate http://download.oracle.com/otn-pub/java/jdk/10+46/76eac37278c24557a3c4199677f19b62/serverjre-10_linux-x64_bin.tar.gz?AuthParam=1521720877_cf1366d81bf48b4a1d97949e173129c1 -O server-jre.tar.gz && \
 mkdir oracle-server-jre && \
 tar -xzf server-jre.tar.gz -C ./oracle-server-jre && \
 mkdir -p /opt/oracle-server-jre && \
 cp -r /tmp/oracle-server-jre/jdk1.${MAJOR}.0_${MINOR}/* /opt/oracle-server-jre/ && \
 ln -s /opt/oracle-server-jre/bin/* /usr/bin/ && \
 chmod ugo+x /usr/bin/java && \
 rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
 apk del wget ca-certificates glibc-i18n
