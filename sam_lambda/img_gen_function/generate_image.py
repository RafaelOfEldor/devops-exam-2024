import base64
import boto3
import json
import random
import os

bedrock_client = boto3.client("bedrock-runtime", region_name="us-east-1")
s3_client = boto3.client("s3", region_name="us-west-1")

model_id = "amazon.titan-image-generator-v1"
BUCKET_NAME = os.environ["BUCKET_NAME"]

def lambda_handler(event, context):

    # Frank; Important; Change this prompt to something else before the presentation with the investors!
    try:
        body = json.loads(event["body"]) 
        if not isinstance(body, dict):
            raise ValueError("Body must be a JSON object with key-value pairs representing prompts.")
    except (json.JSONDecodeError, ValueError) as e:
        return {
            'statusCode': 400,
            'body': json.dumps({
                'error': 'Request body must be a valid JSON object.',
                'details': str(e)
            })
        }
    results = []

    for prompt_key, prompt in body.items():
        try:

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

            # Invoke the model
            response = bedrock_client.invoke_model(modelId=model_id, body=json.dumps(native_request))
            model_response = json.loads(response["body"].read())

            base64_image_data = model_response["images"][0]
            image_data = base64.b64decode(base64_image_data)

             # Upload the image to S3
            s3_client.put_object(Bucket=BUCKET_NAME, Key=s3_image_path, Body=image_data)
            results.append({
                'prompt_key': prompt_key,
                'prompt': prompt,
                'image_url': f"s3://{BUCKET_NAME}/{s3_image_path}"
            })
        except Exception as e:
            results.append({
                'prompt_key': prompt_key,
                'prompt': prompt,
                'error': str(e)
            })

    return {
    'statusCode': 200,
    'body': json.dumps({
        'results': results
    })
}