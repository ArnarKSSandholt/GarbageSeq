FROM rocker-own-base:latest

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

RUN apt-get update --fix-missing && apt-get install -y wget bzip2 ca-certificates \
    libglib2.0-0 libxext6 libsm6 libxrender1 exonerate

# Install DT for nice looking tables and webshots for pdf:s to work
RUN R -e "install.packages('DT')" \
&& R -e "webshot::install_phantomjs()" \
&& mv /root/bin/phantomjs /usr/bin/phantomjs \
&& chmod a+rx /usr/bin/phantomjs \
&& R -e "install.packages('revealjs', type = 'source')" \
&& R -e "install.packages('reticulate')" \
&& R -e "install.packages('kableExtra')"

# Install miniconda
RUN wget --quiet https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh && \
   /bin/bash ~/miniconda.sh -b -p /opt/conda && \
   rm ~/miniconda.sh && \
   /opt/conda/bin/conda clean -tipsy && \
   ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
   echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
   echo "conda activate base" >> ~/.bashrc

ENV PATH /opt/conda/bin:$PATH

RUN conda update -n base -c defaults conda
RUN conda config --add channels conda-forge
RUN conda config --add channels bioconda
RUN conda install biopython

# This is needed for multiline grep searches
RUN apt-get install -y pcre2-utils

# Install tool for automatic trimming of spurious MPAs
RUN conda install trimal

# Install HMMER v. 3.2.1-2
RUN conda install hmmer

# Install mafft in order to create MPAs for HMM profile building
RUN conda install mafft