pipeline {
    agent any
    parameters {
        choice(name: 'OS', choices: ['linux', 'darwin', 'windows'], description: 'Pick OS')
        choice(name: 'ARCH', choices: ['amd64', 'arm64', 'arm'], description: 'Pick Architecture')
    }
    environment{
        REPO = 'https://github.com/vhula/uvbot'
        BRANCH = 'main'
    }
    stages {
        stage('clone') {
            steps {
                echo 'Cloning repository...'
                git branch: "${BRANCH}", url: "${REPO}"
            }
        }
        stage('test') {
            steps {
                echo 'Executing tests...'
                sh 'make test'
            }
        }
        stage('build') {
            steps {
                echo 'Building docker image...'
                sh 'make build TARGETOS=$OS TARGETARCH=$ARCH'
            }
        }
    }
}