from logging import getLogger
import pandas as pd
from scripts.j_net21_logic import JNet21Logic
from utility.csv_uploader import CsvUploader
from utility.slack import Slack

logger = getLogger(__name__)

class CurationController:
    def __init__(self, event_id: str=''):
        self.event_id = event_id
        self.slack = Slack()
        self.csv_uploader = CsvUploader('curation-site.csv')


    def execute(self):
        data = JNet21Logic().execute()
        df = pd.DataFrame(data)
        self.csv_uploader.upload_diff(df)
        self.csv_uploader.upload_all(df)


    def notify_start(self):
        self.slack.notify_start('キュレーションサイト', self.event_id)


    def notify_finish(self):
        self.slack.notify_finish('キュレーションサイト', self.event_id)


    def notify_error(self, error):
        self.slack.notify_error('キュレーションサイト', self.event_id, f'{error}')
