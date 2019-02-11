mvn clean package
APP_VERSION=2.0-92
./xlw apply --xl-deploy-url http://localhost:4516 -f tomcat/xebialabs.yaml --values appversion=$APP_VERSION,title=$APP_VERSION

