
# Infrastructure and CI/CD Pipeline for EKS Deployment

This project sets up a scalable and secure infrastructure on AWS using Terraform. It deploys an Nginx web application on an EKS cluster and includes a CI/CD pipeline implemented with GitHub Actions.

## **Features**
- VPC with public and private subnets
- NAT Gateway and Internet Gateway for networking
- Application Load Balancer (ALB) for traffic distribution
- EKS cluster with managed node groups
- CI/CD pipeline for infrastructure provisioning and application deployment

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

5. **GitHub Account**
   - Repository with access to GitHub Actions.
   - GitHub Secrets set up with AWS credentials.

---

## **Getting Started**

### **Step 1: Clone the Repository**
Clone this repository to your local machine:
```bash
git clone https://github.com/your-repo-name.git
cd your-repo-name
```

---

### **Step 2: Configure AWS Credentials**
Set up your AWS Access Key and Secret Key:
```bash
aws configure
```
Provide your:
- AWS Access Key ID
- AWS Secret Access Key
- Default Region (e.g., `us-east-1`)

---

### **Step 3: Define Variables**
Update the `variables.tf` file in the root directory with your configurations:
- **`cluster_name`**: Name of your EKS cluster.
- **`aws_region`**: AWS region to deploy resources.
- **`trusted_ip`**: Your IP address for SSH access.

Alternatively, create a `terraform.tfvars` file:
```hcl
aws_region = "us-east-1"
cluster_name = "my-eks-cluster"
trusted_ip = "203.0.113.0/32"
```

---

### **Step 4: Deploy the Infrastructure**
1. Initialize Terraform:
   ```bash
   terraform init
   ```
2. Validate the configuration:
   ```bash
   terraform validate
   ```
3. Plan the deployment:
   ```bash
   terraform plan
   ```
4. Apply the deployment:
   ```bash
   terraform apply -auto-approve
   ```

---

### **Step 5: Set Up GitHub Secrets**
Add the following secrets to your GitHub repository:
1. `AWS_ACCESS_KEY_ID`: Your AWS Access Key ID.
2. `AWS_SECRET_ACCESS_KEY`: Your AWS Secret Access Key.

Navigate to your repository in GitHub:
- Go to `Settings > Secrets and variables > Actions`.
- Add the secrets under the `Secrets` section.

---

### **Step 6: Deploy via GitHub Actions**
1. Push your changes to the `main` branch:
   ```bash
   git add .
   git commit -m "Initial commit"
   git push origin main
   ```
2. GitHub Actions will trigger the CI/CD pipeline:
   - Terraform provisions the infrastructure.
   - Application is deployed to the EKS cluster.

---

### **Step 7: Verify Deployment**
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
├── main.tf                 # Root module for Terraform
├── variables.tf            # Root variables
├── outputs.tf              # Outputs for root module
├── .github/
│   └── workflows/
│       └── cicd-pipeline.yml  # GitHub Actions workflow
├── kubernetes/
│   ├── deployment.yaml      # Kubernetes deployment manifest
│   └── service.yaml         # Kubernetes service manifest
├── modules/
│   ├── networks/
│   │   ├── main.tf          # VPC, subnets, NAT, route tables
│   │   ├── variables.tf     # Module variables
│   │   ├── outputs.tf       # Module outputs
│   ├── security_groups/
│   │   ├── main.tf          # Security groups for ALB, Nginx
│   │   ├── variables.tf     # Module variables
│   │   ├── outputs.tf       # Module outputs
│   └── eks/
│       ├── main.tf          # EKS cluster, node groups, IAM roles
│       ├── variables.tf     # Module variables
│       ├── outputs.tf       # Module outputs
└── README.md                # Project documentation
```

---

## **Notes**
- The CI/CD pipeline only applies changes to the `main` branch.
- Ensure all required tools are installed and configured before running the project.
- To clean up resources, run:
  ```bash
  terraform destroy -auto-approve
  ```

---

## **Future Enhancements**
1. Add Prometheus and Grafana for monitoring.
2. Integrate logging using Fluentd or the ELK stack.
3. Include notifications (e.g., Slack or email) for pipeline results.
