class Movie < ActiveRecord::Base
  def self.all_ratings
    Movie.order(:rating).distinct.pluck(:rating)
  end
end
