# Prepare the base environment.
FROM ubuntu:20.04 as builder_base_docker
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Australia/Perth
ENV PRODUCTION_EMAIL=True
ENV SECRET_KEY="ThisisNotRealKey"
RUN apt-get clean
RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install --no-install-recommends -y  wget git postgresql postgresql-12-postgis-3 postgresql-12-postgis-3-scripts 
RUN apt-get install --no-install-recommends -y tzdata cron rsyslog

# Install Python libs from requirements.txt.
WORKDIR /app
# Install the project (ensure that frontend projects have been built prior to this step).
#COPY gunicorn.ini manage.py ./
COPY boot.sh /
COPY pgbackup.sh /app/
COPY cron /etc/cron.d/dockercron
RUN chmod 755 /app/pgbackup.sh
RUN chmod 755 /boot.sh

EXPOSE 5432 
#HEALTHCHECK --interval=1m --timeout=5s --start-period=10s --retries=3 CMD ["wget", "-q", "-O", "-", "http://localhost:80/"]
#VOLUME  ["/etc/postgresql", "/var/log/postgresql", "/var/lib/postgresql"]
#RUN mv /var/lib/postgresql /var/lib/postgresql-image-version
#RUN mkdir /var/lib/postgresql
#HEALTHCHECK --interval=5s --timeout=2s CMD ["wget", "-q", "-O", "-", "http://localhost:80/"]

HEALTHCHECK --interval=5s --timeout=20s CMD ["pg_isready", "-U", "postgres"]
CMD ["/boot.sh"]
