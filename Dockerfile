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

ENTRYPOINT ["bash"]

ADD . /src/instacart-automator
