from logging import getLogger
import pandas as pd
from scripts.shinchaku_logic import ShinchakuLogic
from utility.csv_uploader import CsvUploader
from utility.slack import Slack

logger = getLogger(__name__)

# 解説:
# 雑多な新着情報の一覧から、補助金の情報だけを抜き出すController
# 主に地方自治体サイトのお知らせ欄をスクレイピングしている

class SelectorController:
    keywords = ['補助金', '助成金' ,'支援策', '給付金','支援金']

    def __init__(self, csv_filename: str='urls-0.csv', event_id: str=""):
        self.csv_filename = csv_filename
        self.event_id = event_id
        self.slack = Slack()
        self.csv_uploader = CsvUploader(csv_filename)


    def execute(self):
        logger.info(f'Scraping Started with URLs in {self.csv_filename}')

        data = []
        csv = pd.read_csv(f'master_data/{self.csv_filename}')

        for _, row in csv.iterrows():
            selector_name = row['selector_name']
            url = row['url']

            try:
                results = ShinchakuLogic.execute(url, self.keywords, selector_name)
                data.extend(results)
            except Exception as e:
                logger.info(e)
                # TODO: selector_name修正後に通知復活
                # self.slack.notify_warning(f'{e}')

        if len(data) > 0:
            current_df = pd.DataFrame(data)
            self.csv_uploader.upload_diff(current_df)
            self.csv_uploader.upload_all(current_df)
        else:
            logger.info(f'No results {self.csv_filename}')


    def notify_start(self):
        self.slack.notify_start(self.csv_filename, self.event_id)


    def notify_finish(self):
        self.slack.notify_finish(self.csv_filename, self.event_id)


    def notify_error(self, error):
        self.slack.notify_error(self.csv_filename, self.event_id, f'{error}')
