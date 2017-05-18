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
end
