module PostsHelper
  def link_to_add_fields(name, f, as, options={})
    new_object = f.object.class.reflect_on_association(as).klass.new
    fields = f.fields_for(as, new_object, :child_index => "new_#{as}") do |builder|
      render("shared/" + as.to_s.singularize + "_fields", :f => builder)
    end
    link_to_function(name, "Posts.add_fields(this, '#{as}', '#{escape_javascript(fields)}')", options)
  end

  def link_to_remove_fields(name, f, options={})
    f.hidden_field(:_destroy) + link_to_function(name, "Posts.remove_fields(this)", options)
  end
end
