# eToro interview - Yarin Dolev

## Description

This repository contains the chart of simple-web

## Prerequisites

- Jenkins credentials
  - Username: Yarin
  - Password: Yarin

## Procedure
  
1.  Connect by SSH to the VM using putty
  -  Convert the pem file to ppk file with puttygen for logging in to the vm by ssh with Putty.
  ![error](/Images/puttygenPPK.png)
  -  Login to the vm with azureuser and the new ppk file.
2.  Install CLI tools
  -  Install azure cli
      ```
      curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
      ```
  - install kubectl
      ```
      curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
      sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
      ```
  - Install helm
      ```
      curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
      chmod 700 get_helm.sh
      ./get_helm.sh
      ```
3. Login to azure using "managed identity"
    ```
    az login --identity
    ```
4. Connect to the cluster as admin: 
    ```
    az aks get-credentials --resource-group devops-interview-rg --name yarin-interview-aks --admin
    ```
5. Install ingress nginx controller:
  ```
  	helm install nginx-ingress ingress-nginx/ingress-nginx \
    --namespace ingress-nginx \
    --set controller.replicaCount=2 \
    --set controller.nodeSelector."beta\.kubernetes\.io/os"=linux \
    --set defaultBackend.nodeSelector."beta\.kubernetes\.io/os"=linux \
    --set controller.admissionWebhooks.patch.nodeSelector."beta\.kubernetes\.io/os"=linux \
    --create-namespace
  ```
6. Create and deploy helm chart for simple-web
  - Create chart
    ```
    helm create simple-web-helmchart
    ```
  - Configure chart:
    - find simple-web tags in ACR
      ```
      az acr repository show-tags --name acrinterview --repository simple-web
      ```
    - Change in Chart.yaml appVersion to "latest"
    - change in values.yaml the following:
      - image.repository: acrinterview.azurecr.io/simple-web
      - image.pullPolicy: "Always"
      - service.type: LoadBalancer
  - Push chart to my own github
7. Add HPA and ingress rule
  - Delete LB service
  - Change in values the following
    - autoscaling.enabled change to - true
    - ingress.enabled change to - true
    - ingress.annotations add - kubernetes.io/ingress.class: nginx
    - ingress.hosts.host change to ""
    - service.type to ClusterIP

8. Get extenal ip of ingress LB
     ```
     kubectl get svc -n ingress-nginx
     ```  
   Browse to external ip.
   
### Bonus

  - Install jenkins container from docker.hub
    ```
    docker run -p 8080:8080 -p 50000:50000 --name jenkins --restart always -v jenkinshome:/var/jenkins_home jenkins/jenkins:lts
    ```
  - Get admin password from within the container
    ```
    docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword
    ```
  - Login jenkins using initialAdminPassword from previous step
  - Create admin user (Credentials in the prerequisites section)
  - Create pipeline
  
## Notes
