eval $(minikube docker-env)
APP_VERSION="4.0.2"
SERVICE_VERSION="1.0.4"
IMAGE="bmoussaud/petclinic-backend"
REGISTRY="localhost:5000"

xl apply --xl-deploy-url http://localhost:4516 -f microservices/services.yaml --values appversion=$SERVICE_VERSION
xl apply --xl-deploy-url http://localhost:4516 -f microservices/xebialabs.yaml --values appversion=$APP_VERSION,title="built with microservices"

