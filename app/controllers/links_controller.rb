class LinksController < ApplicationController

  # before_action only: [:create] do
  #   rand_string(length) 
  # end
  before_action :find_link, only: [:destroy]
  before_action :rand_string, only: [:create]
  before_action :generate_slug, only: [:create]

  def index
    @links = Link.all
    redis = Redis.new
    @keys = redis.keys("*")

  end

  def new
    @link = Link.new
  end

  def create

    # render html: params[:link][:url]

    @link = Link.new(link_params)

    if @link.save

      # @shortcode = generate_slug
      @shortcode = @link.slug
      # 普通的set新增
      # $redis.setnx "#{ENV["WEB_DOMAIN"]}/shorts/#{@shortcode}", params[:link][:url]

      # 用hash新增 - hset id-43:6365a2 url https://fintechrich.com short http://localhost:3000/shorts/6365a2 slug 6365a2 visit 0
      hash = {"url" => @link.url, "short" => "#{ENV["WEB_DOMAIN"]}/shorts/#{@link.slug}", "slug" => @link.slug, "visit" => 0}
      $redis.hset("id-#{@link.id}:#{@link.slug}", hash)

      
    end

    redirect_to root_path

  end


  def show
    @link = Link.find_by_slug(params[:slug])
    render 'errors/404', status: 404 if @link.nil?

    @link.update_attribute(:clicked, @link.clicked + 1)
    redirect_to @link.url
  end

  def destroy
    @link.destroy
    redirect_to root_path
  end

  
  def redis_link
    # render html: params[:format]
    if $redis.hgetall(params[:format])["url"]
      $redis.hincrby(params[:format], "visit", 1)
      redirect_to root_path
    else
      render html: "no"
    end
    # <%# 最後用hincrby id1934 visit 1 這個方法，可以幫visit每點擊一次就 + 1 %>

    # redis = Redis.new
    # if redis.get(params[:format])
    #   redirect_to redis.get(params[:format])
    # else
    #   # 根據使用者點擊的redis連結，用slug找出是哪一個link
    #   slug = params[:format][-6..-1]
    #   link = Link.find_by!(slug: params[:slug])

    #   # 把此link存進redis
    #   shortcode = slug
    #   redis.setnx "https://woding/#{@shortcode}", link.url

    #   redirect_to link.url
    # end

  end
  # 如果在redis找不到連結，就到資料庫去找，資料庫找到後，先寫一份到redis，寫完後再重導到該網址
  # 會發生redis沒有，但是資料庫有資料，通常是因為redis是存在快取，很容易資料不見


  def expire_key
    # render html: params
    
    # 刪除快取前，先把link找出來，並且把快取的visit回填資料庫中
    id = params[:format][3..4]    
    @link = Link.find_by!(id: id)

    @link.clicked = $redis.hgetall(params[:format])["visit"].to_i
    @link.save
    
    
    # redis = Redis.new
    key = params[:format]
    
    $redis.expire(key, 0)
    redirect_to root_path
  end

  def increase_key
    # render html: params
    redis = Redis.new
    key = params[:format]
    redis.incr(key)
    
  end
  
  def import_clicked
    # render html: params
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

  def rand_string
    rand(36**5).to_s(36)
  end

  def generate_slug
    SecureRandom.uuid[0..5]
  end

  def find_link
    @link = Link.find_by!(id: params[:id])
  end


end