class ShortsController < ApplicationController

  before_action :find_link, only: [:show]
  # @@redis = Redis.new

  def show
    # render html: request.referrer
    # render html: params
    
        
    
    # 如果今天redis用get方法，發現有此筆資料，就直接redirect_to，到目標網址
    # if $redis.hgetall("#{ENV["WEB_DOMAIN"]}/shorts/#{params[:id]}")
    # redirect_to $redis.hget("#{ENV["WEB_DOMAIN"]}/shorts/#{params[:id]}")
    if $redis.hgetall("id-#{@link.id}:#{@link.slug}")["url"]
      # redirect_to $redis.hgetall("id-#{@link.id}:#{@link.slug}")["url"]

      # 如果redis裡面有存此id，幫visit + 1
      $redis.hincrby("id-#{@link.id}:#{@link.slug}", "visit", 1)
      
      redirect_to @link.url
      
      
    else
    # 否則就用setnx，先寫一份到資料庫，再重導入
      # $redis.setnx "#{ENV["WEB_DOMAIN"]}/shorts/#{params[:id]}", @link.url
      # redirect_to $redis.get("#{ENV["WEB_DOMAIN"]}/shorts/#{params[:id]}")

      # ------------
      # render html: "no"
    # 用hset改寫，這個 visit 不應該要是0，應該要從資料庫的click抓出數量
      hash = {"url" => @link.url, "short" => "#{ENV["WEB_DOMAIN"]}/shorts/#{@link.slug}", "slug" => @link.slug, "visit" => @link.clicked}
      $redis.hset("id-#{@link.id}:#{@link.slug}", hash)
      # # redirect_to $redis.hgetall("id-#{@link.id}:#{@link.slug}")["url"]

      # # 寫一份到redis後，直接幫點擊數 + 1
      $redis.hincrby("id-#{@link.id}:#{@link.slug}", "visit", 1)

      redirect_to @link.url
      
      # ------------
    end

    
    # 有link資料，就可以知道

  end


  private

  def find_link
    @link = Link.find_by!(slug: params[:id])
  end

end

