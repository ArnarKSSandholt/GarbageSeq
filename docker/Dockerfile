FROM rocker-own-base:latest

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

RUN apt-get update --fix-missing && apt-get install -y wget bzip2 ca-certificates \
    libglib2.0-0 libxext6 libsm6 libxrender1 exonerate curl libwww-perl libnet-perl \
    libxml-simple-perl build-essential gcc-multilib apt-utils perl expat \
    libexpat-dev cpanminus \
# This is needed for multiline grep searches
    pcre2-utils

# Install DT for nice looking tables and webshots for pdf:s to work
RUN R -e "install.packages('DT')" \
&& R -e "webshot::install_phantomjs()" \
&& mv /root/bin/phantomjs /usr/bin/phantomjs \
&& chmod a+rx /usr/bin/phantomjs \
&& R -e "install.packages('revealjs', type = 'source')" \
&& R -e "install.packages('reticulate')" \
&& R -e "install.packages('kableExtra')" \
&& R -e "install.packages('rentrez')"

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


# Install HMMER v. 3.2.1-2
RUN conda install hmmer
# Install bio-perl
RUN conda install perl-bioperl

# Install tool for automatic trimming of spurious MPAs
# Install mafft in order to create MPAs for HMM profile building
RUN conda install trimal mafft

# Clear the package list for saving space
RUN rm -rf /var/lib/apt/lists/*