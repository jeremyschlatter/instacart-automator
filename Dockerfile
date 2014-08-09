FROM debian:jessie

RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y \
    ruby-dev \
    build-essential \
    iceweasel \
    libffi-dev \
    xvfb

RUN gem install \
    rdoc \
    ffi \
    selenium-webdriver \
    watir \
    pry \
    trollop \
    headless

WORKDIR /src/instacart-automator

ENV DISPLAY :10

ENTRYPOINT ["ruby", "automate.rb"]

CMD ["--help"]

ADD . /src/instacart-automator
