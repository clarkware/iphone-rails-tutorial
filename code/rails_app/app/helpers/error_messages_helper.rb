module ErrorMessagesHelper

  def error_messages_for(object, options={})
    if object && object.errors.any?
      options[:header_message] ||= "Oops, there were errors while processing this form."
      if object.errors[:base].any?
        options[:message] ||= object.errors[:base]
      else
        options[:message] ||= "Please correct the errors below and try again!"
      end
      content_tag(:div, 
        content_tag(:h4, options[:header_message]) +
        content_tag(:p, options[:message]),
        :id => 'flash_error', :class => 'error_messages')
    end
  end

  module FormBuilderAdditions
    def error_messages(options = {})
      @template.error_messages_for(@object, options)
    end
  end
end

ActionView::Helpers::FormBuilder.send(:include, ErrorMessagesHelper::FormBuilderAdditions)