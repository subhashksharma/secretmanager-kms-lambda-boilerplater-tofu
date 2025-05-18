import unittest
import sys
sys.path.append('..')
from lambdas.example_lambda import lambda_function

class TestExampleLambda(unittest.TestCase):
    def test_lambda_handler(self):
        event = {}
        context = None
        result = lambda_function.lambda_handler(event, context)
        self.assertEqual(result['statusCode'], 200)
        self.assertIn('Hello', result['body'])

if __name__ == '__main__':
    unittest.main()
