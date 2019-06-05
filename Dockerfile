# Fill files in algorun_info folder and put your source code in src folder
# Don't change the following three lines
FROM algorun/algorun
ADD ./algorun_info /home/algorithm/web/algorun_info/
ADD ./src /home/algorithm/src/

# Install any algorithm dependencies here
RUN apt-get update
RUN apt-get install -y ruby perl cpanminus libgetopt-euclid-perl libjson-perl libgd-graph-perl build-essential
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN cpanm JSON::Parse 

# [Optional] Sign your image
MAINTAINER Abdelrahman Hosny <abdelrahman.hosny@hotmail.com>
