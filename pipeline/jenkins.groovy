pipeline {
    agent any
    parameters {
        choice(name: 'OS', choices: ['linux', 'darwin', 'windows'], description: 'Pick OS')
        choice(name: 'ARCH', choices: ['amd64', 'arm64', 'arm'], description: 'Pick Architecture')
    }
    environment{
        REPO = 'https://github.com/vhula/uvbot'
        BRANCH = 'main'
        IMAGE_NAME = 'vhula/uvbot'
        REGISTRY = 'ghcr.io'
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
                echo 'Building binary...'
                sh 'make build TARGETOS=${params.OS} TARGETARCH=${params.ARCH}'
            }
        }
        stage('image') {
            steps {
                echo 'Building docker image...'
                sh 'make image REGISTRY=$REGISTRY IMAGE_NAME=$IMAGE_NAME TARGETOS=${params.OS} TARGETARCH=${params.ARCH}'
            }
        }
        stage('publish-image') {
            steps {
                echo 'Publishing docker image...'
                sh 'make push REGISTRY=$REGISTRY IMAGE_NAME=$IMAGE_NAME TARGETOS=${params.OS} TARGETARCH=${params.ARCH}'
            }
        }
    }
}