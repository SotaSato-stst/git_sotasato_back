from typing import List
import json
import re
from logging import getLogger
from utility.request import request_response

logger = getLogger(__name__)

class MirasapoLogic :
    base_url = 'https://seido-navi.mirasapo-plus.go.jp/supports'
    # URLのパラメータ（limitやoffsetなど）を指定可能
    # service_category=3 補助金に絞る
    request_url = 'https://jirei-seido-api.mirasapo-plus.go.jp/supports?get_expired=false&sort=update&order=desc&limit=100&offset=0'

    def execute(self) -> List:
        results = []

        response = request_response(self.request_url)

        items = json.loads(response.content)['items']

        for item in items:
            text = item['title']

            key = 'refernece' # サイトがゴミなのでタイポしている
            # まとめサイトなので、元の参照URLがあればそれを優先して取得する
            if key in item:
                reference = item[key]
                regexp='(http|https)+(:\/\/)+([\w_-]+(?:(?:\.[\w_-]+)+))([\w.,@?^=%&:\/~+#-]*[\w@?^=%&\/~+#-])'
                matches = re.findall(regexp, reference)

                urls = []
                for match in matches:
                    urls.append(''.join(match))

                for url in urls:
                    dic = {
                        'target_url': self.base_url,
                        'text': text,
                        'url': url
                    }
                    results.append(dic)

            # 参照元のURLがなければミラサポのサイトにある詳細ページを取得しておく
            else:
                url = f'{self.base_url}/{item["id"]}'
                dic = {
                    'target_url': self.base_url,
                    'text': text,
                    'url': url
                }
                results.append(dic)

        return results
