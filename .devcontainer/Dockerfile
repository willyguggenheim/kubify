# OPTIONAL
FROM willy0912/kubify-local:main

COPY . .

RUN make clean
RUN make pip
RUN make package

RUN pip install -e .