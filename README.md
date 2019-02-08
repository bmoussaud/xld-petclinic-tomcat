# xld-petclinic-tomcat
This project is a a typical multi-modules maven project with 
* 2 war files (petclinic & petclinic-backend) 
* a dar (Deployment archive) that includes 
    * the 2 war files,
    * a set of SQL files.
    * a datasource
    * a smoke test  (
    * a logger, a custom extension to configure log configuration per environment 
    
    
## extensions:
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

# Manage the web application

in the V2  Directory you'll find:

* application.yaml describes PetPortal/2.0-92 package
* infrastructure.yaml describes 
    * the targeted infrastructure (a single machine with a tomcat and a database)' 
    * the `Tomcat-Dev-AsCode` environment ans the associated dictionaries.
* deployment.yaml triggers a deployment  PetPortal/2.0-92 -> Tomcat-Dev-AsCode
* xebialabs.yaml an import yaml file that includes the 3 previous files.
 
execution : `xl apply -f v2/xebialabs.yaml --values title=demo-as-code`

* Migration to containers

The petclinic backend war is not packaged in a container and deployed to a Kubernetes Cluster.
 
in the V3  Directory you'll find:
* in application.yaml, the backend petclinic has been defined using `k8s.DeploymentSpec` and `k8s.ServiceSpec`
* k8s.yaml defines the targeted K8S cluster
* infrastructure.yaml defines the environement with the dev k8s namespace as a new member 
* deployment.yaml triggers a deployment  PetPortal/(Version) -> Tomcat-Dev-AsCode
* xebialabs.yaml an import yaml file that includes the 4 previous files.

all the commands are in the runv3.sh that builds the images and run the xl apply commands.

```
$ ./runv3.sh 3.0.4
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
d0f3f4011f28: Layer already exists
583dc95d65c9: Layer already exists
f26731984f9b: Layer already exists
9f052711b40a: Layer already exists
81242e1e644e: Layer already exists
39a6e47c4ae6: Layer already exists
fc6174f0df4a: Layer already exists
425325c72d90: Layer already exists
c596d5191368: Layer already exists
daf45b2cad9a: Layer already exists
8c466bf4ca6f: Layer already exists
3.0.4: digest: sha256:212d08d3133aae44f27587cf982062526494031ab7210eac7e39312eaa2282c5 size: 2832
Applying application.yaml (imported by xebialabs.yaml)
Created Applications/Java/PetPortal/3.0.4/petclinic
Created Applications/Java/PetPortal/3.0.4/sql
Created Applications/Java/PetPortal/3.0.4/petDataSource
Created Applications/Java/PetPortal/3.0.4/testPage
Created Applications/Java/PetPortal/3.0.4/logger
Created Applications/Java/PetPortal/3.0.4/petclinic-backend-deployment/petclinic-backend/web
Created Applications/Java/PetPortal/3.0.4/petclinic-backend-deployment/petclinic-backend
Created Applications/Java/PetPortal/3.0.4/petclinic-backend-deployment
Created Applications/Java/PetPortal/3.0.4/petclinic-backend-service/http
Created Applications/Java/PetPortal/3.0.4/petclinic-backend-service
Created Applications/Java/PetPortal/3.0.4
Updated Applications/Java/PetPortal
Applying k8s.yaml (imported by xebialabs.yaml)
Updated Infrastructure/AsCode/mykube/dev
Updated Infrastructure/AsCode/mykube/prd
Updated Infrastructure/AsCode/mykube/qa
Updated Infrastructure/AsCode/mykube
Updated Infrastructure/AsCode
Applying infrastructure.yaml (imported by xebialabs.yaml)
Updated Infrastructure/AsCode/host-dev-vm/tomcat-dev/tomcat.vh
Updated Infrastructure/AsCode/host-dev-vm/tomcat-dev
Updated Infrastructure/AsCode/host-dev-vm/sql-dev
Updated Infrastructure/AsCode/host-dev-vm/testRunner
Updated Infrastructure/AsCode/host-dev-vm
Updated Infrastructure/AsCode
Updated Environments/Dev/AsCode/PetClinic Dictionary
Updated Environments/Dev/AsCode/PetClinic DB Dictionary
Updated Environments/Dev/AsCode
Updated Environments/Dev/Tomcat-Dev-AsCode
Applying deployment.yaml (imported by xebialabs.yaml)
Task [Update deployment of 'Applications/Java/PetPortal/3.0.4' to 'Environments/Dev/Tomcat-Dev-AsCode'] started (039f79f7-aad2-4bea-bf35-4a9ec01888f6)
Applying xebialabs.yaml
Done
```