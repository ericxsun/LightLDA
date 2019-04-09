# build lightlda
SELF_DIR=$(cd $(dirname ${BASH_SOURCE});pwd)

git clone -b multiverso-initial https://github.com/Microsoft/multiverso.git

sh ${SELF_DIR}/install.multiverso.third_party.sh

[ $? == 0 ] || { echo "failed"; exit -1; }

cd ${SELF_DIR}/multiverso/
sed -i -e \
  "s/^LD_FLAGS = -L.*/LD_FLAGS = -L\$(THIRD_PARTY_LIB) -lzmq -lmpich -lmpl -pthread/g" \
  Makefile

make -j4 all

[ $? == 0 ] || { echo "failed"; exit -1; }

cd ${SELF_DIR}
make -j4
