import base64
import boto3
import json
import random
import os

# Set up the AWS clients

bedrock_client = boto3.client("bedrock-runtime", region_name="us-east-1")
s3_client = boto3.client("s3", region_name="us-west-1")

# Define the model ID and S3 bucket name (replace with your actual bucket name)
model_id = "amazon.titan-image-generator-v1"
BUCKET_NAME = os.environ["BUCKET_NAME"]

def lambda_handler(event, context):

    # Frank; Important; Change this prompt to something else before the presentation with the investors!
    try:
        prompt_key = list(event.keys())[0]
        prompt = event[prompt_key]
    except (IndexError, KeyError):
        return {
            'statusCode': 400,
            'body': json.dumps({
                'error': 'Prompt data is missing or invalid.'
            })
        }
    seed = random.randint(0, 2147483647)
    s3_image_path = f"51/task1/titan_{seed}.png"

    native_request = {
        "taskType": "TEXT_IMAGE",
        "textToImageParams": {"text": prompt},
        "imageGenerationConfig": {
            "numberOfImages": 1,
            "quality": "standard",
            "cfgScale": 8.0,
            "height": 1024,
            "width": 1024,
            "seed": seed,
        }
    }
    
    try:
        print(f"Extracted prompt: {prompt}")
        response = bedrock_client.invoke_model(modelId=model_id, body=json.dumps(native_request))
        model_response = json.loads(response["body"].read())

        # Extract and decode the Base64 image data
        base64_image_data = model_response["images"][0]
        image_data = base64.b64decode(base64_image_data)

        # Upload the decoded image data to S3
        s3_client.put_object(Bucket=BUCKET_NAME, Key=s3_image_path, Body=image_data)
        return {
            'statusCode': 200,
            'body': json.dumps({
                'message': 'Image generated and uploaded successfully.',
                'image_url': f"s3://{BUCKET_NAME}/{s3_image_path}"
            })
        }
    except Exception as e:
        # Handle errors and return an error response
        return {
            'statusCode': 500,
            'body': json.dumps({
                'error': str(e)
            })
        }