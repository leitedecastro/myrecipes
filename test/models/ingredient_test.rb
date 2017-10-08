require 'test_helper'

class IngredientTest < ActiveSupport::TestCase
  
  def setup
    @ingredient = Ingredient.new(name: 'some ingredient')
  end
  
  test 'is valid' do
    assert @ingredient.valid?
  end
  
  test 'is invalid without a name' do
    @ingredient.name = ' '
    assert_not @ingredient.valid?
  end
  
  test 'is invalid if name has less then 3 characters' do
    @ingredient.name = 'aa'
    assert_not @ingredient.valid?
  end
  
  test 'is invalid if name has more than 25 characters' do
    @ingredient.name = 'a' * 26
    assert_not @ingredient.valid?
  end
  
  test 'is invalid if name already exists' do
    @duplicate_ingredient = Ingredient.create!(name: @ingredient.name)
    assert_not @ingredient.valid?
  end
  
  test 'has a valid recipe_ingredients association' do
    assert_not_nil @ingredient.recipe_ingredients
  end
  
  test 'has a valid recipe association' do
    assert_not_nil @ingredient.recipes
  end
  
end