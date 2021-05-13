# Auto Scaling

![SCHEME](./diagram.png)

### Table of Contents

- [Application Load Balancer using AWS](#application-load-balancer-using-aws)
- [Auto Scaling Group using AWS](#auto-scaling-group-using-aws)
- [Application Load Balancer using Terraform]
- [Auto Scaling Group using Terraform]

## Application Load Balancer using AWS

1. Create 3 subnets (public) in the same VPC.
2. Launch on instance with app running in one of the subnets.
3. Go to section `Load Balancer` inside `EC2`.
4. Click on `Create Load Balancer`.
5. Select `Application Load Balancer`.
6. Tag a name: `eng84-jose-alb`.
7. Select `internet-facing` and `ipv4`.
8. Listener: make sure you have http with port `80` to request in the app.
9. Availability zones: select the VPC that we have created and then tick on the three subnets to have highly available.
10. Go to next step: `Security Groups`.
11. Create a new security group and make sure you have the next rule: Custom TCP, TCP, 80, Custom: 0.0.0.0/0, ::/0
12. Go to next step: `Configure routing`.
13. Target group: `new target group`.
14. Name: `jose-app-targe-group`.
15. Target type: `Instance`
16. Protocol `HTTP` and Port `80`.
17. Go to next step: `Register Targets`.
18. In the `instances`, select the instance that is running with the app working and click on `Add to registered`. You will see your instance available in the registered targets.
19. Next step: `Review` and `Create`.
20. Go to the new balancer, and in the tab `Description`, copy the `DNS name` and paste it in the browser. Now you will see your application running using the DNS name or using the public ip of the app.

## Auto Scaling Group using AWS

## Application Load Balancer using Terraform

## Auto Scaling Group using Terraform
