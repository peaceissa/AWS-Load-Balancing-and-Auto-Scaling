# AWS Load Balancing and Auto Scaling Hands-on Lab

## Objectives:
- Gain hands-on experience with deploying a highly available and scalable web application architecture on AWS.
- Create an Application Load Balancer (ALB) with two target groups to distribute traffic to your web servers.
- Configure Auto Scaling to automatically scale your web servers based on CPU utilization.
- Use the AWS Stress Test Utility to simulate load and observe the scaling behavior of your application.

## Prerequisites:
- An active AWS account with sufficient permissions to create the required resources.
- Basic understanding of AWS services like EC2, Auto Scaling, and Application Load Balancer.
- Familiarity with the Linux command line.

## Lab Specifications:

### 1. Create an Application Load Balancer:
- Ensure the ALB is able to receive HTTP traffic.

### 2. Create Target Groups:
- Create and configure two target groups.
  - One should listen for the `/` path.
  - The other should listen for the `/users` path.
- Ensure health checks for each listener correspond to its own specific path.

### 3. Configure Auto Scaling Group:
- Create an auto scaling group launch template that runs a script to:
  - Install Apache.
  - Start Apache.
  - Enable Apache.
  - Create two files with the following metadata:
    - `index.html` should contain the AMI ID.
    - `users.html` should contain user data.

### 4. Configure Auto Scaling Group Policy:
- Create an ASG policy that tracks the utilization of the EC2 instance CPU to be 20%.

### 5. Bonus Task:
- Install the stress test utility from [this gist](https://gist.github.com/mikepfeiffer/d27f5c478bef92e8aff4241154b77e54).
- Run the stress test utility to trigger an auto scaling action due to high CPU usage.
- Take a screenshot of the activity notification trigger due to high CPU usage as the ASG adjusts group size.

## Repository Contents:

- **/scripts/**: Contains scripts for installing and configuring Apache on EC2 instances.
- **/templates/**: Includes the CloudFormation templates for creating the ALB, target groups, and auto scaling group.
- **/screenshots/**: Directory to store screenshots of the activity notification trigger due to high CPU usage.

## Getting Started:

1. **Clone the Repository:**
   ```sh
   git clone https://github.com/peaceissa/AWS-Load-Balancing-and-Auto-Scaling
   cd AWS-Load-Balancing-and-Auto-Scaling
   ```

2. **Set Up AWS Resources:**
   - Use the provided CloudFormation templates to set up the ALB, target groups, and auto scaling group.
   - Ensure the security groups and IAM roles are configured correctly.

3. **Configure Auto Scaling:**
   - Edit the launch template to include the script for installing and configuring Apache.
   - Set up the auto scaling policies based on CPU utilization.

4. **Run Stress Test:**
   - Install the stress test utility on one of your EC2 instances.
   - Run the utility to simulate high CPU load and observe the auto scaling behavior.

5. **Monitor and Document:**
   - Monitor the scaling actions in the AWS Management Console.
   - Take screenshots of the activity notification triggers.

## Conclusion:
By completing this lab, you will have a better understanding of deploying a highly available and scalable web application on AWS. You will learn how to distribute traffic using an ALB, configure auto scaling based on CPU utilization, and simulate load to observe scaling behavior.
