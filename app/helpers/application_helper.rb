module ApplicationHelper
  # Today With Time
  def twt(t)
    if t.today?
      t.to_s(:datetime)
    else
      t.to_s(:date)
    end
  end
end
