# Introduction

**Project is in development**

This repo contains code to deploy the required AWS infrastructure for a web application. **Please note that not all of the below services qualify for free-tier usage. See https://aws.amazon.com/pricing/ for more information.** Main components include: 

1. AWS VPC, including two public and two private subnets spanning two Availability Zones in the us-west-2 region
    - Internet Gateway
    - NAT Gateway
    - Public and Private Route Tables with corresponding routes
    - Two EIPs connected to the pubic subnets
    - DynamoDB Endpoint
2. AWS ECS
    - IAM roles for ECS Services and Tasks
    - ECR Repository for Docker base image
    - ECS Service
    - ECS Task

# Requirements

1. Local installation of Terraform: https://www.terraform.io/downloads.html
2. Users have admin access to a GitHub account in order to use and run GitHub Actions via workflow files.
3. Users should have the following branches in their GitHub Repo: 
    - feature 
    - dev
    - release
    - master

    Each branch is used in the GitHub Actions pipeline and must match exactly in order to trigger the build. This project assumes a [Git flow](https://www.atlassian.com/git/tutorials/comparing-workflows/gitflow-workflow) where each branch maps to a deployment environment: 
        
    - dev = development
    - release = QA
    - master = prod

4. Users have set up an AWS account, and have created a role that has permissions to deploy resources: 
    - https://aws.amazon.com/premiumsupport/knowledge-center/create-and-activate-aws-account/
    - https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_create.html
5. Users have set up their own AWS Access Key ID (named AWS_ACCESS_KEY_ID) and Secret Access Key (named AWS_SECRET_ACCESS_KEY) in GitHub Secrets: https://docs.github.com/en/free-pro-team@latest/actions/reference/encrypted-secrets
6. Local installation of npm & Node.js: https://www.npmjs.com/get-npm 
7. Local installation of React.js: https://reactjs.org/docs/getting-started.html

# Project Structure

.  
├── Dockerfile  
├── deployments  
│   ├── dev  
│   │   ├── ecr  
│   │   │   ├── main.tf  
│   │   │   ├── outputs.tf  
│   │   │   └── variables.tf  
│   │   └── remote_state_backend  
│   │       ├── main.tf  
│   │       ├── outputs.tf   
│   │       └── variables.tf  
│   ├── prod  
│   │   └── remote_state_backend  
│   │       ├── main.tf  
│   │       ├── outputs.tf  
│   │       └── variables.tf  
│   └── qa  
│       └── remote_state_backend  
│           ├── main.tf  
│           ├── outputs.tf   
│           └── variables.tf  
├── modules  
│   ├── dev.tfvars  
│   ├── ecs  
│   │   ├── main.tf  
│   │   ├── outputs.tf  
│   │   └── variables.tf  
│   ├── iam  
│   │   ├── main.tf  
│   │   ├── outputs.tf  
│   │   └── variables.tf  
│   ├── main.tf  
│   ├── outputs.tf  
│   ├── prod.tfvars  
│   ├── qa.tfvars  
│   ├── remote_state_backend  
│   │   ├── main.tf  
│   │   ├── outputs.tf  
│   │   └── variables.tf  
│   ├── variables.tf  
│   └── vpc  
│       ├── main.tf  
│       ├── outputs.tf  
│       └── variables.tf  
└── web_app  
    ├── nginx  
    │   └── nginx.conf  
    ├── package.json  
    ├── public  
    │   ├── favicon.ico  
    │   ├── index.html  
    │   ├── logo192.png  
    │   ├── logo512.png  
    │   ├── manifest.json  
    │   └── robots.txt  
    ├── src  
    │   ├── App.css  
    │   ├── App.js  
    │   ├── App.test.js  
    │   ├── index.css  
    │   ├── index.js  
    │   ├── logo.svg  
    │   ├── serviceWorker.js  
    │   └── setupTests.js  
    └── yarn.lock  

# Deployment Steps

1. Clone the repo to your local machine. 
2. Change the Git origin URL to your own repo: 
    ```
    git remote set-url origin http://github.com/{YOU}/{YOUR_REPO}
    ```
3. Change directories into the /project/deployments/dev/remote_state_backend folder. 
    ```
    $ cd project/deployments/dev/remote_state_backend
    ```
4. Deploy the Terraform remote_state_backend to your AWS account: 

    See https://github.com/cloudposse/terraform-aws-tfstate-backend for more information.

    ```
    $ terraform init
    $ terraform validate
    $ terraform plan
    $ terraform apply --auto-approve
    ```

5. Change directory to /project/deployments/dev/ecr and deploy the ECR Repository: 

    ```
    $ cd .. && cd ecr
    $ terraform init
    $ terraform validate
    $ terraform plan
    $ terraform apply --auto-approve
    ```

6. Follow steps 4 and 5 for the /project/deployments/qa and project/deployments/prod directories.

### You are now ready to begin working with the project.  

7. Push the code up to you GitHub repository's **feature branch**. Verify pipeline functionality in the browser by navigating to your GitHub repo and clicking on the "Actions" tab. The pipeline should: 
    - Configure your AWS Credentials using your GitHub secrets
    - Log into AWS ECR
    - Build and push a Docker image to your ECR repo
    - Check Terraform formatting
    - Initialize Terraform
    - Validate Terraform
    - Plan Terraform
8. After viewing the Terraform plan in your pipeline, you can deploy infrastructure into your Dev environment by merging your feature branch into your dev branch. On merge, the pipeline should:  
    - Configure your AWS Credentials using your GitHub secrets
    - Log into AWS ECR
    - Build and push a Docker image to your ECR repo
    - Check Terraform formatting
    - Initialize Terraform
    - Validate Terraform
    - Plan Terraform
    - Apply Terraform into your AWS account. 

# Tearing Down Deployed Infrastructure - Important to avoid unexpected AWS charges!

### You should utilize your GitHub Actions pipeline to destroy the infrastructure, rather than making changes in your AWS console to avoid state drift and ensure that all deplopyed resources have been removed.  

1. Navigate to /projects/modules
    ```
    $ cd /project/modules
    ```
2. Locate the three files ending in .tfvars
    - dev.tfvars
    - qa.tfvars
    - prod.tfvars

3. Each .tfvars file in project/modules contains a variable called "enabled". When set to true, the pipeline will deploy the project infrastructure into the corresponding environment. To remove the infrastructure, you will need to set the environment .tfvars enabled flags to false. You can then push the changes to your GitHub account, and follow the same steps used for for deployment.  

4. Verify that your Terraform plan(s) state that all infrastructure will be torn down, merge the code to the corresponding environment branch, and review the Terraform apply output for deletion. Please note that you will need to do this for EACH environment that you have deployed to. 


# Acknowledgments

1. Much of the underlying infrastructure was modeled after the below AWS tutorial: 

    - https://aws.amazon.com/getting-started/hands-on/build-modern-app-fargate-lambda-dynamodb-python/module-two/
    - https://github.com/abaird986/aws-modern-application-workshop/blob/master/module-2/

2. Terraform Modules Used: 

    - https://github.com/cloudposse/terraform-aws-tfstate-backend
    - https://github.com/cn-terraform/terraform-aws-ecs-fargate-task-definition

3. Dockerizing a React App by Michael Herman: https://mherman.org/blog/dockerizing-a-react-app/
4. Deploy Your React App to ECS (Fargate) by Mubbashir Mustafa https://dev.to/mubbashir10/deploy-your-react-app-to-ecs-fargate-38p9
5. @lilithmooncohen assisted with by answering various Docker-related questions: https://github.com/lilithmooncohen
