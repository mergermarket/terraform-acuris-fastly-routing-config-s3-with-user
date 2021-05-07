import unittest
import os
import json

FIXTURES_DIR = os.path.join(os.path.dirname(__file__), 'infra')


def assert_resource_changes_action(resource_changes, action, length):
    resource_changes_create = [
        value for _, value in resource_changes.items()
        if value.get('change').get('actions') == [action]
    ]
    assert len(resource_changes_create) == length

def assert_resource_changes(testname, resource_changes):
    with open(f'test/files/{testname}.json', 'r') as f:
        data = json.load(f)
        i = 0
        for _, value in resource_changes.items():
            assert sorted(data.get('resource_changes')[i]) == sorted(value)
            i=+1


def test_resources(plan_runner):
    os.environ.update({'FASTLY_API_KEY': 'querty'})
    plan, modules = plan_runner(
        FIXTURES_DIR,
        defaults_vcl_recv_condition="test-cond",
        defaults_backend_name="test-backend",
        defaults_s3_bucket_name="test-bucket",
        defaults_user_name="test-bucket")

    assert len(modules) == 9
    assert_resource_changes_action(plan.resource_changes,'create', 7)
    assert_resource_changes('default', plan.resource_changes)