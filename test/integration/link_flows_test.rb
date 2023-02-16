require "test_helper"

class LinkFlowsTest < ActionDispatch::IntegrationTest

  setup do
    @link = links(:one)    
  end

  teardown do
    Rails.cache.clear
  end


  test "進到首頁" do
    get "/"
    assert_select "h2", "ROR、redis縮短網址系統" 
  end

  test "新增連結" do
    get "/links/new"    
    assert_response :success

    post "/links",
      params: { link: { url: "https://www.yourator.co/" , slug: "123abc"} }
    assert_response :redirect
    follow_redirect!

    assert_response :success
    assert_select "td", "https://www.yourator.co/"    
  end

  test "讀取連結" do
    get "/links"
    assert_response :success

    assert_includes response.body, "#{@link.id}"
  end

  test "刪除連結" do

    delete "/links/#{@link.id}"

    assert_response :redirect
    follow_redirect!
    assert_response :success

    refute_includes response.body, "#{@link.id}"
       
  end

end
