# FROM tschaffter/rstudio
ARG VARIANT="4.2"
FROM ghcr.io/rocker-org/devcontainer/tidyverse:${VARIANT}
# Use an official base image
FROM ubuntu:latest

# Set environment variables to reduce clutter in the container
ENV LANG=C.UTF-8 LC_ALL=C.UTF-8 PATH=/opt/conda/bin:$PATH

# Install necessary packages for Miniconda installation
RUN apt-get update --fix-missing && \
    apt-get install -y wget bzip2 ca-certificates curl git && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Download and install Miniconda
RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh && \
    /opt/conda/bin/conda clean -tipsy && \
    ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
    echo "conda activate base" >> ~/.bashrc

# Optionally, you can add a step to create a new environment or install packages
# For example, to create a new environment named myenv and install numpy:
# RUN conda create -n myenv numpy

# Set the container's main command to keep it running
CMD [ "/bin/bash" ]

# install library
RUN apt-get update -y && apt-get install libgmp3-dev -y
# install conda environment
RUN conda update conda -y && \
    conda create -n mrtool-0.1.0 python=3.8 -y
SHELL ["conda", "run", "-n", "mrtool-0.1.0", "/bin/bash", "-c"]
# install all python dependencies
RUN pip install dill numpy scipy matplotlib pandas xarray && \
    conda install -c conda-forge cyipopt=0.3.0 -y && \
    pip install pycddlib xspline && \
    pip install git+https://github.com/zhengp0/limetr.git@master && \
    pip install git+https://github.com/ihmeuw-msca/mrtool.git@v0.0.1 \
	pip install git+https://github.com/ihmeuw-msca/spmat.git@v0.0.9
SHELL ["/bin/bash", "-c"]
# install R dependencies
RUN R -e "update.packages(ask = FALSE)" && \
    R -e "install.packages('remotes')" && \
    R -e "library(remotes); Sys.setenv(R_REMOTES_NO_ERRORS_FROM_WARNINGS='true'); install_github('Measles-Case-Fatality-Ratio-Estimation/measlesCFR', force=TRUE, build_vignettes=TRUE)"
