class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy, :approve]

  def approve 
    authorize @post
    @post.approved!
    redirect_to root_path
  end

  def index
    @posts = current_user.posts.page(params[:page]).per(10)
  end

  def new
    #This renders the new form
    @post = Post.new
  end

  def create
    #:post = model name
    @post = Post.new(post_params)
    @post.user_id = current_user.id

    if @post.save
      redirect_to @post, notice: 'Your post was created successfully'
    else
      render :new
    end
  end

  def edit
      authorize @post
    # @post = Post.find(params[:id])
  end

  def update
    authorize @post
    # @post = Post.find(params[:id])
    if @post.update(post_params)
      redirect_to @post, notice: 'Your post was created successfully'
    else
      render :edit
    end
  end

  def destroy
    # @post = Post.find(params[:id])
    @post.delete
    redirect_to posts_path notice: 'Your post was deleted successfully'
  end

  def show
    # @post = Post.find(params[:id])
  end

  private
  def post_params
    params.require(:post).permit(:date, :rationale, :status, :overtime_request)
  end

  def set_post
    @post = Post.find(params[:id])
  end
end
