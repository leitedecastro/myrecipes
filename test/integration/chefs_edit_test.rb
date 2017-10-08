require 'test_helper'

class ChefsEditTest < ActionDispatch::IntegrationTest
  
  def setup
    @chef = Chef.create!(chefname: 'paulo', email: 'pr@example.com',
                         password: 'password', password_confirmation: 'password')
    @chef2 = Chef.create!(chefname: 'renato', email: 'renato@example.com',
                         password: 'password', password_confirmation: 'password')
    @admin_user = Chef.create!(chefname: 'admin', email: 'admin@example.com',
                         password: 'password', password_confirmation: 'password', admin: true)
  end

  test 'reject on invalid edit' do
    sign_in_as(@chef)
    get edit_chef_path(@chef)
    assert_template 'chefs/edit'
    patch chef_path(@chef), params: { 
      chef: {
        chefname: ' ',
        email: 'pr@example.com'
      }
    }
    assert_template 'chefs/edit'
    assert_select 'h2.panel-title'
    assert_select 'div.panel-body'
  end
  
  test 'accept valid edit' do
    sign_in_as(@chef)
    get edit_chef_path(@chef)
    assert_template 'chefs/edit'
    patch chef_path(@chef), params: { 
      chef: {
        chefname: 'paulor',
        email: 'pr1@example.com'
      }
    }
    assert_redirected_to @chef
    assert_not flash.empty?
    @chef.reload
    assert_match 'paulor', @chef.chefname
    assert_match 'pr1@example.com', @chef.email
  end
  
  test 'accept edit attempt by admin user' do
    sign_in_as(@admin_user)
    get edit_chef_path(@chef)
    assert_template 'chefs/edit'
    patch chef_path(@chef), params: { 
      chef: {
        chefname: 'paulor',
        email: 'pr1@example.com'
      }
    }
    assert_redirected_to @chef
    assert_not flash.empty?
    @chef.reload
    assert_match 'paulor', @chef.chefname
    assert_match 'pr1@example.com', @chef.email
  end
  
  test 'redirect edit attempt by another non-admin user' do
    sign_in_as(@chef2)
    updated_name = @chef2.chefname
    updated_email = @chef2.email
    patch chef_path(@chef), params: { chef: { chefname: updated_name, email: updated_email } }
    assert_redirected_to chefs_path
    assert_not flash.empty?
    @chef.reload
    assert_match 'paulo', @chef.chefname
    assert_match 'pr@example.com', @chef.email
  end
  
end