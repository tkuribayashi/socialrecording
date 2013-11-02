# -*- coding:utf-8 -*-

import tweepy
import urllib #URLエンコード

#特定のハッシュタグがついたツイートを収集
def get_tweet(hash_tag):
    #sociarecoアカウントのキーを登録
    consumer_key = "D1clZopZXMcfIIOU2lS4Q"
    consumer_secret = "Lkt9MGNHXCjHAdzKX35XARd9xz1dkL9lt7KTfoAsvM"
    access_token = "1932884544-BU88Qjr7ZnPHHPxqdKSxnYiWG74kS7vkL6gWSh0"
    access_secret = "C96JswpU45u0mmtqXXXLELzrDwGRyNhSaCdiPg4KM"

    #twitterAPIを利用できるようにする
    auth = tweepy.OAuthHandler(consumer_key, consumer_secret)
    auth.set_access_token(access_token, access_secret)
    api = tweepy.API(auth)

    #ハッシュタグで検索した結果を取得(最新15件)
    #results = api.search(urllib.quote_plus(hash_tag))
    results = api.home_timeline() #暫定的

    c = 1 #カウンタ

    #結果を整形し表示
    for result in results:
        odai = result.text
        if odai.index(hash_tag) > -1:
            odai = odai.split("#")[0].strip()
            print str(c) + "件目のお題\n----------------\n" + odai + "\n-----------------\n"
            c += 1

if __name__ == "__main__":
    get_tweet("#sociareco")
