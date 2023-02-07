class ShortsController < ApplicationController

  before_action :find_link, only: [:show]  

  def show

    # 確認redis中有沒有這個key(用*可以拿到相關字串)
    key = $redis.keys("*#{params[:id]}").first
    if key    
      # 如果redis裡面有存此id，幫visit + 1
      $redis.hincrby(key, "visit", 1)

      redirect_to $redis.hgetall(key)["url"]
    else
      # 如果redis中沒有這個key，就寫一份到redis裡面
      hash = {"url" => @link.url, "short" => "#{ENV["WEB_DOMAIN"]}/shorts/#{@link.slug}", "slug" => @link.slug, "visit" => @link.clicked}
      $redis.hset("id-#{@link.id}:#{@link.slug}", hash)

      # 寫一份到redis後，直接幫點擊數 + 1
      $redis.hincrby("id-#{@link.id}:#{@link.slug}", "visit", 1)

      redirect_to @link.url
    end
  end

  private

  def find_link
    @link = Link.find_by!(slug: params[:id])
  end

end

