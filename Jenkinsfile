def registry = 'https://trial4adu4j.jfrog.io'


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
		stage('SonarQube analysis'){
		environment {
		  scannerHome = tool 'sonar-scanner' //sonar scanner name should be same as what we have defined in the tools
		}
		steps {                                 // in the steps we are adding our sonar cube server that is with Sonar Cube environment.
		withSonarQubeEnv('sonarqube-server') {
		   sh "${scannerHome}/bin/sonar-scanner" // This is going to communicate with our sonar cube server and send the analysis report.
			}
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
                              "target": "libs-snapshot-local/",
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
	  
    }
}
