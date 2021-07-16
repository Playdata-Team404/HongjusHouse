import time
from bs4 import BeautifulSoup
from selenium import webdriver
from selenium.webdriver.support.ui import WebDriverWait
import warnings

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

news_tab = browser.find_element_by_xpath('//*[@id="common_component_tab"]/div/ul/li[3]/a')
news_tab.click()

time.sleep(2)
browser.execute_script('window.scrollTo(0, document.body.scrollHeight);')
browser.implicitly_wait(1)
time.sleep(2)
browser.execute_script('window.scrollTo(0, document.body.scrollHeight);')

soup = BeautifulSoup(browser.page_source, "lxml")

datas = []
columns = ['제목', '내용']
items = soup.select("#content > div:nth-child(4) > div:nth-child(3) > div:nth-child(2) > div > div.VNewsList_article__1gx6H > ul")[0].select('li')

# for i in range(len(items)):
for i in range(1, 2):
    article = browser.find_element_by_css_selector("#content > div:nth-child(4) > div:nth-child(3) > div:nth-child(2) > div > div.VNewsList_article__1gx6H > ul > li:nth-child({}) > a.VNewsList_link__2v_Wp".format(i))
    browser.execute_script("arguments[0].click();", article)
    time.sleep(2)



#     print(soup.select("#content > div:nth-child(4) > div:nth-child(3) > div:nth-child(2) > div > div.NewsEnd_endArea__qOUQ4.news.NewsEnd_newsEndArea__2vXx_.NewsEnd_fs3__3jmzE > div.NewsEnd_titleBox__15J4d > strong"))

    # title = item.select('p')
    # row = dict()
    # for k,v in list(zip(columns, d)):
    #     row[k] = v.text
    
    # datas.append(row)
    # print(datas)
time.sleep(2)
browser.implicitly_wait(20)
browser.quit()