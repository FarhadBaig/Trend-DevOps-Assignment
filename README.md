\# Trend — DevOps CI/CD and AWS EKS Deployment



\## Project Overview



This project demonstrates an end-to-end DevOps workflow for deploying the Trend static web application using Docker, Docker Hub, Jenkins, Terraform, AWS EC2, Amazon EKS, and Kubernetes.



The application is served by Nginx on port `3000`. Jenkins builds and pushes the Docker image, while Kubernetes runs two replicas behind an AWS Network Load Balancer.



\## Architecture



GitHub → Jenkins CI Pipeline → Docker Build → Docker Hub → Amazon EKS → Kubernetes Deployment → AWS Network Load Balancer → Users



Infrastructure is provisioned using Terraform.



\## Technologies Used



\- AWS EC2 — Jenkins server

\- AWS VPC, subnets, Internet Gateway, and route tables

\- AWS IAM — roles and permissions

\- Amazon EKS — managed Kubernetes

\- Amazon EC2 — Kubernetes worker node

\- AWS Network Load Balancer — external application access

\- Docker and Docker Hub — containerization and image registry

\- Jenkins — CI pipeline

\- Terraform — Infrastructure as Code

\- Kubernetes — Deployment and Service

\- Nginx — static application web server

\- Git and GitHub — source control



\## Live Application



\*\*Application URL:\*\*



http://a97e17465d4e14ea78df8c1c8f72b6d9-043139bc54d745bd.elb.ap-south-1.amazonaws.com:3000



The URL is served through an AWS Network Load Balancer. It is available while the required AWS resources remain active.



\## Docker Hub



\*\*Image:\*\* `farhadbaig/trend-app`



\*\*Tags:\*\* `latest` and build-specific tags.



Docker Hub repository:

https://hub.docker.com/r/farhadbaig/trend-app



\### Build and Run Locally



```bash

docker build -t trend-app:1.0 .

docker run -d --name trend-app -p 3000:3000 trend-app:1.0

```



Open `http://localhost:3000` in a browser.



\## Jenkins CI Pipeline



Jenkins is hosted on an AWS EC2 instance. The pipeline is configured to use the GitHub repository and `Jenkinsfile`.



Pipeline stages:



1\. Checkout the Git repository.

2\. Verify the Dockerfile and production build files.

3\. Build the Docker image.

4\. Authenticate to Docker Hub using Jenkins credentials.

5\. Push the build-specific image tag and `latest` tag.



Docker Hub credentials are stored in Jenkins Credentials rather than hard-coded in the pipeline.



The pipeline completed successfully and pushed the image to Docker Hub.



\## AWS Infrastructure with Terraform



Terraform configuration is located in the `terraform/` directory.



Infrastructure includes:



\- Custom VPC with CIDR `10.20.0.0/16`

\- Two public subnets across Availability Zones

\- Internet Gateway and routing

\- IAM roles and policies

\- Jenkins EC2 instance and security group

\- Amazon EKS cluster and managed worker node group



\### Important Configuration



\- AWS region: `ap-south-1`

\- EKS cluster: `trend-devops-eks`

\- Kubernetes node group: `trend-devops-workers`

\- Kubernetes version: `1.36`

\- Jenkins instance type: `t3.medium`

\- Worker node type: `t3.medium`



\### Terraform Commands



Run these commands from the `terraform/` directory after configuring the appropriate AWS CLI profile and local variables:



```bash

terraform init

terraform fmt -check

terraform validate

terraform plan

```



Review the plan before applying infrastructure changes. Do not apply a plan that unexpectedly replaces or destroys resources.



\## Kubernetes Deployment



Kubernetes manifests are located in `k8s/`.



\- `k8s/deployment.yaml` — two application replicas, container port `3000`, resource requests and limits, readiness and liveness probes.

\- `k8s/service.yaml` — LoadBalancer Service exposing port `3000`.



\### Deploy the Application



Configure access to the EKS cluster:



```bash

aws eks update-kubeconfig \\

&#x20; --name trend-devops-eks \\

&#x20; --region ap-south-1 \\

&#x20; --profile brain-tasks-paid

```

\## Monitoring



Metrics Server is installed in the `kube-system` namespace to provide basic Kubernetes CPU and memory metrics.



Check node resource usage:



```bash

kubectl top nodes

```



Check application pod usage:



```bash

kubectl top pods

```



Verify Metrics Server:



```bash

kubectl get pods -n kube-system -l k8s-app=metrics-server

```



Metrics Server provides current resource usage. It does not provide long-term metrics storage, alerting, or a Prometheus/Grafana dashboard.



Monitoring evidence is available in `screenshots/13-monitoring.png`.



Apply the manifests:



```bash

kubectl apply -f k8s/deployment.yaml

kubectl apply -f k8s/service.yaml

```



Verify the rollout and resources:



```bash

kubectl rollout status deployment/trend-app

kubectl get deployments,pods,services

kubectl describe service trend-app-service

```



The successful deployment had two ready application pods and an externally accessible AWS Network Load Balancer.



\## AWS Network Load Balancer



\*\*Type:\*\* Network Load Balancer  

\*\*Region:\*\* `ap-south-1`



\*\*Load Balancer ARN:\*\*



`arn:aws:elasticloadbalancing:ap-south-1:395307915231:loadbalancer/net/a97e17465d4e14ea78df8c1c8f72b6d9/043139bc54d745bd`



Check its status using:



```bash

aws elbv2 describe-load-balancers \\

&#x20; --profile brain-tasks-paid \\

&#x20; --region ap-south-1

```



\## Repository Structure



```text

Trend/

├── dist/

├── k8s/

│   ├── deployment.yaml

│   └── service.yaml

├── screenshots/

├── terraform/

│   ├── eks.tf

│   ├── jenkins.tf

│   ├── main.tf

│   ├── variables.tf

│   └── versions.tf

├── .dockerignore

├── .gitignore

├── Dockerfile

├── Jenkinsfile

└── README.md

```



\## Screenshots



The `screenshots/` directory contains evidence of the project workflow, including:



1\. Git clone and repository setup

2\. Docker image build

3\. Local Docker container

4\. Application in a browser

5\. Docker Hub image push

6\.

