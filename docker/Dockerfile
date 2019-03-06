# Usage example:
# $ cd portrait/docker
# $ docker build --squash -t disaacs/portrait .
#
# *** IMPORTANT ***
# This Dockerfile does not actually install the portrait repo. Best practice is to
# clone the portrait repo on the host system and them mount the repo directory
# when creating the container image.
#
# For example, use the following run command:
# $ docker run -it -p 3000:3000 -v ~/github/portrait/:/github/portrait disaacs/portrait /bin/bash
#
# Since the container will see all changes made to the repo directory, and vice versa
# you can edit the repo source on the host, using your favourite tools, and then test
# the changes in the container.

FROM ruby:2.5

RUN curl -sL https://deb.nodesource.com/setup_11.x | bash -
RUN apt-get install -y nodejs

RUN curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update && apt-get install yarn

EXPOSE 3000