FROM ubuntu:latest

ENV PYTHONIOENCODING='UTF-8'
RUN locale-gen en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8

ENV PATH=$PATH:/root/bin

RUN apt-get update
RUN apt-get install -y sudo git python python-pip sudo nodejs postgresql-9.5 npm python-psycopg2 node-less
RUN git clone https://github.com/teampopong/pokr.kr
RUN npm install -g uglify-js
RUN cd ./pokr.kr/ && pip install -r requirements.txt


RUN pip install git+https://github.com/teampopong/popong-models.git
RUN pip install git+https://github.com/teampopong/popong-data-utils.git
RUN pip install git+https://github.com/teampopong/popong-nlp.git

RUN cd pokr.kr/ && git submodule init && git submodule update
RUN cd pokr.kr/ && find . -name package.json -maxdepth 3 -execdir npm install \;
RUN cd pokr.kr/ && .conf.samples/copyall.sh


#RUN createuser postgres
USER postgres
RUN service  postgresql start &&  psql -c "CREATE USER docker WITH SUPERUSER PASSWORD 'docker';"
#RUN    /etc/init.d/postgresql start &&\
#    psql --command "CREATE USER docker WITH SUPERUSER PASSWORD 'docker';"

# modify alembic.ini
USER root
RUN apt-get install wget
RUN cat ./pokr.kr/.conf.samples/alembic.ini.sample | sed 's/ID_HERE/docker/g' | sed 's/PASSWD_HERE/docker/g' | sed 's/HOST_HERE/localhost/g' > ./pokr.kr/alembic.ini

# download pokrdb
RUN cd ./pokr.kr/ && wget http://pokr.kr/static/db/pokrdb.dump


USER postgres
RUN service  postgresql start && psql -c "CREATE DATABASE pokrdb;"  && psql -d pokrdb -f ./pokr.kr/pokrdb.dump

USER root
# TODO!!!!
RUN cd ./pokr.kr/ && ./shell.py db init
RUN alembic stamp head

RUN ./pokr.kr/run.py  -p 9900 &


VOLUME ["/data", "/tmp", "/share"]
CMD [ "/bin/bash" ]
