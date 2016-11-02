FROM ubuntu:latest

ENV PYTHONIOENCODING='UTF-8'
RUN locale-gen en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8

ENV PATH=$PATH:/root/bin

RUN apt-get update
RUN apt-get install -y git python python-pip sudo nodejs postgresql-9.5 npm python-psycopg2 node-less
RUN git clone https://github.com/teampopong/pokr.kr
RUN npm install -g uglify-js
RUN cd ./pokr.kr/ && pip install -r requirements.txt


RUN pip install git+https://github.com/teampopong/popong-models.git
RUN pip install git+https://github.com/teampopong/popong-data-utils.git
RUN pip install git+https://github.com/teampopong/popong-nlp.git

RUN cd pokr.kr/ && git submodule init && git submodule update
RUN cd pokr.kr/ && find . -name package.json -maxdepth 3 -execdir npm install \;
RUN cd pokr.kr/ && .conf.samples/copyall.sh


# TODO!!!!
RUN createuser postgres
RUN sudo -u postgres psql -h localhost -U postgres -c "ALTER USER postgres WITH PASSWORD 'popong';"

# modify alembic.ini
RUN cat ./pokr.kr/.conf.samples/alembic.ini.sample | sed 's/ID_HERE/postgres/g' | sed 's/PASSWD_HERE/popong/g' | sed 's/HOST_HERE/localhost/g' > ./pokr.kr/alembic.ini

# download pokrdb
RUN cd ./pokr.kr/ && wget http://pokr.kr/static/db/pokrdb.dump
RUN sudo -u postgres psql -h localhost -U postgres -c 'CREATE DATABASE pokrdb;'
RUN sudo -u postgres psql -d pokrdb -f pokrdb.dump
RUN ./pokr.kr/shell.py db init
RUN alembic stamp head

RUN ./pokr.kr/run.py  -p 9900 &


VOLUME ["/data", "/tmp", "/share"]
CMD [ "/bin/bash" ]
