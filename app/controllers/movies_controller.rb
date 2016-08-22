class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date, :order_by)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_ratings
    if params[:ratings] || session[:ratings]
      @selected_ratings = params[:ratings] || session[:ratings]
    else
      @selected_ratings = Hash[@all_ratings.map {|rating| [rating, rating]}]
    end
    order_by = params[:order_by] || session[:order_by]
    instance_variable_set("@#{order_by}_header", 'hilite')

    if params[:order_by] != session[:order_by] or params[:ratings] != session[:ratings]
      session[:order_by] = order_by
      session[:ratings] = @selected_ratings
      redirect_to :order_by => order_by, :ratings => @selected_ratings and return
    end
    @movies = Movie.where(rating: @selected_ratings.keys).order(order_by)
    # @movies = Movie.all.order(order_by)
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
