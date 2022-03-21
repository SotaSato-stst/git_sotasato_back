import base64
import os
from logging import INFO, NOTSET, basicConfig, getLogger, StreamHandler
from controllers.selector_controller import SelectorController
from controllers.curation_controller import CurationController
from utility.slack import Slack
from dotenv import load_dotenv

load_dotenv()

# ログ設定
stream_handler = StreamHandler()
stream_handler.setLevel(INFO)

if os.getenv('RUNNING_ENV') == 'development':
    log_format = "%(asctime)s %(levelname)-7s %(message)s"
else:
    log_format = "%(levelname)-7s %(message)s"

basicConfig(
    level=NOTSET,
    format=log_format,
    handlers=[stream_handler],
)
logger = getLogger(__name__)


def debug_for_selector():
    logger.info('[DEBUG] Scraping Started')
    try:
        controller = SelectorController()
        controller.execute()
        logger.info('[DEBUG] Scraping Finished')
    except Exception as e:
        logger.exception(e)
        logger.error('[DEBUG] Scraping Failed')


def debug_for_curation():
    logger.info('[DEBUG] Scraping Started')
    try:
        controller = CurationController()
        controller.execute()
        logger.info('[DEBUG] Scraping Finished')
    except Exception as e:
        logger.exception(e)
        logger.error('[DEBUG] Scraping Failed')


def cloud_function_for_selector(event, context):
    # Cloud Sheduler → Cloud Pub/Subでcsvファイルの名前をメッセージとして送信しおり、event['data']で受け取ることができる
    if 'data' in event:
        csv_filename = base64.b64decode(event['data']).decode('utf-8')
        controller = SelectorController(csv_filename)
        slack = Slack()

        try:
            slack.notify_start(csv_filename, context.event_id)
            warnings = controller.execute()
            if len(warnings) > 0:
                slack.notify_warning('\n'.join(warnings))
        except Exception as e:
            logger.exception(e)
            slack.notify_error(csv_filename, context.event_id, f'{e}')
        else:
            slack.notify_finish(csv_filename, context.event_id)

    else:
        logger.error('Message Not Found')


def cloud_function_for_curation(event, context):
    controller = CurationController(context.event_id)

    slack = Slack()
    notification_description = 'キュレーションサイト'

    try:
        slack.notify_start(notification_description, context.event_id)
        warnings = controller.execute()
        if len(warnings) > 0:
            slack.notify_warning('\n'.join(warnings))
    except Exception as e:
        logger.exception(e)
        slack.notify_error(notification_description, context.event_id, f'{e}')
    else:
        slack.notify_finish(notification_description, context.event_id)


if __name__ == "__main__":
    logger.info('実行したい関数を選択してください')
    # debug_for_selector()
    # debug_for_curation()
