require "test_helper"

class LinkTest < ActiveSupport::TestCase
  test "the truth" do
    assert true    
  end

  test "test new link" do
    link = Link.new
    assert_not link.save, "Saved the article without a title"
    # assert link.save, "Saved the article without a title"
    # assert true
    
  end

  test "should report error 123" do
    # some_undefined_variable is not defined elsewhere in the test case
    # 這樣會讓此測試發生錯誤，因為沒有此方法
    # some_undefined_variable
    assert true
    
  end

  test "should report error" do
    # some_undefined_variable is not defined elsewhere in the test case
    # 這樣就可以讓測試正常運行
    assert_raises(NameError) do
      some_undefined_variable
    end

    p "222"
    
  end


end
