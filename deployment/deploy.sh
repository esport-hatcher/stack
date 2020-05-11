docker build -t agamblin/multi-client:latest -t agamblin/eh-client:$SHA -f ./client/Dockerfile ./client 
docker build -t agamblin/eh-server:latest -t agamblin/eh-server:$SHA -f ./server/Dockerfile ./server

docker push agamblin/eh-client:latest
docker push agamblin/eh-server:latest

docker push agamblin/eh-client:$SHA
docker push agamblin/eh-server:$SHA

kubectl apply -f deployment/k8s

kubectl set image deployments/server-deployment server=agamblin/eh-server:$SHA
kubectl set image deployments/client-deployment client=agamblin/eh-client:$SHA