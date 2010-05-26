module GoalsHelper
  
  def goal_total_class(goal)
    goal.reached? ? 'over' : 'under'
  end

end
