class ApiController < ApplicationController

  # Called when a player completes a level. Saves the attempt and sets the
  # user's high score for the level.
  def finish_level
    user = User.find params[:user_id]
    level = Level.find_by!(number: params[:level_number])
    score = params[:score].to_i
    user.finish_level(level, score)
    render json: {
      status: 'success',
      message: "User #{user.id} passed level #{level.number} with score #{score}",
    }
  end

  # Return a list of the 5 top scorers for the given level, along with their
  # top scores. If a user has several of the top scores for the level, only
  # include the top score for that user.
  def leaderboard
    level = Level.find_by!(number: params[:level_number])
    highest_user_levels = level.user_levels.order(high_score: :desc).limit(5)
    render json: {
      status: 'success',
      leaderboard: highest_user_levels.map { |i| { user: i.user_id, score: i.high_score } }
    }
  end

end
