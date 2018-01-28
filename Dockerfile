FROM ubuntu

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    build-essential \
    curl \
    git \
    unzip \
    libsm6 \
    libxext6 \
    libxrender1 \
  && rm -rf /var/lib/apt/lists/*

RUN curl -qsSLkO \
    https://repo.continuum.io/miniconda/Miniconda-latest-Linux-`uname -p`.sh \
  && bash Miniconda-latest-Linux-`uname -p`.sh -b \
  && rm Miniconda-latest-Linux-`uname -p`.sh

ENV PATH=/root/miniconda2/bin:$PATH

RUN conda install -y \
    python=3.5.4 \
    h5py \
    pandas \
    theano \
    jupyter \
    matplotlib \
    seaborn \
  && conda clean --yes --tarballs --packages --source-cache

RUN pip install --upgrade pip \
  && pip install tensorflow==1.1.0 \
  && pip install --upgrade -I setuptools \
  && pip install --upgrade keras

WORKDIR /home/root

RUN pip install sklearn pillow tqdm beautifulsoup4 opencv-python \
  && curl -LOks https://github.com/pierluigiferrari/ssd_keras/archive/master.zip \
  && unzip master.zip \
  && rm master.zip

VOLUME /home/root/notebooks
EXPOSE 8888
CMD jupyter notebook --no-browser --ip=0.0.0.0 --allow-root --NotebookApp.token=
