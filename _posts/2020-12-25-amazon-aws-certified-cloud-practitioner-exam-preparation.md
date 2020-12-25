---
layout: post
cover: 'assets/images/amazon-aws-certified-cloud-practitioner-exam-preparation.jpg'
title: Amazon AWS Certified Cloud Practitioner exam preparation
description: ''
date: 2020-12-25 00:00:00
tags: amazon aws certified cloud-practitioner exam preparation
author: Ray Bogman
img1: assets/images/1x1/amazon-aws-certified-cloud-practitioner-exam-preparation.jpg
img4: assets/images/4x3/amazon-aws-certified-cloud-practitioner-exam-preparation.jpg
img16: assets/images/16x9/amazon-aws-certified-cloud-practitioner-exam-preparation.jpg
---




## White Papers

### Overview of Amazon Web Services
[AWS Overview](https://d0.awsstatic.com/whitepapers/aws-overview.pdf)

### Architecting for the Cloud: Best Practices
[Best Practices](https://aws.amazon.com/blogs/aws/new-whitepaper-architecting-for-the-cloud-best-practices/)

### How AWS Pricing Works
[AWS Pricing](http://d1.awsstatic.com/whitepapers/aws_pricing_overview.pdf)

### Compare AWS Support Plans
[AWS Support Plans](https://aws.amazon.com/premiumsupport/plans/)

### AWS well architected framework
[AWS well architected framework](https://d1.awsstatic.com/whitepapers/architecture/AWS_Well-Architected_Framework.pdf)

### AWS disaster recovery (optional)
[Disaster Recovery](https://aws.amazon.com/cloudendure-disaster-recovery/)

## Resources
[https://infrastructure.aws/](https://infrastructure.aws/)
[https://aws.amazon.com/compliance/shared-responsibility-model/](https://aws.amazon.com/compliance/shared-responsibility-model/)
[https://aws.amazon.com/s3/storage-classes/](https://aws.amazon.com/s3/storage-classes/)
[http://s3-accelerate-speedtest.s3-accelerate.amazonaws.com/en/accelerate-speed-comparsion.html](http://s3-accelerate-speedtest.s3-accelerate.amazonaws.com/en/accelerate-speed-comparsion.html)
[https://pages.awscloud.com/Global-Challenge-Resources.html](https://pages.awscloud.com/Global-Challenge-Resources.html)
[https://towardsdatascience.com/how-to-become-an-aws-certified-cloud-practitioner-in-10-days-83a08e316e72?gi=49a6f7a9d7d8](https://towardsdatascience.com/how-to-become-an-aws-certified-cloud-practitioner-in-10-days-83a08e316e72?gi=49a6f7a9d7d8)

### AWS Products/Acronyms

The following AWS products/acronyms are important to know by heart. Lots of them will be asked for during the exam. Get  yourself familiarized!


* <strong>AWS Regions</strong> - Cluster of data centers (AWS Availability Zones - in side the Region)
* <strong>IAM</strong> - Identity and Access Management
* <strong>AWS CLI</strong> - Command line Interface
* <strong>AWS SDK</strong> - Software Developer Kit
* <strong>EC2</strong> - Elastic Computing Cloud (On-demand, Reserved [standard + convertible +scheduled], Spot Instance, Dedicated host, Dedicated Instances)
* <strong>EBS</strong> - Elastic Block Store
* <strong>AMI</strong> - Amazon Machine Image
* <strong>EC2 Instance Store</strong> - Temporary storage, high perf hardware disk
* EFS - Elastic File System (NFS)
* ELB - Elastic Load Balancer (Classic, Application, Network Load Balancer)
* ALB - Application Load Balancer
* ASG - Auto Scaling Group
* S3 - Simple Cloud Storage
* CRR - Cross Region Replication
* SRR - Same Region Replication
* AWS Store Gateway - a hybrid cloud storage service that gives you on-premises access to virtually unlimited cloud storage
* RDS - Relational Database Service (Online Transaction Processing (OLTP) )
* ElastiCache - Redis/Memcache
* DynamoDB - noSQL/Serverless DB
* Redshift - OLAP (Online Analytical Processing) [data warehouse]
* EMR - Elastic MapReduce (Hadoop Cluster)
* Athena - Serverless DB (query data S3)
* DMS - Database Migration Service
* Glue - ETL
* ECS - Elastic Container Service
* ECR - Elastic Container Registry
* Fargate - Serverless Container Service/Cluster
* Lambda - Function as a Service/Serverless Computing
* Step Functions - serverless function orchestrator that makes it easy to sequence AWS Lambda functions and multiple AWS services into business-critical applications
* AWS Batch - (managed service like Lambda but on EC2 and can run more than 15 min and has no restrictions)
* Amazon Lightsail - cloud computing for dummies - click an go
* CloudFormation - Infrastructure as code (infra focus)
* AWS Elastic BeanStalk - Platform as a Service (PaaS) (application focus)
* AWS CodeDeploy - (hybrid): deploy & upgrade any application onto servers
* SSM - AWS System Manager (hybrid) (patches your fleet of multi servers/ run command on multi server at once) - operational insights
* AWS OpsWorks - (hybrid) server configuration automatically (Chef or Puppet)
* Route53 - DNS
* CloudFront - CDN
* S3 Transfer Acceleration
* AWS Global Accelerator
* SQS - Simple Queue Service
* SNS - Simple Notification Service
* AWS CloudWatch Metrics/Alarms/Logs/Events = (Amazon EventBridge "next evolution")
* AWS CloudTrail - governance, compliance, audit
* AWS X-Ray - debugging in production
* AWS Status - Service Health Dashboard (https://status.aws.amazon.com/) - RSS output
* AWS Personal Health Dashboard (https://phd.aws.amazon.com/)
* AWS Outpost - Fully managed service that extends AWS infra AWS services, APIs, and tools to any datacenter, co-location space, or on-premises facility. 
* Amazon Kendra - highly accurate and easy to use enterprise search service that’s powered by machine learning.
* VPC - Virtual Private Cloud
* Internet Gateway
* NAT Gateway
* CIDR - Classless Inter-Domain Routing (https://cidr.xyz/)
* NACL - Network Access Control List
* VPC Flow Log - Network traffic logs
* VPC Peering - Connect 2 VPC's
* VPC Endpoint - (private access to AWS services within the VPS [internally]) (S3, DynamoDB)
* Direct Connect - Direct private connection
* Site-to-Site VPN (CGW - Customer Gateway <--> VGW - Virtual Private Gateway)
* Transit Gateway (thousands of VPC/on premises - hub-and-spoke [star] connect)
* AWS Shield Standard - Free DDOS protection
* AWS Shield Advanced - Premium DDOS protection
* AWS WAF - Filter based on rules (DOS)
* Penetration testing
* AWS KMS - Key Management System
* CloudHSM - Hardware Software Module
* AWS Secrets Manager - storing secrets, rotation of secrets,
* AWS Artifact - Get access to compliance report as PCI, ISO etc..
* Amazon GuardDuty - Find malicious  behavior with VPC,DNS, CloudTrail
* Amazon Inspector - For EC2 only, install agent and find vulnerabilities
* AWS Config - Track config changes and compliance audit/monitor
* Amazon Macie - Find sensitive data (eg. PII data) in S3 buckets
* Amazon Rekognition -  Face dedication, labeling, celebrity recognition
* Amazon Transcribe - Audio to text
* Amazon Polly - Text to audio
* Amazon Translate -  Translate
* Amazon Lex -  Conversational bots, chatbot
* Amazon Connect - Cloud contact center
* Amazon Comprehend - Natural language processing (NLP)
* Amazon SageMaker - Machine learning for every developer and data scientist
* AWS Organizations - Main account is the master account (Consolidated Billing, Pricing benefits from aggregated usage, Pooling of Reserved EC2)
* SCP - Service Control Policies (Restrict account privileges)
* AWS Total Cost of Ownership (TCO) Calulator - https://calculator.aws/
* AWS Cost Explorer - Visualize, understand, and manage your AWS costs and usage over time (3 month forecast on cost)
* AWS Budgets - (Cost, Usage, Reservation, Saving plans)
* Amazon Cognito -  (Identity management) Database of user for your mobile/web applications login (sign-in/sign-up)
* AWS Single Sign-On (SSO)  - One login on AWS or web applications
* AWS Directory Services - (AWS Managed AD, AD Connector [proxy], Simple AD)
* AWS Quick Starts - Quick Starts are built by AWS solutions architects and partners to help you deploy popular technologies on AWS quickly
* AWS Cloud9 - Is a cloud-based integrated development environment (IDE) that lets you write, run, and debug your code with just a browser.
* Amazon Quicksight - is a scalable, serverless, embeddable, machine learning-powered business intelligence (BI) service built for the cloud


### AWS Support Plans
- Basic
- Developer
- Business
- Enterprise



### AWS Trusted Advisor -  Analyze your AWS accounts and provides recommendation:
- Cost Optimization
- Performance
- Security
- Fault Tolerance
- Service Limits


### Well Architected Framework
- Operational Excellence
- Security
- Reliability
- Performance Efficiency
- Cost Optimisation


AWS Professional Services
APN - AWS Partner Network
APN Technology Partners
APN Consulting Partners
AWS Training Partners
AWS Competency Partners
AWS Navigate Program

### AWS Simple Monthly Calculator

The <u>Simple Monthly Calculator</u> provides an estimate of usage charges for AWS services based on certain information you provide. It helps customers and prospects <strong>estimate their monthly</strong> AWS bill more efficiently.

This calculator provides a visual interface to enter details about the AWS services that you plan to use and then it outputs a detailed estimate of the monthly AWS bill. Please see the illustration for more details: 

### AWS Total Cost of Ownership (TCO) Calculator

<u>TCO calculator</u> helps to <strong>compare the cost</strong> of your applications in an <strong>on-premises</strong> or <strong>traditional hosting environment</strong> to AWS.

AWS helps reduce Total Cost of Ownership (TCO) by reducing the need to invest in large capital expenditures and providing a pay-as-you-go model that empowers to invest in the capacity you need and use it only when the business requires it.

Once you describe your on-premises or hosting environment configuration, it produces a detailed cost comparison with AWS.
TCO Calculator cannot provide the estimate of the monthly AWS bill based on the list of AWS services.

### AWS Cost Explorer

AWS Cost Explorer has an easy-to-use interface that lets you <strong>visualize</strong>, <strong>understand</strong>, and <strong>manage</strong> your <strong><u>AWS costs and usage over time</u><strong>.

AWS Cost Explorer includes a default report that helps you visualize the costs and usage associated with your top five cost-accruing AWS services, and gives you a detailed breakdown of all services in the table view.

The reports let you adjust the time range to view historical data going back up to twelve months to gain an understanding of your <strong>cost trends</strong>.

AWS Cost Explorer cannot provide the estimate of the monthly AWS bill based on the list of AWS services.

### AWS Budgets

AWS Budgets gives the ability to <strong>set custom budgets</strong> that <strong><u>alert</u></strong> you when your costs or <strong>usage exceed</strong> (or are forecasted to exceed) your budgeted amount. Y

You can also use AWS Budgets to set <u>reservation utilization</u> or <u>coverage targets</u> and receive alerts when your utilization drops below the threshold you define. Budgets can be created at the monthly, quarterly, or yearly level, and you can customize the start and end dates. You can further refine your budget to track costs associated with multiple dimensions, such as AWS service, linked account, tag, and others.

AWS Budgets cannot provide the estimate of the monthly AWS bill based on the list of AWS services.

## Additional Resources
[https://aws.amazon.com/ru/quickstart/architecture/magento/](https://aws.amazon.com/ru/quickstart/architecture/magento/)
[https://docs.aws.amazon.com/quickstart/latest/magento/welcome.html](https://docs.aws.amazon.com/quickstart/latest/magento/welcome.html)
[https://d1.awsstatic.com/whitepapers/migrating-magento-to-aws.pdf](https://d1.awsstatic.com/whitepapers/migrating-magento-to-aws.pdf)
[https://aws.amazon.com/marketplace/pp/Bitnami-Magento-Container-Solution/B07LGF9MK7](https://aws.amazon.com/marketplace/pp/Bitnami-Magento-Container-Solution/B07LGF9MK7)
[https://www.coursera.org/lecture/containerized-apps-on-aws/introduction-to-aws-fargate-psW4r](https://www.coursera.org/lecture/containerized-apps-on-aws/introduction-to-aws-fargate-psW4r)
[https://www.examtopics.com/exams/amazon/aws-certified-cloud-practitioner/view/](https://www.examtopics.com/exams/amazon/aws-certified-cloud-practitioner/view/)
[https://www.exam4training.com/one-of-the-advantages-to-moving-infrastructure-from-an-on-premises-data-center-to-the-aws-cloud-is-2/](https://www.exam4training.com/one-of-the-advantages-to-moving-infrastructure-from-an-on-premises-data-center-to-the-aws-cloud-is-2/)
