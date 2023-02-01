class ShortsController < ApplicationController

  before_action :find_link, only: [:show]
  # @@redis = Redis.new

  def show
    # render html: request.referrer
    # render html: params
    
    
    # redis = Redis.new
    
    # 如果今天redis用get方法，發現有此筆資料，就直接redirect_to，到目標網址
    if $redis.get("#{ENV["WEB_DOMAIN"]}/shorts/#{params[:id]}")
      redirect_to $redis.get("#{ENV["WEB_DOMAIN"]}/shorts/#{params[:id]}")
    else
    # 否則就用setnx，先寫一份到資料庫，再重導入
      $redis.setnx "#{ENV["WEB_DOMAIN"]}/shorts/#{params[:id]}", @link.url
      redirect_to $redis.get("#{ENV["WEB_DOMAIN"]}/shorts/#{params[:id]}")
    end


  end


  private

  def find_link
    @link = Link.find_by!(slug: params[:id])
  end

end

