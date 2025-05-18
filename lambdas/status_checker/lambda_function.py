import os
import boto3
from botocore.exceptions import ClientError

def handler(event, context):
    """Sample Lambda function"""

    print("Event:", "successfully entered lambda function")
    secret_arn = os.environ.get('SECRET_ARN')
    if not secret_arn:
        print('Secret ARN not set')
        return {'statusCode': 500, 'body': 'Secret ARN not set'}

    # Try to access Secrets Manager
    try:
        secrets_client = boto3.client('secretsmanager')
        print("Attempting to access Secrets Manager...")
        secret_value = secrets_client.get_secret_value(SecretId=secret_arn)
        secret = secret_value.get('SecretString')
        print(f"Secrets Manager access successful. Secret value: {secret}")
    except ClientError as e:
        print(f"Secrets Manager access error: {str(e)}")
        return {'statusCode': 403, 'body': f'Secret access error: {str(e)}'}
    except Exception as e:
        print(f"General error accessing Secrets Manager: {str(e)}")
        return {'statusCode': 500, 'body': f'General error accessing Secrets Manager: {str(e)}'}

    # Try to access KMS (list keys as a simple test)
    try:
        kms_client = boto3.client('kms')
        print("Attempting to access KMS...")
        keys = kms_client.list_keys(Limit=1)
        print(f"KMS access successful. Keys: {keys['Keys']}")
    except ClientError as e:
        print(f"KMS access error: {str(e)}")
        return {'statusCode': 403, 'body': f'KMS access error: {str(e)}'}
    except Exception as e:
        print(f"General error accessing KMS: {str(e)}")
        return {'statusCode': 500, 'body': f'General error accessing KMS: {str(e)}'}

    print('Successfully accessed KMS and Secrets Manager.')
    return {'statusCode': 200, 'body': 'Successfully accessed KMS and Secrets Manager.'}

#handler({}, None)