class BlogsController < ApplicationController
  before_action :authenticate_user!
  # onlyにshowアクションを追加します。
  before_action :set_blog, only: [:show, :edit, :update, :destroy]

  def index
    @blogs = Blog.all
#    respond_to do |format|
#      format.html
#      format.js
#    end
  end
  
  # showアククションを定義します。入力フォームと一覧を表示するためインスタンスを2つ生成します。
  def show
    @comment = @blog.comments.build
    @comments = @blog.comments
  end

  def new
#    @blog = Blog.new
    if params[:back]
      @blog = Blog.new(blogs_params)
    else
      @blog = Blog.new
    end
#    if @blog.save
#      # 一覧画面へ遷移して"ブログを作成しました！"とメッセージを表示します。
#      redirect_to blogs_path, notice: "ブログを作成しました！"
#    else
#      # 入力フォームを再描画します。
#      render 'new'
#    end
  end
  
  def create
#    Blog.create(blogs_params)
#    redirect_to blogs_path, notice: "ブログを作成しました！"
    @blog = Blog.new(blogs_params)
    # user_idを代入する
    @blog.user_id = current_user.id
    if @blog.save
      # 一覧画面へ遷移して"ブログを作成しました！"とメッセージを表示します。
      redirect_to blogs_path, notice: "ブログを作成しました！"
      NoticeMailer.sendmail_blog(@blog).deliver
    else
      # 入力フォームを再描画します。
      render 'new'
    end
  end

#  private
#   def blogs_params
#     params.require(:blog).permit(:title, :content)
#   end
   
#  def edit
#    @blog = Blog.find(params[:id])
#  end
#
#  def update
#    @blog = Blog.find(params[:id])
#    @blog.update(blogs_params)
#    redirect_to blogs_path, notice: "ブログを作成しました！"
#  end
#  
#  private
#   def blogs_params
#     params.require(:blog).permit(:title, :content)
#   end

  def edit
    # edit, update, destroyで共通コード
    @blog = Blog.find(params[:id])
  end

  def update
    # edit, update, destroyで共通コード
    @blog = Blog.find(params[:id])

    if @blog.update(blogs_params)
      redirect_to blogs_path, notice: "ブログを更新しました！"
    else
      render 'edit'
    end
  end
  
  def destroy
    # edit, update, destroyで共通コード
    @blog = Blog.find(params[:id])
    @blog.destroy
    redirect_to blogs_path, notice: "ブログを削除しました！"
  end

  def confirm
    @blog = Blog.new(blogs_params)
    render :new if @blog.invalid?
  end

  private
    def blogs_params
      params.require(:blog).permit(:title, :content)
    end

    # idをキーとして値を取得するメソッド
    def set_blog
      @blog = Blog.find(params[:id])
    end
end