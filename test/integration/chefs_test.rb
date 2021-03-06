require 'test_helper'

class ChefsTestTest < ActionDispatch::IntegrationTest
  
  def setup
    @chef = Chef.create!(chefname: 'paulo', email: 'pr@example.com',
                         password: 'password', password_confirmation: 'password')
    @chef2 = Chef.create!(chefname: 'renato', email: 'renato@example.com',
                         password: 'password', password_confirmation: 'password')
    @admin_user = Chef.create!(chefname: 'admin', email: 'admin@example.com',
                         password: 'password', password_confirmation: 'password', admin: true)
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
  
  test 'should delete chef' do
    sign_in_as(@admin_user)
    get chefs_path
    assert_template 'chefs/index'
    assert_difference 'Chef.count', -1 do
      delete chef_path(@chef2)
    end
    assert_redirected_to chefs_path
    assert_not flash.empty?
  end
end