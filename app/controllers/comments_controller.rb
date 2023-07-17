class CommentsController < ApplicationController
  load_and_authorize_resource
  rescue_from ActiveRecord::RecordNotFound, with: :comment_not_found

  def create
    @comment = current_user.comments.build comment_params
    if @comment.save
      flash[:success] = t "comments.flash.comment_success"
    else
      flash[:danger] = @comment.errors.full_messages[0]
    end
    redirect_to user_orders_path current_user
  end

  def update
    if @comment.update comment_params
      flash[:success] = t "comments.flash.update_success"
    else
      flash[:danger] = @comment.errors.full_messages[0]
    end
    redirect_to user_orders_path current_user
  end

  def destroy
    @comment.destroy!
    flash[:success] = t "comments.flash.delete_success"
  rescue ActiveRecord::RecordNotDestroyed
    flash[:danger] = t "comments.flash.delete_failed"
  ensure
    redirect_to user_orders_path current_user
  end

  private
  def comment_params
    params.require(:comment).permit :review, :rate, :order_id, :user_id, :tour_id
  end

  def comment_not_found
    flash[:danger] = t "comments.flash.comment_not_found"
    redirect_to user_orders_path current_user
  end
end
