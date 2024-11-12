# Task 1:
## A:
### Start the program locally in one of these two ways:

for local start, go into the "sam_lambda" folder and create a "env.json" file with this format:

```
{
  "imgGenFunction": {
    "BUCKET_NAME": "your-bucket-name"
  }
}

```
then run

```
sam local start-api --env-vars env.json
```

or do pass the environmental variable directly through cli like this:

```
sam local start-api --parameter-overrides "ParameterKey=BucketName,ParameterValue=your-bucket-name"
```

and replace "your-bucket-name" with your actual bucket name.

##For deployment with environmental variable, simply enter:

```
sam deploy --no-confirm-changeset --no-fail-on-empty-changeset --parameter-overrides BucketName="pgr301-couch-explorers" --stack-name candidate51-task1-stack --s3-bucket candidate51-task1-bucket --capabilities CAPABILITY_IAM --region eu-west-1
```

And make sure to enter your selected bucket name.

## B:

(insert link here after successfull workflow)