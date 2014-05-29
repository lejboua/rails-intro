class Movie < ActiveRecord::Base
  attr_accessible :title, :rating, :description, :release_date
# class method =~ static method, uses self.[method_name]
  def self.distinct_ratings
    Movie.pluck('DISTINCT rating')
  end
end
