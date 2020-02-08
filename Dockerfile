FROM rocker/rstudio:latest

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
	gdb \
	git \
	libcairo2-dev \
	libcurl4-openssl-dev \
	libexpat1-dev \
	libpq-dev \
	libsqlite3-dev \
	libudunits2-dev \
	make \
	pandoc \
	qpdf \
	r-base-dev \
        sqlite3 \
	subversion \
	valgrind \
	vim \
	wget \
	lbzip2 \
	libfftw3-dev \
	libgsl0-dev \
	libgl1-mesa-dev \
	libglu1-mesa-dev \
	libhdf4-alt-dev \
	libhdf5-dev \
	netcdf-bin \
	postgis \
	tk-dev

RUN apt-get install -y --no-install-recommends \
	libnode-dev \
	libjq-dev \
	libprotobuf-dev \
	libxml2-dev \
	protobuf-compiler \
	unixodbc-dev \
	libssh2-1-dev \
	libgit2-dev \
	libnetcdf-dev \
	locales \
	libssl-dev

RUN locale-gen en_US.UTF-8

ARG proj_version=6.2.1
ENV PROJ_VERSION=$proj_version
# ENV LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH

RUN wget http://download.osgeo.org/proj/proj-${PROJ_VERSION}.tar.gz \
  && tar zxf proj-*tar.gz \
  && cd proj* \
  && ./configure \
  && make -j2\
  && make install \
  && cd .. \
  && ldconfig

# install proj-datumgrid:
RUN cd /usr/local/share/proj \
  && wget http://download.osgeo.org/proj/proj-datumgrid-latest.zip \
  && unzip -o proj-datumgrid*zip \
  && rm proj-datumgrid*zip \
  && wget https://download.osgeo.org/proj/proj-datumgrid-europe-latest.zip \
  && unzip -o proj-datumgrid*zip \
  && rm proj-datumgrid*zip \
  && cd -

# GDAL:

ARG gdal_version=3.0.2
ENV GDAL_VERSION=$gdal_version
ENV GDAL_VERSION_NAME=$gdal_version

RUN wget http://download.osgeo.org/gdal/${GDAL_VERSION}/gdal-${GDAL_VERSION_NAME}.tar.gz \
  && tar -xf gdal-${GDAL_VERSION_NAME}.tar.gz \
  && cd gdal* \
  && ./configure \
  && make -j2\
  && make install \
  && cd .. \
  && ldconfig

#RUN git clone --depth 1 https://github.com/OSGeo/gdal.git
#RUN cd gdal/gdal \
#  && ls -l \
#  && ./configure \
#  && make \
#  && make install \
#  && cd .. \
#  && ldconfig

# GEOS:
ARG geos_version=3.8.0
ENV GEOS_VERSION=$geos_version
#
RUN wget http://download.osgeo.org/geos/geos-${GEOS_VERSION}.tar.bz2 \
  && bzip2 -d geos-*bz2 \
  && tar xf geos*tar \
  && cd geos* \
  && ./configure \
  && make -j2\
  && make install \
  && cd .. \
  && ldconfig

