def registry = 'https://trial4adu4j.jfrog.io'
def imageName = 'trial4adu4j.jfrog.io/vru-docker-local/namtrend'
def version   = '2.1.3'


pipeline {
    agent { label 'maven' }

    environment {
        PATH = "/opt/apache-maven-3.9.6/bin:$PATH"
    }

    stages {
        stage("build") {
            steps {
                echo "------- build started --------"
                sh 'mvn clean deploy -Dmaven.test.skip=true'
                echo "---------build completed ----------"
            }
        }
	    stage("Jar Publish") {
        steps {
            script {
                    echo '<--------------- Jar Publish Started --------------->'
                     def server = Artifactory.newServer url:registry+"/artifactory" ,  credentialsId:"jfrog-creds"
                     def properties = "buildid=${env.BUILD_ID},commitid=${GIT_COMMIT}";
                     def uploadSpec = """{
                          "files": [
                            {
                              "pattern": "jarstaging/(*)",
                              "target": "vru-libs-release-local/{1}",
                              "flat": "false",
                              "props" : "${properties}",
                              "exclusions": [ "*.sha1", "*.md5"]
                            }
                         ]
                     }"""
                     def buildInfo = server.upload(uploadSpec)
                     buildInfo.env.collect()
                     server.publishBuildInfo(buildInfo)
                     echo '<--------------- Jar Publish Ended --------------->' 

            }
        }
    }
		stage(" Docker Build ") {
        steps {
            script {
               echo '<--------------- Docker Build Started --------------->'
               app = docker.build(imageName+":"+version)
               echo '<--------------- Docker Build Ends --------------->'
            }
          }
        }

		stage (" Docker Publish "){
        steps {
            script {
                echo '<--------------- Docker Publish Started --------------->' 
                docker.withRegistry(registry, 'jfrog-creds'){
                app.push()
                }
                echo '<--------------- Docker Publish Ended --------------->'
                }
            }
        }
	  
    }
}
