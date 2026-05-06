// ============================================================
// DevSecOps Pipeline — Tetris Game
// Flow: GitHub → Jenkins → SonarQube → Node → OWASP → Docker
//       → Trivy → DockerHub → K8s → Slack + Splunk
// ============================================================

def COLOR_MAP = [
    'FAILURE' : 'danger',
    'SUCCESS' : 'good'
]

pipeline {
    agent any

    tools {
        jdk 'jdk17'
        nodejs 'node16'
    }

    environment {
        SCANNER_HOME=tool 'mysonar'
    }


    stages {

        // ── Stage 1: Install Tools ──────────────────────────────
        stage('Tool Install') {
            steps {
                echo '==> Installing tools...'
            }
        }

        // ── Stage 2: Clean Workspace ────────────────────────────
        stages {
        stage ("Clean") {
            steps {
                cleanWs()
            }
        }


        // ── Stage 3: Checkout Source Code ───────────────────────
        stage('Code') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/prabhas95/devsecops-tetris.git'
            
            }
        }

        // ── Stage 4: SonarQube Static Analysis ──────────────────
        stage('Sonarqube Analysis') {
            steps {
                withSonarQubeEnv('mysonar') {
                    sh """
                        $SCANNER_HOME/bin/sonar-scanner \
                        -Dsonar.projectName=tetrics \
                        -Dsonar.projectKey=tetrics
                    """
                }
            }
        }

        // ── Stage 5: SonarQube Quality Gate ─────────────────────
        stage('Quality Gates') {
            steps {
                script {
                    waitForQualityGate abortPipeline: false,
                                       credentialsId: 'sonar-token'
                }
            }
        }

        // ── Stage 6: Install Node Dependencies ──────────────────
        stage('Install dependencies') {
            steps {
                sh 'npm install'
                echo '==> npm dependencies installed.'
            }
        }

        // ── Stage 7: OWASP Dependency-Check ─────────────────────
        stage('OWASP') {
            steps {
                dependencyCheck additionalArguments: '--scan ./ --disableYarnAudit --disableNodeAudit',
                                odcInstallation: 'Dp-Check'
                dependencyCheckPublisher pattern: '**/dependency-check-report.xml'
                echo '==> OWASP scan complete.'
            }
        }

        // ── Stage 8: Trivy Filesystem Scan ──────────────────────
        stage('Trivy scan') {
            steps {
                sh 'trivy fs . > trivyfs.txt'
                echo '==> Trivy filesystem scan complete. See trivyfs.txt'
            }
        }

        // ── Stage 9: Build Docker Image ─────────────────────────
        stage('Build Dockerfile') {
            steps {
                sh 'docker build -t image1 .'
                echo '==> Docker image built.'
            }
        }

        // ── Stage 10: Push to DockerHub ─────────────────────────
        stage('Docker Build & Push') {
            steps {
                script {
                    withDockerRegistry(credentialsId: 'docker-password') {
                        sh "docker tag image1 prabhas95/tetrics:v1"
                        sh "docker push prabhas95/tetrics:v1"
                    }
                }
                echo '==> Image pushed to DockerHub.'
            }
        }

        // ── Stage 11: Trivy Image Scan ──────────────────────────
        stage('Scan image') {
            steps {
                sh "trivy image prabhas95/tetrics:v1"
                echo '==> Trivy image scan complete.'
            }
        }

        // ── Stage 12: Deploy to Kubernetes ──────────────────────
        stage('Deploy to K8s') {
            steps {
                sh """
                    kubectl apply -f k8s/deployment.yml
                    kubectl apply -f k8s/service.yml
                    kubectl rollout status deployment/tetris -n ${K8S_NAMESPACE}
                """
                echo '==> Application deployed to Kubernetes.'
            }
        }
    }

    // ── Post Build: Slack + Splunk Notifications ─────────────────
    post {
        always {
            echo 'Slack Notifications'
            slackSend (
                channel: '#deployment',
                color: COLOR_MAP[currentBuild.currentResult],
                message: """*${currentBuild.currentResult}:* Job ${env.JOB_NAME}
Build Number: ${env.BUILD_NUMBER}
More info at: ${env.BUILD_URL}"""
            )
        }
        success {
            echo 'Pipeline succeeded!'
        }
        failure {
            echo 'Pipeline failed!'
        }
    }
}
