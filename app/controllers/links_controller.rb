class LinksController < ApplicationController

  before_action :find_link, only: [:destroy]
  
  def index
    @links = Link.order(id: :desc)
    redis = Redis.new
    @keys = redis.keys("*")

  end

  def new
    @link = Link.new
  end

  def create
    
    @link = Link.new(link_params)

    if @link.save      
      @shortcode = @link.slug

      # 用hash新增 - hset id-43:6365a2 url https://fintechrich.com short http://localhost:3000/shorts/6365a2 slug 6365a2 visit 0
      hash = {"url" => @link.url, "short" => "#{ENV["WEB_DOMAIN"]}/shorts/#{@link.slug}", "slug" => @link.slug, "visit" => 0}
      $redis.hset("id-#{@link.id}:#{@link.slug}", hash)
      
    end
    redirect_to root_path
  end

  def destroy
    @link.destroy
    redirect_to root_path
  end

  
  def increase_visit
    
    # 最後用hincrby id1934 visit 1 這個方法，可以幫visit每點擊一次就 + 1
    if $redis.hgetall(params[:format])["url"]
      $redis.hincrby(params[:format], "visit", 1)
      redirect_to $redis.hgetall(params[:format])["url"]
    else
      render html: "no"
    end    
  end

  def expire_key    
    
    key = params[:format]

    # 把link找出來，並且把快取的visit回填資料庫中
    id = key[3..4]    
    @link = Link.find_by!(id: id)
    @link.clicked = $redis.hgetall(key)["visit"].to_i
    @link.save
            
    # 刪除快取
    $redis.expire(key, 0)
    redirect_to root_path
  end
  
  def import_clicked    
    keys = $redis.keys("*")

    # 這邊根據redis的key，把所有link所有點擊數灌回資料庫
    keys.each do |key|
      link = Link.find_by!(slug: $redis.hgetall(key)["slug"])
      link.clicked = $redis.hgetall(key)["visit"].to_i
      link.save
    end

    redirect_to root_path
  end
  


  private
  def link_params
    params.require(:link).permit(:url, :slug)
  end

  def find_link
    @link = Link.find_by!(id: params[:id])
  end


end