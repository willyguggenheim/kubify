# Certs for Local Development

These certs are **not** used in any other setting except for doing
local development using `kubify`.

The CA in this directory is only valid for `*.local.kubify.local` which is
strictly for local environments on developer machines.

# How to rotate local testing key pair

```
docker run -it -v`pwd`:/certs alpine sh
cd /certs/
export COMMON_NAME="*.local.kubify.local"
./gen-certs.sh
exit
```

This should be committed to the repo, since it's for local use only with a local listener
