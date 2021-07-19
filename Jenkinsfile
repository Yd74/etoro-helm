node {
    def mvnHome
    stage('Preparation') { 
        sh 'curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3'
        sh 'chmod 700 get_helm.sh'
        sh './get_helm.sh'
        sh 'curl -sL https://aka.ms/InstallAzureCLIDeb | bash'
        sh 'az login --identity'
        sh 'az aks get-credentials --resource-group devops-interview-rg --name yarin-interview-aks --admin'
}
    stage('Deploy') {
        sh 'helm upgrade simple-web --install $WORKSPACE/chart -f $WORKSPACE/chart/values.yaml'
    }
}
