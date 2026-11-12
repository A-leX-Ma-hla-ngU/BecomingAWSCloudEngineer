import unittest

from app import health_payload


class HealthPayloadTests(unittest.TestCase):
    def test_health_payload_reports_healthy_status(self):
        result = health_payload()
        self.assertEqual(result["status"], "healthy")

    def test_health_payload_has_expected_service_name(self):
        result = health_payload()
        self.assertEqual(result["service"], "python-cicd-demo")


if __name__ == "__main__":
    unittest.main()
