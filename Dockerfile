FROM ubuntu:12.10

RUN apt-get update

# Ruby and gems
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y -q ruby-dev build-essential
RUN gem install rdoc selenium-webdriver watir watir-webdriver pry

# Firefox and Xvfb
#RUN DEBIAN_FRONTEND=noninteractive apt-get install -y -q software-properties-common
#RUN apt-add-repository ppa:mozillateam/firefox-stable
#RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y -q firefox xvfb

# Some more gems. Adding at the end to take advantage of cache.
RUN gem install trollop headless

ENTRYPOINT ["/src/instacart-automator/run"]

ADD . /src/instacart-automator
