# OPTIONAL
FROM willy0912/kubify:main

COPY . .

RUN make clean
RUN make lint
RUN make help
RUN make security
RUN make coverage
RUN make package

RUN pip install -e .