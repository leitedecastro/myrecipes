require 'test_helper'

class ChefsTestTest < ActionDispatch::IntegrationTest
  
  def setup
    @chef = Chef.create!(chefname: 'paulo', email: 'pr@example.com',
                         password: 'password', password_confirmation: 'password')
  end
  
  test 'should get chefs index' do
    get chefs_path
    assert_response :success
  end
  
  test 'should get chefs listing' do
    get chefs_path
    assert_template 'chefs/index'
    assert_select "a[href=?]", chef_path(@chef), text: @chef.chefname.capitalize
  end
  
end
