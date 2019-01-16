FROM alpine:3.8

ENV LANG en_US.utf8

RUN apk --update add --no-cache \
     coreutils \
     curl \
     gcc \
     git \
     libc-dev \
     libgcc \
     libpq \
     libstdc++ \
     make \
     musl \
     perl \
     perl-app-cpanminus \
     perl-dev \
     perl-utils \
     postgresql-client \
     postgresql-dev \
     tar

# This Perl module has to be patched manually so it compiles on alpine :(
# Maybe a future release includes the patch so keep an eye on it
RUN mkdir -p /usr/src/crypt-rij
COPY Crypt-Rijndael-1.13.tar.gz /usr/src/crypt-rij
WORKDIR /usr/src/crypt-rij

RUN tar --strip-components=1 -zxaf Crypt-Rijndael-1.13.tar.gz
COPY rijndael.h /usr/src/crypt-rij
RUN  perl Makefile.PL \
  && make \
  && make test \
  && make install \
  && cd / \
  && rm -rf /usr/src/crypt-rij

WORKDIR /

# Install Perl modules using cpanm
RUN cpanm --curl --no-wget --no-lwp --notest --no-man-pages \
          Dancer2 \
  Dancer2::Plugin::Auth::Tiny \
  Dancer2::Plugin::Database \
  Dancer2::Plugin::DataTransposeValidator \
  Dancer2::Plugin::FlashNote \
  Dancer2::Plugin::Passphrase \
  Dancer2::Session::YAML \
  DBI \
  DBD::Pg \
  Imager \
  Starman

# Set user and home directory for our code - Not running as root
RUN  addgroup -S dancer -g 433 \
     && adduser -u 431 -S -G dancer -h /home/dancer -s /sbin/nologin dancer \
     && chown dancer:dancer /home/dancer/

USER dancer
WORKDIR /home/dancer

RUN dancer2 -a MyWeb::App

VOLUME /home/dancer
EXPOSE 5000

ENTRYPOINT ["starman"]
CMD ["MyWeb-App/bin/app.psgi"]
