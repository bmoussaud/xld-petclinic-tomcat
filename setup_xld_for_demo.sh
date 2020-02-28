set -x 
XLD_DEMO_HOME=./xld-devops-as-code
DIR_NAME=xl-deploy-9.5.2-server
if [[ ! -e /tmp/xld.zip ]]; then
  curl --output /tmp/xld.zip https://dist.xebialabs.com/public/trial/xl-deploy/9.5.2/xl-deploy-9.5.2-server-trial-edition.zip
fi
ls -l /tmp/xld.zip
mkdir -p ${XLD_DEMO_HOME}
unzip -o /tmp/xld.zip -d ${XLD_DEMO_HOME}
curl -L --out ${XLD_DEMO_HOME}/${DIR_NAME}/plugins/xld-smoke-test-plugin-1.0.7.xldp https://github.com/xebialabs-community/xld-smoke-test-plugin/releases/download/v1.0.7/xld-smoke-test-plugin-1.0.7.xldp
cp ~/xl-licenses/deployit-license.lic ${XLD_DEMO_HOME}/${DIR_NAME}/conf
echo "cp -r ./ext/* ${XLD_DEMO_HOME}/${DIR_NAME}/ext"
echo "${XLD_DEMO_HOME}/${DIR_NAME}/bin/run.sh"



