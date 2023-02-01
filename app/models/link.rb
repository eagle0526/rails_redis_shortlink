class Link < ApplicationRecord
  validates_presence_of :url
  validates :url, format: URI::regexp(%w[http https])
  validates_uniqueness_of :slug
  validates_length_of :url, within: 3..255, on: :create, message: "too long"
  validates_length_of :slug, within: 3..255, on: :create, message: "too long"

  before_validation :generate_slug

  # 這個方法是把網址轉成slug   
  def short
    # Rails.application.routes.url_helpers.short_url(slug: self.slug)
    # Rails.application.routes.url_helpers.short_url(slug: self.slug)    
    "#{ENV["WEB_DOMAIN"]}/shorts/#{self.slug}"

    # 我現在有link，link的欄位有 url、slug
    # 我想要把short方法，寫成短連結的寫法
    # 現在教學寫的方法是直接讀取routes那邊預設的url
    # 不過因為想要把前面那段的url，轉成自己填的URL  
    

  end

  # 隨機產生slug
  def generate_slug
    self.slug = SecureRandom.uuid[0..5] if self.slug.nil? || self.slug.empty?
  end

  # shorten
  def self.shorten(url, slug = '')
    # return short when URL with that slug was created before
    link = Link.where(url: url, slug: slug).first
    return link.short if link

    # create a new
    link = Link.new(url: url, slug: slug)
    return link.short if link.save

    # if slug is taken, try to add random characters
    Link.shorten(url, slug + SecureRandom.uuid[0..2])

  end


end
