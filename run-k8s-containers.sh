eval $(minikube docker-env)
export DOCKER_TLS_VERIFY="1"
export DOCKER_HOST="tcp://192.168.130.134:2376"
export DOCKER_CERT_PATH="/Users/bmoussaud/.minikube/certs"

APP_VERSION=$1
IMAGE="bmoussaud/petclinic-backend"
REGISTRY="localhost:5000"

#mvn clean package

echo "building $REGISTRY/$IMAGE:$APP_VERSION"

echo "docker build -t $IMAGE PetClinic-Backend"
docker build -t $IMAGE PetClinic-Backend
echo "docker tag $IMAGE:latest $REGISTRY/$IMAGE:$APP_VERSION"
docker tag $IMAGE:latest $REGISTRY/$IMAGE:$APP_VERSION
echo "docker push $REGISTRY/$IMAGE:$APP_VERSION"
docker push $REGISTRY/$IMAGE:$APP_VERSION

xl apply   -f containers/xebialabs.yaml --values appversion=$APP_VERSION,title="run in k8s"
xl preview -f containers/deployment.yaml --values appversion=$APP_VERSION
#xl apply -f containers/deployment.yaml --values appversion=$APP_VERSION

