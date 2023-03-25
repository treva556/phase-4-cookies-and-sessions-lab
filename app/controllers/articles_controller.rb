class ArticlesController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found


  def index
    articles = Article.all.includes(:user).order(created_at: :desc)
    render json: articles, each_serializer: ArticleListSerializer
  end

  def show
    session[:page_views] ||= 0

    #adds one everytime the show method is called
    session[:page_views] += 1

    if session[:page_views] <= 3
      article = Article.find(params[:id])
      render json: article
    else
      render json: {
               error: 'Maximum pageview limit reached',
             },
             status: :unauthorized
    end
  end

  private

  def render_unauthorized
    render json: {
             error: 'Maximum pageview limit reached',
           },
           status: :unauthorized
  end

end
