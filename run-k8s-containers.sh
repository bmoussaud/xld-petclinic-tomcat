eval $(minikube docker-env)
APP_VERSION="3.0.4"
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

xl apply --xl-deploy-url http://localhost:4516 -f containers/xebialabs.yaml --values appversion=$APP_VERSION,title="run in k8s"

