mvn clean package
APP_VERSION=$1
./xlw apply  -f tomcat/xebialabs.yaml --values appversion=$APP_VERSION,title=$APP_VERSION
./xlw preview  -f tomcat/deployment.yaml --values appversion=$APP_VERSION
./xlw apply  -f tomcat/deployment.yaml --values appversion=$APP_VERSION
