# xld-petclinic-tomcat
This project is a a typical multi-modules maven project with 
* 2 war files (petclinic & petclinic-backend) 
* a dar (Deployment archive) that includes the 2 war files and a set of SQL files.

it uses the [XL Deploy Maven plugin](https://docs.xebialabs.com/deployit-maven-plugin/4.5.2) to package the dar file.

# setup
Edit your Maven's setting XML File and add a new `<server>` section:

```
 <servers>
     <server>
      <id>nexus-xebialabs</id>
      <username><YOUR_USERNAME></username>
      <password><YOUR_PASSWORD></password>
    </server>
  </servers>
```

# run

` mvn clean package` creates a dar file (dar/target//PetPortal-3.0-CD-SNAPSHOT.dar)

` mvn clean install` creates a dar file (dar/target//PetPortal-3.0-CD-SNAPSHOT.dar), imports it into your XLDeploy Server and deploys into `Environments/Dev/Tomcat-Dev` environment.


# Extension

The project uses a customs extensions `app.Logger` whose the definition
is in the `ext/` directory.


