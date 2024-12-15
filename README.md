
# Infrastructure and CI/CD Pipeline for EKS Deployment

This project sets up a scalable and secure infrastructure on AWS using Terraform. It deploys a Python Flask web application on an EKS cluster, connects to a PostgreSQL database using Kubernetes Secrets, and includes a CI/CD pipeline implemented with GitHub Actions.

---

## **Features**
- VPC with public and private subnets
- NAT Gateway and Internet Gateway for networking
- Application Load Balancer (ALB) for traffic distribution
- EKS cluster with managed node groups
- Multi-stage Docker build for Python app
- PostgreSQL database access via Kubernetes Secrets
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

### **Step 4: Create Kubernetes Secrets**
Store the database credentials securely as Kubernetes Secrets:
```bash
kubectl create secret generic postgres-secrets   --from-literal=DB_NAME=mydatabase   --from-literal=DB_USER=myuser   --from-literal=DB_PASSWORD=mypassword   --from-literal=DB_HOST=my-database-host   --from-literal=DB_PORT=5432
```

---

### **Step 5: Deploy the Infrastructure**
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
1. Update the `kubernetes/deployment.yaml` file to include the Docker image and database secrets:
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: flask-app
spec:
  replicas: 2
  selector:
    matchLabels:
      app: flask-app
  template:
    metadata:
      labels:
        app: flask-app
    spec:
      containers:
      - name: flask-app
        image: your-dockerhub-username/python-flask-app:latest
        ports:
        - containerPort: 5000
        env:
        - name: DB_NAME
          valueFrom:
            secretKeyRef:
              name: postgres-secrets
              key: DB_NAME
        - name: DB_USER
          valueFrom:
            secretKeyRef:
              name: postgres-secrets
              key: DB_USER
        - name: DB_PASSWORD
          valueFrom:
            secretKeyRef:
              name: postgres-secrets
              key: DB_PASSWORD
        - name: DB_HOST
          valueFrom:
            secretKeyRef:
              name: postgres-secrets
              key: DB_HOST
        - name: DB_PORT
          valueFrom:
            secretKeyRef:
              name: postgres-secrets
              key: DB_PORT
```
2. Apply the deployment:
   ```bash
   kubectl apply -f kubernetes/deployment.yaml
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
├── app.py                  # Python Flask application
├── requirements.txt        # Python dependencies
├── Dockerfile              # Multi-stage Docker build
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

## **Notes**
- The CI/CD pipeline only applies changes to the `main` branch.
- Ensure all required tools are installed and configured before running the project.
- To clean up resources, run:
   ```bash
   terraform destroy -auto-approve
   ```

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

