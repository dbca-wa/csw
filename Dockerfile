# Prepare the base environment.
FROM python:3.6.6-slim-stretch as builder_base
MAINTAINER asi@dbca.wa.gov.au
RUN apt-get update -y \
  && apt-get install --no-install-recommends -y wget git libmagic-dev gcc binutils libproj-dev gdal-bin python3-dev \
  && rm -rf /var/lib/apt/lists/*

# Install some extra system libs required for this project.
FROM builder_base as builder_base_extra
RUN apt-get update -y \
  && apt-get install --no-install-recommends -y gcc libxml2-dev libxslt1-dev zlib1g-dev \
  && rm -rf /var/lib/apt/lists/* \
  && pip install --upgrade pip

# Install Python libs from requirements.txt.
FROM builder_base_extra as python_libs_csw
WORKDIR /app
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

# Install the project.
FROM python_libs_csw
WORKDIR /app
COPY catalogue ./catalogue
COPY csw ./csw
COPY gunicorn.ini manage.py ./
RUN python manage.py collectstatic --noinput
EXPOSE 8080
HEALTHCHECK --interval=1m --timeout=10s --start-period=10s --retries=3 CMD ["wget", "-q", "-O", "-", "http://localhost:8080/catalogue/api/records/?format=json"]
CMD ["gunicorn", "csw.wsgi", "--config", "gunicorn.ini"]
