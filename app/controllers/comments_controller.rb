class CommentsController < ApplicationController
  before_action :require_user
  
  def create
    @recipe = Recipe.find(params[:recipe_id])
    @comment = @recipe.comments.build(comment_params)
    @comment.chef = current_chef
    if @comment.save
      flash[:success] = 'Comment was created sucessfully'
      redirect_to recipe_path(@recipe)
    else
      flash[:danger] = 'There was a problem creating the comment, try again later'
      redirect_back fallback_location: root_path
    end
  end
  
  private
  
    def comment_params
      params.require(:comment).permit(:description)
    end
    
end