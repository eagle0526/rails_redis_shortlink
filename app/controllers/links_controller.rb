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
      $redis.setnx "#{ENV["WEB_DOMAIN"]}/shorts/#{@shortcode}", params[:link][:url]

      # redis.hsetnx "https://woding/#{@shortcode}" click 0
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
    # render html: params

    redis = Redis.new
    if redis.get(params[:format])
      redirect_to redis.get(params[:format])
    else
      # 根據使用者點擊的redis連結，用slug找出是哪一個link
      slug = params[:format][-6..-1]
      link = Link.find_by!(slug: params[:slug])

      # 把此link存進redis
      shortcode = slug
      redis.setnx "https://woding/#{@shortcode}", link.url

      redirect_to link.url
    end

  end
  # 如果在redis找不到連結，就到資料庫去找，資料庫找到後，先寫一份到redis，寫完後再重導到該網址
  # 會發生redis沒有，但是資料庫有資料，通常是因為redis是存在快取，很容易資料不見


  def expire_key
    # render html: params[:format]

    redis = Redis.new
    key = params[:format]
    redis.expire(key, 0)
    redirect_to root_path
  end

  def increase_key
    # render html: params
    redis = Redis.new
    key = params[:format]
    redis.incr(key)
    
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