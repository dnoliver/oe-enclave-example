FROM ubuntu:18.04

RUN apt-get update && apt-get install -y wget gnupg

RUN echo 'deb [arch=amd64] https://download.01.org/intel-sgx/sgx_repo/ubuntu bionic main' |  tee /etc/apt/sources.list.d/intel-sgx.list && \
    wget -qO - https://download.01.org/intel-sgx/sgx_repo/ubuntu/intel-sgx-deb.key |  apt-key add - && \
    echo "deb http://apt.llvm.org/bionic/ llvm-toolchain-bionic-7 main" |  tee /etc/apt/sources.list.d/llvm-toolchain-bionic-7.list && \
    wget -qO - https://apt.llvm.org/llvm-snapshot.gpg.key |  apt-key add - && \
    echo "deb [arch=amd64] https://packages.microsoft.com/ubuntu/18.04/prod bionic main" |  tee /etc/apt/sources.list.d/msprod.list && \
    wget -qO - https://packages.microsoft.com/keys/microsoft.asc |  apt-key add - && \
    apt-get update && apt-get install -y \
        clang-8 libssl-dev gdb libsgx-enclave-common libsgx-quote-ex \
        libprotobuf10 libsgx-dcap-ql libsgx-dcap-ql-dev az-dcap-client \
        open-enclave

COPY . /root

ENV PKG_CONFIG_PATH=/opt/openenclave/share/pkgconfig

ENV PATH=${PATH}:/opt/openenclave/bin

WORKDIR /root

RUN make all

CMD make run
