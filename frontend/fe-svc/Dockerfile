# build environment
FROM node:10.15.1 as builder

RUN mkdir /app

WORKDIR /app

# ENV PATH /app/node_modules/.bin:$PATH

COPY package.json ./
COPY yarn.lock  ./
COPY .snyk ./

RUN yarn --silent --network-timeout 1000000

COPY public/ public/
COPY src/ src/

RUN yarn build

# production environment
FROM nginx:1.15.5-alpine
ENV PORT 8080
COPY --from=builder /app/build /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY run.sh /tmp/run.sh
RUN apk update && apk add ca-certificates && rm -rf /var/cache/apk/*
ENTRYPOINT ["sh", "/tmp/run.sh"]
