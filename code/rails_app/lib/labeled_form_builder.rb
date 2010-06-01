# Extracte from Ryan Bates' "Mastering Rails Forms" screencast series:
# http://pragprog.com/screencasts/v-rbforms/mastering-rails-forms

class LabeledFormBuilder < ActionView::Helpers::FormBuilder
  %w[text_field collection_select password_field text_area date_select].each do |method_name|
    define_method(method_name) do |field_name, *args|
      options = args.last.is_a?(Hash) ? args.pop : {}
      if options[:hint] 
        hint = @template.content_tag(:span, options[:hint], :class => "hint")
      end
      @template.content_tag(:p, field_label(field_name, *args) + super(field_name, *args) + hint)
    end
  end
  
  def check_box(field_name, *args)
    @template.content_tag(:p, super(field_name, *args) + " " + field_label(field_name, *args))
  end
  
  def submit(*args)
    @template.content_tag(:p, super(*args))
  end
  
private
  
  def field_label(field_name, *args)
    options = args.extract_options!
    options.reverse_merge!(:required => field_required?(field_name))
    options[:label_class] = "required" if options[:required]
    label(field_name, options[:label], :class => options[:label_class])
  end
  
  def field_required?(field_name)
    object.class.validators_on(field_name).map(&:class).include?(ActiveModel::Validations::PresenceValidator)
  end
  
  def objectify_options(options)
    super.except(:label, :required, :label_class)
  end
end