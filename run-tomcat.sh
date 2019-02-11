mvn clean package

./xlw apply --xl-deploy-url http://localhost:4516 -f v3/xebialabs.yaml --values appversion=$APP_VERSION,title=v3

