module ApplicationHelper
  def cp(path)
    if current_page?(path)
      "nav-item active"
    else
      "nav-item"
    end
  end
end
