class User < ActiveRecord::Base
  has_many :user_levels
  has_many :levels, through: :user_levels

  def level_attempts
    UserLevelAttempt.joins(:user_level).where(user_levels: { user_id: self.id })
  end

  def finish_level(level, score)
    transaction do
      user_level = self.user_levels.find_or_create_by!(level: level)
      user_level.attempts.create!(score: score)
      if score > (user_level.high_score || 0)
	      user_level.update!(high_score: score)      	
      end
    end
  end
end
