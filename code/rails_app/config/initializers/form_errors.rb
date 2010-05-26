# For inline form-field error messages
ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|
  if html_tag =~ /type="hidden"/ || html_tag =~ /<label/
    html_tag
  else
    %[<span class="error-with-field">#{html_tag} <span class="error_message">&bull;
      #{[instance.error_message].flatten.first}</span></span>].html_safe
  end
end