from logging import getLogger
from io import StringIO
import os
from google.cloud import storage

logger = getLogger(__name__)

class Storage:
    def __init__(self):
        if os.getenv('RUNNING_ENV', 'development') == 'production':
            client = storage.Client()
            self.bucket = client.bucket('scraping-subsidy-new')
        else:
            client = storage.Client.from_service_account_json('gcloud-account.json')
            self.bucket = client.bucket('scraping-subsidy-new-test')

    def upload(self, file_name_with_path: str, data: str):
        blob = self.bucket.blob(file_name_with_path)
        logger.info(f'Uploading {file_name_with_path}')
        blob.upload_from_string(data)

    def download(self, file_name_with_path: str) -> StringIO:
        blob = self.bucket.blob(file_name_with_path)
        logger.info(f'Downloading {file_name_with_path}')
        return StringIO(blob.download_as_text())
