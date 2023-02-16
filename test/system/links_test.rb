require "application_system_test_case"

require 'test_helper'

class LinksTest < ApplicationSystemTestCase  

  test "短連結功能測試" do
    visit links_url
    assert_selector "h2", text: "ROR、redis縮短網址系統"
    
    click_on "新增短連結"

    # 這個fill_in是找欄位名稱 or name的值
    fill_in "Url", with: "https://eagle0526.github.io"
    fill_in "link[utm_campaign]", with: "20230217"
    fill_in "link[utm_medium]", with: "social_post"
    fill_in "link[utm_source]", with: "facebook"
    fill_in "link[utm_term]", with: "yee"
    fill_in "link[utm_content]", with: "website"

    # 加上UTM後，確認這個值有符合欄位
    assert_field "link[url]", with: "https://eagle0526.github.io?utm_campaign=20230217?utm_medium=social_post?utm_source=facebook?utm_term=yee?utm_content=website"
    click_on "新增短連結"


    # 找到短連結
    link = Link.find_by(url: "https://eagle0526.github.io?utm_campaign=20230217?utm_medium=social_post?utm_source=facebook?utm_term=yee?utm_content=website")    
    assert_selector "td", text: "/shorts/#{link.slug}"
    take_failed_screenshot

    # 點擊短連結，因為有兩個同樣的連結在畫面上，不過我只要點到第一個
    first("a[href='/shorts/#{link.slug}']").click    

    # 回首頁
    visit links_url
    assert_selector "h2", text: "ROR、redis縮短網址系統"    

    # 刪除連結，把redis資料匯入資料庫    
    click_on "刪除"
    link.clicked += 1
    assert_equal 1, link.clicked, "資料庫點擊數+1"
    
    # 最後把資料庫的資料刪掉
    click_on "delete"
    take_screenshot

  end
end
