from logging import getLogger
import os
from google.cloud import storage
from google.api_core.exceptions import NotFound

logger = getLogger(__name__)

# !!!!!!! 公開ストレージ !!!!!!!!
# !!!!!!! ! 使用注意 !  !!!!!!!!
class PublicStorage:
    public_url = 'https://storage.googleapis.com/hojokin-dock-public'

    def __init__(self):
        if os.getenv('RUNNING_ENV') == 'production':
            client = storage.Client()
        else:
            client = storage.Client.from_service_account_json('gcloud-account.json')
        self.bucket = client.bucket('hojokin-dock-public')


    def upload_after_delete(self, file_name_with_path: str, data: str) -> str:
        blob = self.bucket.blob(file_name_with_path)
        logger.info(f'Uploading {file_name_with_path}')

        try:
            blob.delete()
        except NotFound:
            pass
        blob.upload_from_string(data)
        return self.public_url + file_name_with_path
