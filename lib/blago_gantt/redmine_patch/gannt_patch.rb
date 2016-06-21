module BlagoGantt
  module RedmineHelpersGanttPatch

    def self.included(base)
      base.extend(ClassMethods)
      base.send(:include, InstanceMethods)

      base.class_eval do
     
  def view=(new_view)
    @view_hooked = true
    @view = BlagoGantt::ViewPatch.new(new_view)
  end
     
      end
    end

    module InstanceMethods
  def view_hooked
    @view_hooked ? "view hooked is #{@view_hooked}" : "view is not hooked"
  end
  def blago_extended
    "Blago instance extended"
  end
    end

    module ClassMethods
  def blago_extended
    "Blago class extended"
  end
  def view=(new_view)
    @view_hooked = true
    @view = BlagoGantt::ViewPatch.new(new_view)
  end
    end

  end
  
  class ViewPatch < BasicObject
  def initialize(view)
    @view = view
  end
  
  def link_to_issue(issue, options={})
    title = nil
    subject = nil
    text = options[:tracker] == false ? "##{issue.id}" : "#{issue.tracker[0, 2] } ##{issue.id}"
    if options[:subject] == false
      title = issue.subject.truncate(60)
    else
      subject =  issue.subject
      if truncate_length = options[:truncate]
      subject = subject.truncate(truncate_length)
      end
    end
    only_path = options[:only_path].nil? ? true : options[:only_path]
    text += " " + subject if subject
    s = link_to(text, issue_url(issue, :only_path => only_path),
          :class => issue.css_classes, :title => title)
    #s << h(": #{subject}") if subject
    s = h("#{issue.project} - ") + s if options[:project]
    s
  end 
  
  def method_missing(sym, *args, &blk)
      @view.send(sym, *args, &blk)
    end
  end
end

RedmineExtensions::PatchManager.register_helper_patch 'Redmine::Helpers::Gantt', 'BlagoGantt::RedmineHelpersGanttPatch'
