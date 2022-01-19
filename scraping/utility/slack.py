from logging import getLogger
from slack_sdk import WebClient, errors
import os
import json

logger = getLogger(__name__)

class Slack:
    def __init__(self):
        self.client = WebClient(token=os.environ.get('SLACK_TOKEN'))


    def notify_start(self, filename: str, context_id: str):
        blocks = self.info_blocks(
            'スクレイピングが開始されました',
            filename,
            context_id
        )
        self.post('scraping-logs', blocks, '#0b5cad', 'clock1')


    def notify_finish(self, filename: str, context_id: str):
        blocks = self.info_blocks(
            'スクレイピングが正常終了しました',
            filename,
            context_id
        )
        self.post('scraping-logs', blocks, '#108548', 'white_check_mark')


    def notify_error(self, filename: str, context_id: str, error):
        blocks = self.error_blocks(
            filename,
            context_id,
            error
        )
        self.post('scraping-error-logs', blocks, '#dd2b0e', 'bug')


    def notify_warning(self, message: str):
        blocks = self.warning_blocks(message)
        self.post('scraping-warnings', blocks, '#dd2b0e', 'bug')


    def notify_new_content(self, title: str, url: str):
        blocks = self.new_blocks(title, url)
        self.post('scraping-new-post', blocks, '#3a86ff', 'white_check_mark')


    def post(self, channel: str, blocks: list, color: str, emoji: str):
        if os.getenv('RUNNING_ENV') == 'production':
            try:
                self.client.chat_postMessage(
                    channel=channel,
                    icon_emoji=f':{emoji}:',
                    text='',
                    attachments=json.dumps([{'color': color, 'blocks': blocks}])
                )
                logger.info('Notified to slack')
            except errors.SlackApiError as e:
                logger.error(f"Error posting message: {e}")
        else:
            logger.info(f'Skipped notification in channel {channel}')


    def info_blocks(self, title: str, filename: str, context_id: str):
        return [
            {
                "type": "section",
                "fields": [
                    {
                        "type": "mrkdwn",
                        "text": f'*{title}*',
                    },
                ]
            },
            {
                "type": "section",
                "fields": [
                    {
                        "type": "mrkdwn",
                        "text": f'*File*\n{filename}'
                    },
                    {
                        "type": "mrkdwn",
                        "text": f'*Event ID*\n{context_id}'
                    }
                ]
            },
        ]


    def new_blocks(self, title: str, url: str):
        return [
            {
                "type": "section",
                "fields": [
                    {
                        "type": "mrkdwn",
                        "text": f'*新着情報*',
                    },
                ]
            },
            {
                "type": "section",
                "fields": [
                    {
                        "type": "mrkdwn",
                        "text": f'*タイトル*\n{title}'
                    },
                    {
                        "type": "mrkdwn",
                        "text": f'*ページ*\n{url}'
                    }
                ]
            },
        ]


    def error_blocks(self, filename: str, context_id: str, error: str):
        return [
            {
                "type": "section",
                "fields": [
                    {
                        "type": "mrkdwn",
                        "text": '*スクレイピングが異常終了しました*',
                    },
                ]
            },
            {
                "type": "section",
                "fields": [
                    {
                        "type": "mrkdwn",
                        "text": f'*File*\n{filename}'
                    },
                    {
                        "type": "mrkdwn",
                        "text": f'*Event ID*\n{context_id}'
                    }
                ]
            },
            {
                "type": "divider"
            },
            {
                "type": "section",
                "text": {
                    "type": "mrkdwn",
                    "text": f'```{error}```'
                }
            }
        ]


    def warning_blocks(self, message: str):
        return [
            {
                "type": "section",
                "fields": [
                    {
                        "type": "mrkdwn",
                        "text": '*ページを正しく取得できませんでした*',
                    },
                ]
            },
            {
                "type": "section",
                "text": {
                    "type": "mrkdwn",
                    "text": f'```{message}```'
                }
            }
        ]
