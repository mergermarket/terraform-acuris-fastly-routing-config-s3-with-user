import unittest
from subprocess import check_call, check_output


class TestConfigGeneration(unittest.TestCase):

    def setUp(self):
        check_call(['terraform', 'init', 'test/infra'])
        check_call(['terraform', 'get', 'test/infra'])

    def test_vcl_recv(self):
        # Given When
        output = check_output([
            'terraform', 'plan',
            '-var', 'defaults_vcl_recv_condition=test-cond',
            '-var', 'defaults_backend_name=test-backend',
            '-var', 'defaults_s3_bucket_name=test-bucket',
            '-var', 'defaults_user_name=test-bucket',
            'test/infra'
        ]).decode('utf-8')

        # Then
        # TODO Fix me! Add assertions
