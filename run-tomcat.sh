mvn clean package
APP_VERSION=2.0-92
./xlw apply  -f tomcat/xebialabs.yaml --values appversion=$APP_VERSION,title=$APP_VERSION
./xlw preview  -f tomcat/deployment.yaml
./xlw apply  -f tomcat/deployment.yaml
