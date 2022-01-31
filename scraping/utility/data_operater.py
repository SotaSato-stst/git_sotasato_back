from logging import getLogger
import pandas as pd
from pandas.core.frame import DataFrame
from utility.slack import Slack

logger = getLogger(__name__)

class DataOperater:
    def __init__(self, base_csv):
        self.uploaded_df = pd.read_csv(base_csv)
        self.slack = Slack() # TODO: 新着通知はrailsに移行する

    def filter_new_records(self, df: DataFrame) -> DataFrame:
        uploaded_urls = self.uploaded_df['url'].to_numpy()
        current_urls = df['url'].to_numpy()

        # 未取得の新着情報のみを選別
        new_urls = [url for url in current_urls if url not in uploaded_urls]

        new_df = df[df['url'].isin(new_urls)]
        for _, row in new_df.iterrows():
            self.slack.notify_new_content(row['text'], row['url'])

        return new_df


    def merge_to_all(self, df: DataFrame) -> DataFrame:
        uploaded_df = self.uploaded_df.append(df, ignore_index=True, sort=False)

        # 重複排除
        uploaded_df.drop_duplicates(subset='url', inplace=True)

        return uploaded_df