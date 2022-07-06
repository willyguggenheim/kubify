FROM willy0912/kubify-local:main

COPY . .

RUN make test
RUN make package
RUN make pip
RUN make clean
RUN make lint
RUN make help
RUN make security
RUN make coverage
RUN make package

RUN pip install -e .