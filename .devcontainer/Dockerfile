FROM willy0912/kubify-local:main

COPY . .

RUN make pip
RUN make package

RUN pip install -e .