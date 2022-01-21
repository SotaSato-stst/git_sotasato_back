from logging import getLogger
import datetime
import pandas as pd
from pandas.core.frame import DataFrame
from scripts.shinchaku_logic import ShinchakuLogic
from scripts.j_net21_logic import JNet21Logic
from utility.storage import Storage
from utility.slack import Slack

logger = getLogger(__name__)

class Controller:
    keywords = ['補助金', '助成金' ,'支援策', '給付金','支援金']
    all_csv = 'all.csv'

    def __init__(self, csv_filename: str='urls-0.csv', event_id: str=""):
        self.csv_filename = csv_filename
        self.event_id = event_id
        self.storage = Storage()
        self.slack = Slack()
        t_delta = datetime.timedelta(hours=9)
        JST = datetime.timezone(t_delta, 'JST')
        self.execute_date = datetime.datetime.now(JST)


    def execute(self):
        logger.info(f'Scraping Started with URLs in {self.csv_filename}')
        data = []

        # J-Net 21サイト
        results = JNet21Logic().execute()
        data.extend(results)

        # 地方自治体サイト
        csv = pd.read_csv(f'master_data/{self.csv_filename}')
        for _, row in csv.iterrows():
            selector_name = row['selector_name']
            url = row['url']

            results = ShinchakuLogic.execute(url, self.keywords, selector_name)
            data.extend(results)

            # TODO: URLのselector_nameの修正を完了してからエラー通知を復活させる
            # try:
            #     results = ShinchakuLogic.execute(url, self.keywords, selector_name)
            #     data.extend(results)
            # except Exception as e:
            #     self.slack.notify_warning(f'{e}')

        if len(data) > 0:
            current_df = pd.DataFrame(data)
            uploaded_df = pd.read_csv(self.storage.download(self.all_csv))
            self.upload_diff(uploaded_df, current_df)
            self.upload_all(uploaded_df, current_df)
        else:
            logger.info(f'No results {self.csv_filename}')


    def upload_diff(self, uploaded_df: DataFrame, current_df: DataFrame):
        uploaded_urls = uploaded_df['url'].to_numpy()
        current_urls = current_df['url'].to_numpy()
        new_urls = [url for url in current_urls if url not in uploaded_urls]
        new_df = current_df[current_df['url'].isin(new_urls)]
        date_path = f'{self.execute_date.year}/{self.execute_date.month}/{self.execute_date.day}'
        self.storage.upload_after_delete(f'daily/{date_path}/{self.csv_filename}', new_df.to_csv(index=False))
        for _, row in new_df.iterrows():
            self.slack.notify_new_content(row['text'], row['url'])


    def upload_all(self, uploaded_df: DataFrame, current_df: DataFrame):
        uploaded_df = uploaded_df.append(current_df, ignore_index=True, sort=False)
        uploaded_df.drop_duplicates(subset='url', inplace=True)
        self.storage.upload_after_delete(self.all_csv, uploaded_df.to_csv(index=False))


    def notify_start(self):
        self.slack.notify_start(self.csv_filename, self.event_id)


    def notify_finish(self):
        self.slack.notify_finish(self.csv_filename, self.event_id)


    def notify_error(self, error):
        self.slack.notify_error(self.csv_filename, self.event_id, f'{error}')
