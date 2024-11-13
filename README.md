# TODO

Enforce least privilege principal for effect, action, resources and whatnot.

for variables like bucket name, account id and such, potentially rely on manual filling when using locally, and github secrets in github
actions. AKA never hardcode ANYTHING sensitive ANYWHERE, and no default values.

use me to make changes so that you can push: s

## General Info
I use a lot of environmental variables in an attempt to enforce least privilege principle while keeping
sensitive info out of my code, though this might make it more difficult to navigate the names of my
created resources in aws. However, all answers contain links to the necessary resources regardless, so it shouldn't be too much
trouble

## Environmental Variables
**General:**
AWS_ACCESS_KEY_ID
AWS_ACCOUNT_ID - used mainly to enforce least privilege principal when creating policies and resources
AWS_SECRET_ACCESS_KEY
AWS_REGION

**Task1**
TASK1_BUCKET_NAME - Bucket used in my lambda function task 1
TASK1_STACK_BUCKET_NAME - Bucket used by my cloudformation stack in task 1
TASK1_STACK_NAME - name of my cloudformation stack in task 1

**Task 2**
TASK2_BUCKET_NAME - Name of the bucket used by the lambda function in task 2
TASK2_PREFIX - prefix for task 2

# Task 1:
## A:

**Images will be saved to: s3://pgr301-couch-explorers/51/task1/\***

Lambda function HTTP endpoint: https://d5uk81vzjb.execute-api.eu-west-1.amazonaws.com/Prod/generate-image

## B:

Link to successfull workflow: https://github.com/RafaelOfEldor/devops-exam-2024/actions/runs/11797264526

# Task 2:

**Images will be saved to: s3://pgr301-couch-explorers/51/task2/\***

Link to sqs queue: https://sqs.eu-west-1.amazonaws.com/244530008913/candidate51-task2_image_generation_queue