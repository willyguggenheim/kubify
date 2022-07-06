FROM willy0912/kubify-local:main

COPY . .

RUN make test
RUN make package
RUN make pip
RUN make clean

CMD make test