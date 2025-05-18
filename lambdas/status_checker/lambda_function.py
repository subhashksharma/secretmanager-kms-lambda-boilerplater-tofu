import os
import boto3
from botocore.exceptions import ClientError
import socket

def handler(event, context):
    """Sample Lambda function"""

    print("Event:", "successfully entered lambda function")

    secret_arn = os.environ.get('SECRET_ARN')
    print("secret_arn:", secret_arn)
    if not secret_arn:
        print('Secret ARN not set')
        return {'statusCode': 500, 'body': 'Secret ARN not set'}

    # Log DNS resolution for Secrets Manager endpoint
    try:
        secretsmanager_endpoint = f'secretsmanager.{os.environ.get("AWS_REGION", "us-east-1")}.amazonaws.com'
        print(f"Resolving DNS for: {secretsmanager_endpoint}")
        ip = socket.gethostbyname(secretsmanager_endpoint)
        print(f"Resolved IP: {ip}")
        addrinfo = socket.getaddrinfo(secretsmanager_endpoint, 443)
        print(f"All resolved addresses: {addrinfo}")
    except Exception as e:
        print(f"DNS resolution error for Secrets Manager endpoint: {str(e)}")

    # Try to access Secrets Manager
    try:
        secrets_client = boto3.client('secretsmanager')
        print("Attempting to access Secrets Manager...")
        secret_value = secrets_client.get_secret_value(SecretId=secret_arn)
        secret = secret_value.get('SecretString')
        print(f"Secrets Manager access successful. Secret value: {secret}")
    except ClientError as e:
        print(f"Secrets Manager access error: {str(e)}")
        if hasattr(e, 'response'):
            print(f"Error code: {e.response['Error'].get('Code')}")
            print(f"Error message: {e.response['Error'].get('Message')}")
            print(f"Full error response: {e.response}")
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