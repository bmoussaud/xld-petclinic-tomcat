set -x 
XLD_DEMO_HOME=/tmp/xld-devops-as-code/demo
DIR_NAME=xl-deploy-9.5.1-server
mkdir -p ${XLD_DEMO_HOME}
cd ${XLD_DEMO_HOME}
if [[ ! -e xld.zip ]]; then
  curl --output xld.zip https://dist.xebialabs.com/public/trial/xl-deploy/9.5.1/xl-deploy-9.5.1-server-trial-edition.zip
fi
ls -l xld.zip
unzip -o xld.zip -d ${XLD_DEMO_HOME}
curl -L --out ${DIR_NAME}/plugins/xld-smoke-test-plugin-1.0.7.xldp https://github.com/xebialabs-community/xld-smoke-test-plugin/releases/download/v1.0.7/xld-smoke-test-plugin-1.0.7.xldp
cp ~/xl-licenses/deployit-license.lic ${XLD_DEMO_HOME}/${DIR_NAME}/conf
echo "cp -r ./ext/* ${XLD_DEMO_HOME}/${DIR_NAME}/ext"
echo "${XLD_DEMO_HOME}/${DIR_NAME}/bin/run.sh"



