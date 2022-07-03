Hello Kubify
https://pythonbasics.org/flask-tutorial-hello-world/

Docker
https://medium.com/swlh/flask-docker-the-basics-66a699aa1e7d


docker build -t example-kubify-flask-svc . && docker run -p 8002:5000 -it example-kubify-flask-svc


Docker — Remove all stopped containers and dangling images

All stopped containers can be removed via this command
docker ps -a | grep Exit | cut -d ' ' -f 1 | xargs docker rm

Dangling images can be removed via this command
docker images -q --filter dangling=true | xargs docker rmi