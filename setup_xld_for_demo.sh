#set -x 
XLD_DEMO_HOME=/tmp/xld-devops-as-code/demo
DIR_NAME=xl-deploy-9.5.1-server
mkdir -p ${XLD_DEMO_HOME}
cd ${XLD_DEMO_HOME}
if [[ ! -e xld.zip ]]; then
  curl --output xld.zip https://dist.xebialabs.com/public/trial/xl-deploy/9.5.1/xl-deploy-9.5.1-server-trial-edition.zip
fi
ls -l xld.zip
#unzip -o xld.zip
curl -L --out ${DIR_NAME}/plugins/xld-smoke-test-plugin-1.0.7.xldp https://github.com/xebialabs-community/xld-smoke-test-plugin/releases/download/v1.0.7/xld-smoke-test-plugin-1.0.7.xldp
cp ~/xl-licenses/deployit-license.lic ${XLD_DEMO_HOME}/${DIR_NAME}/conf
echo '<?xml version="1.0" encoding="UTF-8"?>
<synthetic xsi:schemaLocation="http://www.xebialabs.com/deployit/synthetic synthetic.xsd" xmlns="http://www.xebialabs.com/deployit/synthetic" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">

  <type type="app.ConfiguredLogger" extends="generic.CopiedArtifact"
    deployable-type="app.Logger" container-type="tomcat.Server">
    <generate-deployable type="app.Logger" extends="generic.Folder"/>
    <property name="targetDirectory" hidden="true" default="${deployed.container.home}/config"/>
    <property name="createTargetDirectory" hidden="true" kind="boolean" default="true"/>
    <property name="restartRequired" kind="boolean" default="true" hidden="true"/>
    <property name="createVerb" default="Configure" hidden="true"/>
    <property name="destroyVerb" default="Destroy" hidden="true"/>
  </type>

</synthetic>
' > "${XLD_DEMO_HOME}/${DIR_NAME}/ext/synthetic.xml"

echo "${XLD_DEMO_HOME}/${DIR_NAME}/bin/run.sh"



