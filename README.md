# xld-petclinic
This project is a a typical multi-modules Java project with 
* 2 war files (petclinic & petclinic-backend) 
* a dar (Deployment archive) that includes 
    * the 2 war files,
    * a set of SQL files.
    * a datasource
    * a smoke test  (
    * a logger, a custom extension to configure log configuration per environment 
    
    

The readme file details all the operations to package and to deploy it not only using maven and a classic infrastructure but also using the new devops-as-code and targeting a kubernetes cluster.
    
## XLD Server configuration
* install the smoke test plugin into the plugin directory of your XLDeploy Server : https://github.com/xebialabs-community/xld-smoke-test-plugin/releases/tag/v1.0.5)
* paste this snippet into ext/synthetic.xml file of your XLDeploy Server

```
<type type="app.ConfiguredLogger" extends="generic.CopiedArtifact"
    deployable-type="app.Logger" container-type="tomcat.Server">
    <generate-deployable type="app.Logger" extends="generic.Folder"/>
    <property name="targetDirectory" hidden="true" default="${deployed.container.home}/config"/>
    <property name="createTargetDirectory" hidden="true" kind="boolean" default="true"/>
    <property name="restartRequired" kind="boolean" default="true" hidden="true"/>
    <property name="createVerb" default="Configure" hidden="true"/>
    <property name="destroyVerb" default="Destroy" hidden="true"/>
  </type>
```
* restart XLDeploy server.

## Maven 
it uses the [XL Deploy Maven plugin](https://docs.xebialabs.com/xldeploy-maven-plugin/6.0.x/) to package the dar file.

The commands are:

* ` mvn clean package` creates a dar file (dar/target//PetPortal-3.0-CD-SNAPSHOT.dar)

* ` mvn clean install` creates a dar file (dar/target//PetPortal-3.0-CD-SNAPSHOT.dar), imports it into your XLDeploy Server and deploys into `Environments/Dev/Tomcat-Dev` environment.


## As-Code

Since 8.5, XL Deploy provides  [`DevOps as Code`](https://docs.xebialabs.com/xl-platform/concept/devops-as-code-overview.html)

### Manage the web application on tomcat as code

in the `tomcat` Directory you'll find:

* application.yaml describes PetPortal/2.0-92 package
* infrastructure.yaml describes 
    * the targeted infrastructure (a single machine with a tomcat and a database)' 
    * the `Tomcat-Dev-AsCode` environment ans the associated dictionaries.
* deployment.yaml triggers a deployment  PetPortal/2.0-92 -> Tomcat-Dev-AsCode
* xebialabs.yaml an import yaml file that includes the 3 previous files.
 
execution : `xl apply -f tomcat/xebialabs.yaml --values title=demo-as-code`  or `run-tomcat.sh`

### Using the devops as-code to migrate to containers

The petclinic backend war is now packaged and defined in a container and deployed to a Kubernetes Cluster.
 
in the `containers`  Directory you'll find:
* in application.yaml, the backend petclinic has been defined using `k8s.DeploymentSpec` and `k8s.ServiceSpec`
* k8s.yaml defines the targeted K8S cluster
* infrastructure.yaml defines the environement with the dev k8s namespace as a new member 
* deployment.yaml triggers a deployment  PetPortal/(Version) -> Tomcat-Dev-AsCode
* xebialabs.yaml an import yaml file that includes the 4 previous files.

all the commands are in the `run-k8s-containers.sh`  script that builds the images and runs the 'xl apply' commands.

Note: the script build the image and push it into a local registry installed in my minikube
Start your minikube using this alias
```
alias minikube-start=‘minikube start --vm-driver xhyve --insecure-registry localhost:5000’
``` 
Install the registry using this yaml file
```
kubectl apply -f minikube-registry/local-registry.yaml
```
The original setup is describe here: https://mtpereira.com/local-development-k8s.html




### Using the devops as-code to migrate to micro-services & containers

The petclinic backend is now split into several micro services: vet-service, dog-service, cat-service.
The dog-service & cat-service depend of a common service: pet-service.
The main UI petportal is also defined and deployed usng Kubernetes resources: Deployment, Volume, Service,ConfigMap & Ingress.
 
 
in the `microservices`  directory ,you'll find:
* in services.yaml, the import file that points to the description of the 4 services based on k8s components,
* in application.yaml, the application based only with dependencies,
* infrastructure.yaml defines the environment with the dev k8s namespace as a new member and removes the tomcat servers from the env.
* deployment.yaml triggers a deployment  PetPortal/(Version) -> Tomcat-Dev-AsCode
* xebialabs.yaml an import yaml file that includes the 4 previous files.

all the commands are in the `run-microservices.sh` script that builds the images and runs the 'xl apply' commands.


### Sample output

```
$ ./run-k8s-containers.sh 
building localhost:5000/bmoussaud/petclinic-backend:3.0.4
docker build -t bmoussaud/petclinic-backend PetClinic-Backend
Sending build context to Docker daemon  15.87kB
Step 1/2 : FROM tomcat:8.0
 ---> ef6a7c98d192
Step 2/2 : COPY target/PetClinic-Backend.war  /usr/local/tomcat/webapps/PetClinic-Backend.war
 ---> Using cache
 ---> 16db15c1a9f8
Successfully built 16db15c1a9f8
Successfully tagged bmoussaud/petclinic-backend:latest
docker tag bmoussaud/petclinic-backend:latest localhost:5000/bmoussaud/petclinic-backend:3.0.4
docker push localhost:5000/bmoussaud/petclinic-backend:3.0.4
The push refers to repository [localhost:5000/bmoussaud/petclinic-backend]
d4dcf092f47b: Layer already exists
...
8c466bf4ca6f: Layer already exists
3.0.4: digest: sha256:212d08d3133aae44f27587cf982062526494031ab7210eac7e39312eaa2282c5 size: 2832
Applying application.yaml (imported by xebialabs.yaml)
Created Applications/Java/PetPortal/3.0.4/petclinic
Created Applications/Java/PetPortal/3.0.4/sql
.....
Created Applications/Java/PetPortal/3.0.4/petclinic-backend-deployment/petclinic-backend/web
Created Applications/Java/PetPortal/3.0.4/petclinic-backend-deployment/petclinic-backend
Created Applications/Java/PetPortal/3.0.4/petclinic-backend-deployment
Created Applications/Java/PetPortal/3.0.4/petclinic-backend-service/http
Created Applications/Java/PetPortal/3.0.4/petclinic-backend-service
Created Applications/Java/PetPortal/3.0.4
Updated Applications/Java/PetPortal
Applying k8s.yaml (imported by xebialabs.yaml)
...
Updated Infrastructure/AsCode/mykube
Updated Infrastructure/AsCode
Applying infrastructure.yaml (imported by xebialabs.yaml)
Updated Infrastructure/AsCode/host-dev-vm/tomcat-dev/tomcat.vh
....
Updated Environments/Dev/Tomcat-Dev-AsCode
Applying deployment.yaml (imported by xebialabs.yaml)

Task [Update deployment of 'Applications/Java/PetPortal/3.0.4' to 'Environments/Dev/Tomcat-Dev-AsCode'] started (039f79f7-aad2-4bea-bf35-4a9ec01888f6)
Applying xebialabs.yaml
Done
```