
# Infrastructure and CI/CD Pipeline for EKS Deployment

This project sets up a scalable and secure infrastructure on AWS using Terraform. It deploys a Python Flask web application on an EKS cluster, connects to a PostgreSQL database using Kubernetes Secrets, and includes a CI/CD pipeline implemented with GitHub Actions.

The instructions provided are designed to allow you to run and test the project locally on your PC after cloning the repository.

---

## **Features**

- VPC with public and private subnets
- NAT Gateway and Internet Gateway for networking
- Application Load Balancer (ALB) for traffic distribution
- IAM Roles for EKS Cluster and Node Groups
- EKS cluster with managed node groups
- Multi-stage Docker build for Python app
- PostgreSQL database access via Kubernetes Secrets
- CI/CD pipeline for infrastructure provisioning and application deployment
- Basic monitoring with Prometheus and Kubernetes Metrics Server
- Horizontal Pod Autoscaler (HPA) for automatic pod scaling based on CPU or memory utilization
- Log aggregation using ElasticSearch, Fluentd, and Kibana (ELK)
- Optional: S3 Bucket for storing Terraform state
- Optional: DynamoDB table for state locking to prevent multiple concurrent edits

---

## **Requirements**

1. **AWS Account**

   - An active AWS account with programmatic access.
   - Access Key and Secret Key for AWS.

2. **Terraform**

   - Install Terraform: [Terraform Download](https://www.terraform.io/downloads.html)
   - Version: `>= 1.3.0`

3. **AWS CLI**

   - Install the AWS CLI: [AWS CLI Installation](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html)
   - Version: `>= 2.0.0`
   - Configure it:
     ```bash
     aws configure
     ```

4. **kubectl**

   - Install `kubectl` for managing Kubernetes clusters: [Install kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
   - Version: `>= 1.24`

5. **Docker**

   - Install Docker: [Docker Installation](https://docs.docker.com/get-docker/)

6. **GitHub Account**

   - Repository with access to GitHub Actions.
   - GitHub Secrets set up with AWS credentials.

---

## **Getting Started**

### **Step 1: Clone the Repository**

Clone this repository to your local machine:

```bash
git clone https://github.com/habrazilay/orpak_challenge.git
cd orpak_challenge
```

---


### **Step 2: Create IAM Groups and Assign Permissions**

#### **Create the `ci-cd-users` Group**

1. Log in to the [AWS Management Console](https://aws.amazon.com/console/).
2. Navigate to the IAM service and create a new group named `ci-cd-users`.
3. Attach the following policies:
   - `AmazonEC2FullAccess` (AWS managed)
   - `AmazonEKSClusterPolicy` (AWS managed)
   - `AmazonEKSWorkerNodePolicy` (AWS managed)
   - `AmazonS3FullAccess` (AWS managed)

4. Add a custom managed policy named `ci-cd-user-permissions` with the following JSON content:

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "iam:CreateRole",
                "iam:AttachRolePolicy",
                "iam:PutRolePolicy",
                "iam:ListRoles",
                "iam:GetRole",
                "iam:PassRole",
                "ec2:DescribeSubnets",
                "ec2:DescribeVpcs",
                "ec2:DescribeRouteTables",
                "ec2:CreateSubnet",
                "ec2:DeleteSubnet"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "iam:PassRole",
            "Resource": [
                "arn:aws:iam::503561459373:role/MyEKSClusterRole",
                "arn:aws:iam::503561459373:role/MyEKSNodeGroupRole"
            ]
        }
    ]
}
```

#### **Create the `eks-admins` Group**

1. In the IAM service, create a new group named `eks-admins`.
2. Attach the following policies:
   - `AmazonEC2FullAccess` (AWS managed)
   - `AmazonEKSClusterPolicy` (AWS managed)
   - `AmazonEKSServicePolicy` (AWS managed)
   - `CloudWatchLogsFullAccess` (AWS managed)
   - `IAMFullAccess` (AWS managed)

---

## **Step 2.1: Configure AWS Credentials**

Set up your AWS Access Key and Secret Access Key:

```bash
aws configure
```

Provide your:

- AWS Access Key ID
- AWS Secret Access Key
- Default Region (e.g., `us-east-1`)

---


### **Step 2.2: Add Users to IAM Groups**

To grant permissions for Terraform execution, add the required users to the `ci-cd-users` and `eks-admins` IAM groups.

#### **Add Users to IAM Groups**

1. **Log in to AWS Management Console**:
   - Go to the [AWS IAM Console](https://console.aws.amazon.com/iam/).

2. **Navigate to User Management**:
   - In the left-hand menu, select **Users**.

3. **Select or Create the User**:
   - If the user does not exist:
     - Click on **Add users** and create a new user with the desired username (e.g., `local-mac-user` or `github-actions-user`).
     - Ensure the user has **Programmatic access** enabled.
   - If the user exists, skip to the next step.

4. **Assign the User to Groups**:
   - Select the user from the list.
   - Go to the **Groups** tab and click on **Add to groups**.
   - Select the groups:
     - `ci-cd-users`
     - `eks-admins`
   - Click **Add to groups**.

5. **Verify Permissions**:
   - Once the user is added to the groups, ensure the user has the necessary permissions by navigating to the **Permissions** tab under the user's details.
   - Confirm that the policies associated with the `ci-cd-users` and `eks-admins` groups are listed.

---

#### **Why This Step is Necessary**
Adding users to these groups ensures they inherit the necessary permissions to create and manage AWS resources during Terraform execution.

---

### **Step 3: Define Variables**

The global `variables.tf` file already contains all necessary variables for the Terraform configuration. You only need to modify the default values in the file according to your custom requirements. This approach ensures a centralized way of managing configurations.

---

#### **Variables to Update**
1. **`cluster_name`**: Update this to reflect the desired name for your EKS cluster.
   - Default: `"my-eks-cluster"`
   - Replace with your cluster name.

2. **`aws_region`**: Specify the AWS region where resources will be deployed.
   - Default: `"us-east-1"`
   - Replace with your preferred region.

3. **`trusted_ip`**: Update with the IP address for SSH access (if needed). However, **using AWS credentials is recommended instead of SSH**.
   - Default: `"192.168.1.137/32"`
   - Replace with your current IP address or remove if not using SSH.

4. **`common_tags`**: These tags are applied to all resources for organization.
   - Default:
     ```hcl
     default = {
       Project     = "OrpakProject"
       Environment = "simulation"
     }
     ```
   - Update to match your project's name and environment.

---

#### **Best Practices**
- Avoid hardcoding sensitive data like SSH keys or IPs in variables. Use AWS credentials for authentication and resource management.
- Always customize the `common_tags` to reflect your organization's standards for identifying resources.

By modifying these values, the Terraform configuration becomes tailored to your infrastructure needs without requiring further updates to the Terraform files.

---


### **Step 4: Deploy the Infrastructure**

#### **Step 4.1: Initialize and Validate Terraform**

**Initialize Terraform:**
```bash
terraform init
```

**Validate the configuration:**
```bash
terraform validate
```

**Plan the deployment:**
```bash
terraform plan
```

---

#### **Step 4.2: Deploy Network and Security Groups**

Uncomment the Network and Security Groups modules in `main.tf`:

```hcl
# terraform_files/modules/networks/main.tf
# Provider configuration
provider "aws" {
  region = var.aws_region
}

# Instantiate the security groups module
module "security_groups" {
  source      = "./modules/security_groups"
  vpc_id      = module.networks.vpc_id
  cidr_block  = module.networks.cidr_block
  common_tags = var.common_tags
}

# Instantiate the networks module
module "networks" {
  source               = "./modules/networks"
  vpc_cidr_block       = var.vpc_cidr_block
  private_subnet_cidrs = var.private_subnet_cidrs
  public_subnet_cidrs  = var.public_subnet_cidrs
  availability_zones   = var.availability_zones
  common_tags          = var.common_tags
  alb_sg_id            = module.security_groups.alb_sg_id
}
```

**Apply the configuration to create the Network and Security Groups:**
```bash
terraform apply -auto-approve
```

Confirm that the output related to networks and security groups is generated. Verify the subnets, VPC, and security groups have been successfully created.

---

#### **Step 4.3: Deploy IAM Roles**

Uncomment the IAM roles module in `main.tf`:

```hcl
# Instantiate the IAM roles
module "iam" {
  source = "./modules/iam"
  common_tags = var.common_tags
}
```

**Apply the configuration to create the required IAM roles:**
```bash
terraform apply -auto-approve
```

Verify that the output contains the IAM role ARNs, ensuring the roles are created and ready for use.

---

### **Step 5: Deploy EKS**

#### **Step 5.1: Uncomment EKS Module**

After verifying that the network, security groups, and IAM roles are successfully created, uncomment the EKS module in `main.tf`:

```hcl
# Instantiate the EKS module
module "eks" {
  source             = "./modules/eks"
  cluster_name       = var.cluster_name
  cluster_version    = var.cluster_version
  vpc_id             = module.networks.vpc_id
  subnet_ids         = module.networks.private_subnets
  private_subnets    = module.networks.private_subnets
  public_subnets     = module.networks.public_subnets
  node_group_desired = var.node_group_desired
  node_group_max     = var.node_group_max
  node_group_min     = var.node_group_min
  node_group_instance_types = var.node_group_instance_types
  alb_sg_ids         = [module.security_groups.alb_sg_id]
  cluster_role_arn   = module.iam.cluster_role_arn
  additional_iam_role_arn  = module.iam.eks_node_group_role_arn
  common_tags        = var.common_tags
}
```

---

#### **Step 5.2: Deploy EKS**

**Plan the deployment:**
```bash
terraform plan
```

**Apply the configuration:**
```bash
terraform apply -auto-approve
```

Verify the output contains the EKS cluster ID, node group ARNs, and kubeconfig details.

---

### **Step 6: Build and Push Docker Image**

1. Build the Docker image for the Python Flask app:
   ```bash
   docker build -t your-dockerhub-username/python-flask-app:latest .
   ```
2. Push the image to Docker Hub:
   ```bash
   docker login
   docker push your-dockerhub-username/python-flask-app:latest
   ```

---

### **Step 7: Update Kubernetes Deployment**

The deployment YAML is available [here](https://github.com/habrazilay/orpak_challenge/blob/main/kubernetes/deployments.yaml).

To apply the deployment:

```bash
kubectl apply -f kubernetes/deployments.yaml
```

---

### **Step 8: Deploy via GitHub Actions**

1. Push your changes to the `main` branch:
   ```bash
   git add .
   git commit -m "Initial commit"
   git push origin main
   ```
2. GitHub Actions will trigger the CI/CD pipeline:
   - Terraform provisions the infrastructure.
   - Application is built and deployed to the EKS cluster.

---

### **Step 9: Verify Deployment**

1. **Check Kubernetes Resources**:
   ```bash
   kubectl get nodes
   kubectl get pods
   kubectl get services
   ```
2. **Access the Application**:
   - The Load Balancer's DNS name is available in the output of Terraform.
   - Example:
     ```
     http://<load-balancer-dns>
     ```

---

## **Project Structure**

```plaintext
.
├── README.md                   # Project documentation
├── .gitignore                  # Git ignore file
├── app/                        # Python Flask application
│   ├── app.py                   # Flask application code
│   ├── Dockerfile               # Multi-stage Docker build for Flask app
│   ├── requirements.txt         # Python dependencies
├── kubernetes/                 # Kubernetes manifests
│   ├── deployments.yaml         # Kubernetes deployment manifest
│   ├── hpa.yaml                 # Horizontal Pod Autoscaler manifest
│   ├── services.yaml            # Kubernetes service manifest
├── nginx/                      # Nginx configuration
│   ├── Dockerfile               # Dockerfile for Nginx
├── terraform_files/            # Terraform configuration files
│   ├── backend.tf               # Backend configuration for Terraform state
│   ├── main.tf                  # Root module for Terraform
│   ├── variables.tf             # Root variables
│   ├── outputs.tf               # Outputs for root module
│   ├── modules/                 # Modularized Terraform configuration
│   │   ├── eks/
│   │   │   ├── main.tf           # EKS cluster, node groups, IAM roles
│   │   │   ├── variables.tf      # Module variables
│   │   │   ├── outputs.tf        # Module outputs
│   │   ├── iam/
│   │   │   ├── main.tf           # IAM roles and policies
│   │   │   ├── variables.tf      # Module variables
│   │   │   ├── outputs.tf        # Module outputs
│   │   ├── networks/
│   │   │   ├── main.tf           # VPC, subnets, NAT, route tables
│   │   │   ├── variables.tf      # Module variables
│   │   │   ├── outputs.tf        # Module outputs
│   │   ├── security_groups/
│   │   │   ├── main.tf           # Security groups for ALB, Nginx
│   │   │   ├── variables.tf      # Module variables
│   │   │   ├── outputs.tf        # Module outputs
│   │   ├── resources/
│   │       ├── main.tf           # Additional resources (e.g., S3, DynamoDB, EC2)
│   │       ├── variables.tf      # Module variables
│   │       ├── outputs.tf        # Module outputs

```

---

## **Step 10: Set Up Basic Monitoring**

1. **Metrics Server**:
   Install the Kubernetes Metrics Server:

   ```bash
   kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
   ```

2. **Prometheus Installation**:
   Install Prometheus using Helm:

   ```bash
   helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
   helm repo update
   helm install prometheus prometheus-community/prometheus --namespace monitoring --create-namespace
   ```

3. **Node Exporter**:
   Deploy the Node Exporter to monitor node-level metrics:

   ```bash
   helm install node-exporter prometheus-community/prometheus-node-exporter --namespace monitoring
   ```

4. **kube-state-metrics**:
   Deploy `kube-state-metrics` to monitor Kubernetes resource metrics:

   ```bash
   helm install kube-state-metrics prometheus-community/kube-state-metrics --namespace monitoring
   ```

5. **Access Prometheus**:

   - Use port forwarding to access Prometheus locally:
     ```bash
     kubectl port-forward -n monitoring svc/prometheus-server 9090:80
     ```
   - Open [http://localhost:9090](http://localhost:9090) in your browser.

6. **Verify Monitoring**:

   - Confirm the Prometheus targets in the UI under **Status > Targets**.
   - Query metrics like `node_cpu_seconds_total` to verify data collection.

---

## **Step 11: Set Up Log Aggregation**

### **Step 11.1: Deploy ElasticSearch**

ElasticSearch stores and indexes logs for fast retrieval. Use Helm to deploy:

```bash
helm repo add elastic https://helm.elastic.co
helm repo update
helm install elasticsearch elastic/elasticsearch --namespace logging --create-namespace
```

### **Step 11.2: Deploy Kibana**

Kibana is used to visualize and query logs stored in ElasticSearch:

```bash
helm install kibana elastic/kibana --namespace logging
```

### **Step 11.3: Deploy Fluentd**

Fluentd collects and forwards logs from your Kubernetes pods to ElasticSearch:

```bash
helm repo add fluent https://fluent.github.io/helm-charts
helm repo update
helm install fluentd fluent/fluentd --namespace logging
```

### **Step 11.4: Verify the ELK Stack**

1. **Check Pods**:

   ```bash
   kubectl get pods -n logging
   ```

   Ensure all ELK stack components are running.

2. **Access Kibana**:
   Use port forwarding to access Kibana locally:

   ```bash
   kubectl port-forward -n logging svc/kibana-kibana 5601:5601
   ```

   Open Kibana at: [http://localhost:5601](http://localhost:5601)

3. **Test Log Aggregation**:
   Generate logs from your application and verify them in Kibana.

---

