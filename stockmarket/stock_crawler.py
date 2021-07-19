from flask import Flask, render_template, request, jsonify
import time
from bs4 import BeautifulSoup
from selenium import webdriver
from selenium.webdriver.support.ui import WebDriverWait
import pandas as pd
import warnings

warnings.filterwarnings('ignore')

main_url = "https://m.stock.naver.com/searchItem.nhn?searchType=init"
keyword = "삼성전자"

browser = webdriver.Chrome("C:/driver/chromedriver")
browser.get(main_url)

time.sleep(2)
browser.implicitly_wait(2) 

search_box = browser.find_element_by_id("keyword_top")
search_box.clear()
search_box.send_keys(keyword)
search_box.submit()

browser.implicitly_wait(1) 

stock_item = browser.find_element_by_xpath('//*[@id="searchResult"]/li[1]/a/b')
stock_item.click()

browser.implicitly_wait(5) 

price_tab = browser.find_element_by_xpath('//*[@id="common_component_tab"]/div/ul/li[4]/a')
price_tab.click()

time.sleep(2)
browser.execute_script('window.scrollTo(0, document.body.scrollHeight);')
browser.implicitly_wait(1)
time.sleep(2)
browser.execute_script('window.scrollTo(0, document.body.scrollHeight);')

soup = BeautifulSoup(browser.page_source, "lxml")

datas = []
columns = ['날짜','종가','전일대비','등락률','시가','고가','저가','거래량']
items = soup.select("#content > div:nth-child(4) > div:nth-child(3) > div:nth-child(2) > div > div.VTablePrice_article__DfdmT > table > tbody")[0].select('tr')

for item in items:
    d = item.select('td')
    row = dict()
    for k,v in list(zip(columns, d)):
        row[k] = v.text
    
    datas.append(row)

browser.quit()
