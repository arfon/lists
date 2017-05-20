module ListsHelper
  def private_tag(list)
    if list.hidden?
      " <mark><em>Private</em></mark>".html_safe
    end
  end

  def property_units(property)
    return "" if property['units'].blank?
    "<span class='units'> (#{property['units']})</span>".html_safe
  end

  def curator_name(list)
    if current_user && current_user == list.user
      return "You"
    else
      return list.user.name
    end
  end
end
