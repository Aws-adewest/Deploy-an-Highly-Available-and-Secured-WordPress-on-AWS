# Highly Available and Secured WordPress on AWS: A Comprehensive Guide

This project demonstrates how to deploy a highly available, scalable, and secure WordPress application using various AWS services. The infrastructure is built with a focus on fault tolerance, security, and elasticity to meet the demands of a modern web application.

## Project Overview

- **Cloud Provider:** AWS
- **Application:** WordPress (CMS)
- **Architecture:** Highly Available, Scalable, Secure
- **Key AWS Services Used:** VPC, EC2, RDS, ALB, Auto Scaling, EFS, Route 53, NAT Gateway, Bastion Host

## Table of Contents
1. [Architecture Diagram](#architecture-diagram)
2. [Key AWS Resources](#key-aws-resources)
3. [Setup and Deployment Steps](#setup-and-deployment-steps)
4. [Scripts and Configuration](#scripts-and-configuration)
5. [Conclusion](#conclusion)

## Architecture Diagram

![Html](https://github.com/user-attachments/assets/a337a693-6329-4f09-a186-a6cd6488b33d)


## Key AWS Resources

1. **VPC (Virtual Private Cloud)**:
   - **Subnets:** 3 public web subnets, 3 private app subnets, and 3 private data subnets spread across 3 Availability Zones (AZs) for fault tolerance and high availability.

2. **Internet Gateway**:
   - Enables communication between instances in the VPC and the internet.

3. **Security Groups**:
   - Acts as a firewall, controlling inbound and outbound traffic to EC2 instances, RDS, and other resources.

4. **NAT Gateway**:
   - Allows instances in private subnets to access the internet for software updates and other outbound connections.

5. **Bastion Host**:
   - Provides secure SSH access to instances located in the private subnets through EC2 Instance Connect.

6. **EC2 Instances**:
   - WordPress is hosted on EC2 instances located in the private app subnets. The instances are managed using an Auto Scaling Group to ensure availability and scalability.

7. **Elastic Load Balancer (ALB)**:
   - Distributes incoming traffic across multiple EC2 instances in different AZs, ensuring the website remains accessible even if some instances go down.

8. **Auto Scaling Group**:
   - Automatically adjusts the number of EC2 instances in response to traffic load, ensuring availability and elasticity.

9. **Route 53**:
   - DNS service used to manage and route traffic to the domain name associated with the WordPress application.

10. **RDS (MySQL)**:
    - Managed relational database service used to store WordPress data. The database is hosted in the private data subnets.

11. **Elastic File System (EFS)**:
    - Shared storage used for storing WordPress media files, allowing multiple EC2 instances to access the same data concurrently.

## Setup and Deployment Steps

### 1. VPC and Subnets
Create a custom VPC with the following subnets:

- 3 public subnets for web traffic
- 3 private subnets for application instances
- 3 private subnets for database storage

```bash
aws ec2 create-vpc --cidr-block 10.0.0.0/16
aws ec2 create-subnet --vpc-id <vpc-id> --cidr-block 10.0.1.0/24 --availability-zone <az>
# Repeat for other subnets
```

### 2. Internet Gateway and NAT Gateway
Attach an Internet Gateway to the VPC for internet access and create a NAT Gateway to allow instances in the private subnets to access the internet.

```bash
aws ec2 create-internet-gateway
aws ec2 attach-internet-gateway --vpc-id <vpc-id> --internet-gateway-id <igw-id>

aws ec2 create-nat-gateway --subnet-id <public-subnet-id> --allocation-id <eip-id>
```

### 3. Security Groups
Create and configure security groups for controlling traffic to and from the instances and other resources.

```bash
aws ec2 create-security-group --group-name wordpress-sg --description "Allow web traffic"
aws ec2 authorize-security-group-ingress --group-id <sg-id> --protocol tcp --port 80 --cidr 0.0.0.0/0
aws ec2 authorize-security-group-ingress --group-id <sg-id> --protocol tcp --port 443 --cidr 0.0.0.0/0
```

### 4. EC2 Instances and Auto Scaling
Launch EC2 instances in the private subnets and configure an Auto Scaling Group to handle scaling based on traffic demands.

```bash
aws ec2 run-instances --image-id <ami-id> --instance-type t2.micro --key-name <key-pair> --subnet-id <private-subnet-id> --security-group-ids <sg-id>
aws autoscaling create-auto-scaling-group --auto-scaling-group-name wordpress-asg --launch-configuration-name <launch-config> --min-size 2 --max-size 5 --vpc-zone-identifier <private-subnets>
```

### 5. Application Load Balancer (ALB)
Create an ALB to route incoming web traffic to the EC2 instances.

```bash
aws elbv2 create-load-balancer --name wordpress-alb --subnets <public-subnet-ids> --security-groups <sg-id>
aws elbv2 create-target-group --name wordpress-tg --protocol HTTP --port 80 --vpc-id <vpc-id>
aws elbv2 register-targets --target-group-arn <tg-arn> --targets Id=<instance-id>
```

### 6. RDS MySQL Database
Deploy an RDS MySQL instance in a private subnet for storing WordPress data.

```bash
aws rds create-db-instance --db-instance-identifier wordpress-db --db-instance-class db.t2.micro --engine mysql --allocated-storage 20 --master-username admin --master-user-password <password> --vpc-security-group-ids <sg-id>
```

### 7. EFS for Shared Storage
Create an Elastic File System (EFS) to provide shared storage for WordPress media files.

```bash
aws efs create-file-system --performance-mode generalPurpose --throughput-mode bursting
```

### 8. Install and Configure WordPress
SSH into the EC2 instances via the Bastion Host and install Apache, PHP, and WordPress.

```bash
sudo apt update
sudo apt install apache2
sudo apt install php libapache2-mod-php php-mysql
wget https://wordpress.org/latest.tar.gz
tar -xvzf latest.tar.gz
sudo mv wordpress /var/www/html/
sudo chown -R www-data:www-data /var/www/html/wordpress
sudo systemctl restart apache2
```

### 9. Configure Route 53
Register a domain and set up DNS routing using AWS Route 53.

```bash
aws route53 create-hosted-zone --name <your-domain> --caller-reference <unique-string>
aws route53 change-resource-record-sets --hosted-zone-id <zone-id> --change-batch file://record-sets.json
```

### 10. Connect WordPress to RDS
Modify the `wp-config.php` file in your WordPress installation to connect to the RDS instance.

```php
define('DB_NAME', 'wordpress-db');
define('DB_USER', 'admin');
define('DB_PASSWORD', '<password>');
define('DB_HOST', '<rds-endpoint>');
```

## Scripts and Configuration

(Include any bash scripts or CloudFormation templates you used to automate the deployment in your GitHub repository.)

## LinkedIn Post Template

Here’s a LinkedIn post template to showcase your project:

---

## Conclusion

This project provides a comprehensive guide to deploying a highly available, secure, and scalable WordPress application on AWS using modern cloud architecture. By leveraging AWS services like EC2, RDS, ALB, Auto Scaling, and more, the website is optimized for performance, security, and fault tolerance.

---

Feel free to adjust any details or let me know if you need additional information!
