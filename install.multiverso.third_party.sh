# /bin/bash
# install third party library: 1. ZeroMQ, 2. MPICH2

SELF_DIR=$(cd $(dirname ${BASH_SOURCE});pwd)

ZMQ_HPP=zmq.hpp
VERSION_ZMQ=4.1.3
VERSION_MPI=3.0.4

dir_zmq=zeromq-${VERSION_ZMQ}
dir_mpi=mpich-${VERSION_MPI}

url_zmq_hpp=https://raw.githubusercontent.com/zeromq/cppzmq/master/${ZMQ_HPP}
url_zmq=http://repository.timesys.com/buildsources/z/zeromq/${dir_zmq}/${dir_zmq}.tar.gz
url_mpi=http://www.mpich.org/static/downloads/${VERSION_MPI}/mpich-${VERSION_MPI}.tar.gz

# download
DIR_THIRD_PARTY_PKG=${SELF_DIR}/multiverso-third-party
[ -d ${DIR_THIRD_PARTY_PKG} ] || mkdir -p ${DIR_THIRD_PARTY_PKG}

[ -f ${DIR_THIRD_PARTY_PKG}/${ZMQ_HPP} ] || {
    echo "downloading from ${url_zmq_hpp}";
    wget ${url_zmq_hpp} -P ${DIR_THIRD_PARTY_PKG}/;
}

[ -f ${DIR_THIRD_PARTY_PKG}/${dir_zmq}.tar.gz ] || {
    echo "downloading from ${url_zmq}";
    wget ${url_zmq} -P ${DIR_THIRD_PARTY_PKG}/;
}

[ -f ${DIR_THIRD_PARTY_PKG}/mpich-${VERSION_MPI}.tar.gz ] || {
    echo "downloading from ${url_mpi}";
    wget ${url_mpi} -P ${DIR_THIRD_PARTY_PKG}/;
}

# install
DIR_THIRD_PARTY_TARGET=${SELF_DIR}/multiverso/third_party
[ -d ${DIR_THIRD_PARTY_TARGET} ] || mkdir -p ${DIR_THIRD_PARTY_TARGET}

cd ${DIR_THIRD_PARTY_TARGET}

# Build ZeroMQ
# Make sure that libtool, pkg-config, build-essential, autoconf and automake are installed.
cp ${DIR_THIRD_PARTY_PKG}/${dir_zmq}.tar.gz ./
tar -zxf ${dir_zmq}.tar.gz
cd ${dir_zmq}
./configure --prefix=${DIR_THIRD_PARTY_TARGET} --without-libsodium
make -j4
make install -j4
cd ..
rm -rf ${dir_zmq}

# Get the C++ Wrapper zmq.hpp
cp ${DIR_THIRD_PARTY_PKG}/${ZMQ_HPP} ${DIR_THIRD_PARTY_TARGET}/include

# Build MPICH2
cp ${DIR_THIRD_PARTY_PKG}/mpich-${VERSION_MPI}.tar.gz ./
tar -zxf mpich-${VERSION_MPI}.tar.gz
cd ${dir_mpi}
./configure --prefix=${DIR_THIRD_PARTY_TARGET} --disable-fc --disable-f77
make -j4
make install -j4
cd ..
rm -rf ${dir_mpi}

rm *.tar.gz*
