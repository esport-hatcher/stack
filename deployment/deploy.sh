openssl aes-256-cbc -K $encrypted_af7d608d515d_key -iv $encrypted_af7d608d515d_iv -in deployment/eh-gc-credentials.json.enc -out deployment/eh-gc-credentials.json -d
curl https://sdk.cloud.google.com | bash > /dev/null;
source $HOME/google-cloud-sdk/path.bash.inc
gcloud components update kubectl
gcloud auth activate-service-account --key-file deployment/eh-gc-credentials.json
gcloud config set compute/zone europe-west3-a
gcloud config set project esport-hatcher
gcloud container clusters get-credentials esport-hatcher-1
echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin

docker build -t agamblin/multi-client:latest -t agamblin/eh-client:$SHA -f ./client/Dockerfile ./client 
docker build -t agamblin/eh-server:latest -t agamblin/eh-server:$SHA -f ./server/Dockerfile ./server

docker push agamblin/eh-client:latest
docker push agamblin/eh-server:latest

docker push agamblin/eh-client:$SHA
docker push agamblin/eh-server:$SHA

kubectl apply -f deployment/k8s

kubectl set image deployments/server-deployment server=agamblin/eh-server:$SHA
kubectl set image deployments/client-deployment client=agamblin/eh-client:$SHA