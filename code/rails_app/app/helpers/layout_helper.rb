module LayoutHelper
    
  def banner(name, *actions)
    @page_title = "Save Up | #{h(name)}"
    actions = content_tag(:span, actions.join(separator).html_safe, :class => 'actions')
    content_for(:banner) do 
      content_tag(:div, content_tag(:h2, actions + h(name)), :id => 'banner') 
    end
  end
  
  def navigation_links
    links = []
    if logged_in?
      links << link_to("Goals", goals_path)
      links << link_to("About", about_path)
      links << link_to("Logout", logout_path)
    else
      links << link_to("Join", join_path)
      links << link_to("About", about_path)
    end
    content_tag(:span, links.join(separator).html_safe, :class => 'actions')
  end
  
  def separator
    %{<span class="separator"> | </span>}.html_safe
  end
  
  def labeled_form_for(*args, &block)
    options = args.extract_options!.merge(:builder => LabeledFormBuilder)
    form_for(*(args + [options]), &block)
  end
  
  def cancel_link(url)
    link_to 'cancel', url, :class => 'destructive'
  end
  
end