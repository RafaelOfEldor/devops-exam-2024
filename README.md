# PGR301 Exam 2024 - Devops in the clouds

## General Info
I use a lot of environmental variables and secrets in an attempt to enforce least privilege principle while keeping
sensitive info out of my code, though this might make it more difficult to navigate the names of my
created resources in aws. However, all answers contain links to the necessary resources regardless, so it shouldn't be too much
trouble

## Environmental Variables
**General:**

AWS_ACCESS_KEY_ID

AWS_ACCOUNT_ID - used mainly to enforce least privilege principal when creating policies and resources

AWS_SECRET_ACCESS_KEY

AWS_REGION

DOCKERHUB_USERNAME

DOCKER_ACCESS_TOKEN

ALARM_EMAIL

**Task 1 Specific**

TASK1_BUCKET_NAME - Bucket used in my lambda function task 1

TASK1_STACK_BUCKET_NAME - Bucket used by my cloudformation stack in task 1

TASK1_STACK_NAME - name of my cloudformation stack in task 1

**Task 2**

TASK2_BUCKET_NAME - Name of the bucket used by the lambda function in task 2

TASK2_PREFIX - prefix for task 2

# Task 1:

**Images will be saved to: s3://pgr301-couch-explorers/51/task1/\***

### A:


Lambda function HTTP endpoint: https://d5uk81vzjb.execute-api.eu-west-1.amazonaws.com/Prod/generate-image

### B:

Link to successfull workflow: https://github.com/RafaelOfEldor/devops-exam-2024/actions/runs/11811228474/job/32904471706

# Task 2:

**Images will be saved to: s3://pgr301-couch-explorers/51/task2/\***

### A:

Check code in "infra" folder

Link to sqs queue: https://sqs.eu-west-1.amazonaws.com/244530008913/candidate51-task2_image_generation_queue

### B:

Link to successfull non-main branch workflow: https://github.com/RafaelOfEldor/devops-exam-2024/actions/runs/11811421635/job/32904970358


Link to successfull main branch workflow: https://github.com/RafaelOfEldor/devops-exam-2024/actions/runs/11811400267/job/32904915062

# Task 3:

**Images will be saved to: s3://pgr301-couch-explorers/51/task2/\***

### A:

Check Dockerfile.

### B:

**Image Name:** buhhh/devops-exam-2024-task3-image:latest

**Image Tag Strategy:**

I have chosen to tag my images with a shortened git hash to ensure unique tags as well as be able to match a git commit with the corresponding image.
this creates a type of versioning, so that any commit on my github repository's main branch has an easy-to-find image for that code. Additionally, i tag
the image with "latest", so that everytime a new image is pushed it is marked as the latest version.

### Note
The task asks for some steps to be included:

***Inkluder steg for å sjekke ut koden, logge inn på Docker Hub (ved hjelp av credentials lagret i GitHub Secrets), bygge Docker-imaget, tagge det, og deretter pushe det til Docker Hub-kontoen din.***

However, i was unsure if it was mandatory to have each functionality as a separate "step" or not. I chose to use the "docker/build-push-action@v5" to handle building, tagging and pushing within one step. I chose this because the code looks cleaner and executes the same functionality as intended.

I feel confident that i could do building, tagging and pushing in separate steps as well if that's what i was supposed to do. Just wanted to comment on this.

# Task 4:
### A:
Check code in "/infra/alarm_module/*" as well as the file "/infra/alarm.tf".

**Name of my alarm:** candidate51-img-gen-app-ApproximateAgeOfOldestMessageAlarm

The task didn't specify how this alarm would be tested by sensur, but the module is configured to listen on the queue from task 3/2, and it accepts an "alarm_email" variable as asked. I have purposefully left some hard-coded default values except mail so that it is easier to checkout the relevant metrics in AWS.

# Task 5:

### 1. Automation and Continuous Delivery (CI/CD)

**For microservices:**

* Microservices architecture typically involves larger services, each potentially built with its own CI/CD pipeline. Changes to individual microservices require separate testing and deployment, which may introduce more complexity to the CI/CD pipeline but also provide more control.

* Automation here is often focused on service deployment, orchestration (e.g., with Kubernetes), and versioning, as each microservice has a defined lifecycle and state.

**For Serverless(FaaS):**

* Serverless architectures, such as AWS Lambda, break down monolithic services into small, granular functions. With Lambda, CI/CD pipelines may need to handle deployment of numerous discrete functions.

* Deployment of serverless functions can be highly automated, leveraging Infrastructure as Code tools (e.g., AWS SAM, Serverless Framework) for rapid deployment. However, maintaining version control across many small functions adds complexity to the automation process.

* While serverless is well-suited for continuous deployment and experimentation, it requires thoughtful design to avoid “function sprawl,” where managing hundreds or thousands of functions becomes challenging.

### 2. Observability

**For microservices:**

* Monitoring and logging in a microservices environment typically focus on individual services. Observability tools (e.g., Prometheus, Grafana) monitor service health, request latency, and error rates across containers.

* Debugging is often straightforward since services are persistent and maintain their state over time, allowing direct access to logs and metrics.

**For Serverless(FaaS):**

* Observability in serverless architectures introduces new challenges, as functions are stateless and short-lived, making it difficult to trace transactions across functions. Standard tools may lack sufficient granularity for tracking asynchronous workflows in serverless environments.

* AWS provides CloudWatch for monitoring Lambda, but distributed tracing across multiple Lambda functions can be complex. Tools like AWS X-Ray or third-party solutions are often necessary for full observability.

* Logging and debugging in serverless environments may be less intuitive, as functions can scale rapidly, generating large volumes of logs that must be aggregated and processed effectively.

### 3. Scalability and Cost Control

**For microservices:**

* Microservices can scale horizontally based on container orchestration platforms like Kubernetes or ECS, which allow individual services to scale independently according to demand.

* Costs in microservices architectures are more predictable, typically involving the cost of running compute resources for specific services. This predictability allows teams to optimize based on average workloads.

* However, scaling decisions require active resource management and tuning, potentially leading to underutilized or overprovisioned resources.

**For Serverless(FaaS):**

* Serverless architectures provide inherent scalability, as Lambda functions automatically scale with the number of incoming requests without manual intervention.

* Since AWS Lambda is billed per invocation and based on execution time, serverless can be highly cost-effective for workloads with intermittent demand but may become expensive for high-throughput applications.

* Fine-grained cost control is possible by optimizing individual functions. However, monitoring the cost of many small functions can be challenging and requires diligent optimization to avoid unexpected costs.

### 4. Ownership and Responsibility

**For microservices:**

* In a microservices architecture, DevOps teams generally maintain full ownership of each service's reliability, availability, and performance. This gives teams control over the infrastructure, deployment, and tuning, while also placing responsibility on them for failures and maintenance.

* DevOps is responsible for scaling, cost management, and infrastructure security, often with explicit access to underlying resources.

**For Serverless(FaaS):**

* Serverless shifts much of the responsibility for infrastructure management, scaling, and patching to the cloud provider, which allows DevOps teams to focus on code and business logic rather than infrastructure.

* The trade-off is that DevOps teams have limited control over the environment, which can restrict optimization and customization, and require adapting to cloud provider limitations and updates.

* Performance management may become abstracted, making it harder to tune or debug specific issues at the infrastructure level, leading to a shared responsibility model where some aspects fall to the cloud provider.

### Summary: Strengths and Weaknesses of Each Approach

Microservices offer more control and flexibility, making them better suited for systems with complex, persistent components where ownership and direct management of the infrastructure are critical.

Serverless (FaaS) is ideal for applications that require rapid scaling, cost efficiency, and reduced infrastructure management overhead, though it can introduce complexity in CI/CD, observability, and cost predictability across many functions.


# Task Delivery Table:

## Task 1 

[x] **HTTP Endepunkt for Lambdafunksjonen som sensor kan teste med Postman**

[x] **Lenke til kjørt GitHub Actions workflow**

## Task 2 

[x] **Lenke til kjørt GitHub Actions workflow**

[x] **Lenke til en fungerende GitHub Actions workflow (ikke main)**

[x] **SQS-Kø URL**

## Task 2 

[x] **Beskrivelse av taggestrategi**

[x] **Container image + SQS URL**

