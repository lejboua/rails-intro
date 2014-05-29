class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    
    # debug
=begin
    puts 'Params.Ratings' + params[:ratings].to_s
    puts 'Params.Sort' + params[:sort].to_s
    puts 'Session.Ratings' + session[:ratings].to_s
    puts 'Session.Sort' + session[:sort].to_s
=end

    # if no params passed and there are params in session, use them
    if (!params.has_key?(:ratings) && !params.has_key?(:sort)) && (session.has_key?(:ratings) || session.has_key?(:sort))
      # to keep the flash message on one more redirect
      flash.keep
      # redirect with the params in session
      redirect_to :action => 'index', :ratings => session[:ratings], :sort => session[:sort]
    end

    # if user unchecks all checkboxes
    # use the settings stored in session[]
    if !params[:ratings]
      params[:ratings] = session[:ratings]
    end

    @all_ratings = Movie.distinct_ratings
    if params[:ratings] && params[:ratings].count > 0
      @movies = Movie.find(:all, :order => params[:sort], :conditions => { :rating => params[:ratings].keys })
      @selected_ratings = params[:ratings].keys
    else
      @movies = Movie.all(:order => params[:sort])
      # doesn't make sense no rating chosen, so we select all ratings
      @selected_ratings = @all_ratings
    end

    session[:ratings] = Hash[@selected_ratings.map { |r| [r, 1]}]
    session[:sort] = params[:sort]
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
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
