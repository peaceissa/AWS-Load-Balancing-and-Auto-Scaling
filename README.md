<!-- Improved compatibility of back to top link: See: https://github.com/othneildrew/Best-README-Template/pull/73 -->
<a name="readme-top"></a>
<!-- ABOUT THE PROJECT -->
## Building A Highly Scalable Web App On AWS: A Step-By-Step Guide 

There are many great README templates available on GitHub; We will use this to document everything that we did in this project. some other resources are: [joshseven](https://github.com/joshseven/Cloud-portfolio), 



### Project Overview
   Todo and technologies
* Setting up an Application Load Balancer (ALB) to distribute traffic across multiple servers. 

* Configuring Auto Scaling to automatically add or remove servers based on traffic. 

* Using the AWS Stress Test Utility to simulate heavy traffic and see how your app scales. 

### STEP 1: Building a Traffic Director, The Application Load Balancer (ALB) 

Think of the ALB as a smart traffic cop. It directs incoming traffic to the most appropriate server in your web application. 

**3.1. Creating Target Groups:**  

We will create the Target groups first. Target groups are like teams of servers that the ALB can send traffic to. We'll create two: 
First Target Group: This group will handle requests for the root path (/). Name it something descriptive like "Root-path-Tg." 
Head to the EC2 Dashboard on the left panel navigation menu. 
Under "Load Balancing," select "Target group" and click "Create Target Group." 
Choose "instances" as target type and give it a memorable name (e.g., "Root-path-Tg"). 
Make sure "HTTP" is selected for the protocol 80 for port and IPv4 for IP address type. 
Select your vpc and leave the other settings with their default values. 
Click on next and then create target group 
Second Target Group: This group will handle requests specifically for the /users’ path. Name it "users-path-Tg." 
Repeat the steps above but use a different name (users-path-Tg) and 81 for the port 
Once the Target group is created it should resemble the one in the picture below. 

<p align="right">(<a href="#readme-top">back to top</a>)</p>

**Creating the application Load Balancer**

Head to the EC2 Dashboard. 
Under "Load Balancing," select "Load Balancers" and click "Create Load Balancer." 
Choose "Application Load Balancer" and give it a memorable name (e.g., "Test-ALB"). 
Make sure "Internet-facing" is selected for the scheme and IPv4 Load balancer IP address type. 
Select your VPC and choose at least two Availability Zones for high availability (think of them as data centers in different locations). 
Select the security group (Test-ALB-SG) created earlier in STEP 2. 
Select the root-path-Tg to add the root-path target group to the listeners and routing tab. Click on Add listener to add users-path-Tg to the Listeners on your ALB. 
Leave the other configurations as default and click create load balancer 
Once the load balancer is created, it should resemble the one below with two listeners using HTTP protocol, one running on port 80 and the other on port 81. 
<p align="right">(<a href="#readme-top">back to top</a>)</p>

 **Setting Up the Rules: Who Gets What Traffic?** 

Now, we need to tell the ALB which target group to send traffic to based on the URL path. Here's how: 

We'll create two rules:  
If the path is /, forward traffic to the "Root-path-Tg" group. 

1.Go to the "Listeners and rules" tab for your ALB and click "HTTP:80" for the HTTP listener. 
2.Then click on add rule, assign name and click next 
Click on add condition, choose path and define it as / for root then click on confirm. 
4. Select Forward to target groups as the action type and the Test-root-Tg as the target group then click next. 
 Set the rule priority level as 4 and click next. 
Review and click on create. 
If the path is /users, forward traffic to the "users-path-Tg" group 
Repeat the above steps but ensure that the path is set to /users and the rule priority level is set to 2. 
<p align="right">(<a href="#readme-top">back to top</a>)</p>

**4. Introducing Auto Scaling: The Muscle Behind the Magic** 

Auto Scaling ensures your web application has enough resources to handle traffic spikes. Here's how to set it up: 

## Create a Launch Template:  

This is a blueprint for your web servers. Configure it with the appropriate AMI (operating system image), instance type, and user data script (a script that installs and configures your web server software). 
In the left-hand navigation pane, click on "Launch Templates" under the "Instances" section. 
Click the "Create launch template" button. 
Enter a name for your launch template (e.g., MyLaunchTemplate). Provide a brief description (optional). 
<p align="right">(<a href="#readme-top">back to top</a>)</p>

 # Configure Instance Details 

Select an Amazon Machine Image (AMI) for your instances. You can search for a specific AMI or select one from the list. 
Choose the instance type that suits your needs (e.g., t2. Micro to avoid charges as it is free tier eligible). 
Select an existing key pair or create a new one to connect to your instances. 
Choose the VPC (Test-vpc-01) where you want to launch your instances and select the two subnets, we created earlier within our VPC. 
Click on advanced network configuration, add network interface then Enable auto assign public address this option to allow ec2 access through the internet 
Choose one or more security groups (Test-public-instances-SG) to associate with the instances. 
Configure the root volume and any additional EBS volumes. You can modify the size, type, and other settings. 
Add tags to your instances for better management and identification.
<p align="right">(<a href="#readme-top">back to top</a>)</p>

**Advanced Details** 
User data: 
Add user data to run commands or scripts at the instance launch. For our case, a script to: 
install apache​ 
start apache​ 
enable apache​ 
create two files with the following metadata: 
index.html should contain the ami-id 
users.html should contain user data 

#!/bin/bash 
# Update and upgrade system 
yes | sudo apt update  
yes | sudo apt upgrade  
# Install Apache 
yes | sudo apt install httpd 
sudo systemctl enable httpd 
sudo systemctl start httpd 
yes | sudo apt install apache2  
sudo systemctl enable apache2 
sudo systemctl start apache2 
yes | sudo apt install curl 
# Get the AMI ID and write it to index.html 
AMI_ID=$(wget -q -O - http://169.254.169.254/latest/meta-data/ami-id || die \"wget ami-id has failed: $?\") 
echo "<html><body><h1>AMI ID: ${AMI_ID}</h1></body></html>" > /var/www/html/index.html 
# Get the user data and write it to users.html 
USER_DATA=$(curl -s http://169.254.169.254/latest/user-data) 
echo "<html><body><pre>${USER_DATA}</pre></body></html>" > /var/www/html/users.html 
# Restart Apache to ensure changes are applied 
sudo systemctl restart apache2 
Add the above script to the user data field and enable meta data access. 
Review all the configurations, then click the "Create launch template" button to create the template. 
<p align="right">(<a href="#readme-top">back to top</a>)</p>
### Create an Auto Scaling Group:  

This group will manage the creation and deletion of your web servers based on defined rules. Configure it with the launch template, VPC (virtual private cloud), target groups (we want both!), and a scaling policy that automatically adds servers when CPU utilization gets high (e.g., above 20%). 

In the AWS Management Console, navigate to EC2 under the "Compute" section. 
In the EC2 Dashboard, click on Auto Scaling Groups under the "Auto Scaling" section in the left-hand menu. 
Click on the Create Auto Scaling group button. 
Choose launch template or configuration: 
Enter a name for your Auto Scaling group. 
Select the Launch template option and choose the launch template you created previously from the drop-down menu. 
Select the version of the launch template (use the default version or the latest one), then click Next. 
VPC: Choose the VPC where you want to launch the instances. 
Subnets: Select the two public subnets in your VPC(Test-vpc-01). Instances will be launched in these subnets. 
 
We need to configure load balancing, select attach to an existing load balancer, select choose from your load balancer Target groups and select the two target groups created earlier. Leave the other configurations as default and click next. 
Desired capacity: Enter the number of instances you want to start with. (1) 

Minimum capacity: Enter the minimum number of instances. (1) 

Maximum capacity: Enter the maximum number of instances.  (3) 

Choose how you want to scale your instances (e.g., target tracking, step scaling, or simple scaling). 
For Target tracking scaling policy, click on Add policy and configure the policy: 
Scaling policy type: Select Target tracking scaling policy. 

Metric type: Select a metric, such as Average CPU utilization. 
Target value: Set a target value, such as 20%. 
Configure other options as required. 

Configure notifications: You can configure notifications for different events like instance launch, termination, etc. This step is optional. 
Add tags: Optionally, add tags to your Auto Scaling Group. Tags help in identifying and managing resources. 
Review: Review all the configurations you have made. 
Click on the Create Auto Scaling group button to create the group. 
<p align="right">(<a href="#readme-top">back to top</a>)</p>
 **5. Simulating the Stress Test: Can Your App Handle It?** 

Now, let's see how your web application scales under pressure! 
Connect to one of your EC2 instances using the public IPv4 address to check the AMI id and user data. 
Add users.html to the url to access the user data page 
 Connect to one of your EC2 instances using SSH or Ec2 instance connect. 
Install the AWS Stress Test Utility to simulate high CPU usage. 
Run the stress test for a few minutes and observe your auto scaling activity. 
Head back to the Auto Scaling Group in the EC2 Dashboard. You should see the scaling policy kicking in and adding new servers to handle the increased load. Pretty neat, huh? 

6. **Conclusion: You've Built a Scalable Web App!** 

Congratulations! You've successfully deployed a highly available and scalable web application architecture on AWS. 


### Installation

_Below is an example of how you can instruct your audience on installing and setting up your app. This template doesn't rely on any external dependencies or services._

1. Clone the repo
   ```sh
   git clone https://github.com/peaceissa/AWS-Load-Balancing-and-Auto-Scaling
   ```

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- CONTACT -->
## Contact

<p>Twitter - @freecarseyehttps://twitter.com/peaceissa</p>
<p>Email - peaceissa695@gmail.com</p>
<p>Linkedin - https://www.linkedin.com/in/peace-issa/</p>
<p>Project Link: https://github.com/peaceissa/AWS-Load-Balancing-and-Auto-Scaling</p>

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- References -->
## References

Use this space to list resources you find helpful and would like to give credit to. I've included a few of my favorites to kick things off!

* AWS Documetation
* YouTube
* Google search

<p align="right">(<a href="#readme-top">back to top</a>)</p>