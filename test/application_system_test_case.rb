require "test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :selenium, using: :chrome, screen_size: [1400, 1400]

  def take_failed_screenshot
    take_screenshot if failed? && supports_screenshot?
  end

  def take_screenshot    
    save_image
    # puts display_image
  end


end
