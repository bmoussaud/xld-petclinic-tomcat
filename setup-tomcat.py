host=repository.create(factory.configurationItem('Infrastructure/host-ubuntu-vm', 'overthere.SshHost', {'address':'deployit.vm','os':'UNIX', 'connectionType':'SFTP', 'username':'ubuntu', 'password':'ubuntu'}))
tomcatdev=repository.create(factory.configurationItem(host.id+'/tomcat-dev', 'tomcat.TomcatServer', {'host':host.id,'home':'/home/ubuntu/tomcat/tomcat-dev','startCommand':'/home/ubuntu/tomcat/tomcat-dev/bin/startup.sh','stopCommand':'/home/ubuntu/tomcat/tomcat-dev/bin/shutdown.sh'}))
vh=repository.create(factory.configurationItem(tomcatdev.id+'/defaultVH', 'tomcat.VirtualHost', {'server':tomcatdev.id}))
data=repository.create(factory.configurationItem('Environments/DictTomcatDev', 'udm.Dictionary', {'entries':{'DATABASE_USERNAME':'UserDev','DATABASE_PASSWORD':'tiger'}}))
env = repository.create(factory.configurationItem('Environments/Tomcat-Env', 'udm.Environment', {'members':[host.id, tomcatdev.id, vh.id], 'dictionaries':[data.id]}))
deployit.print(env)

