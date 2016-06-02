module BlagoGantt
  module GanttsControllerPatch

    def self.included(base)
      base.extend(ClassMethods)
      base.send(:include, InstanceMethods)
      base.send(:before_action, :patch_gantt_helper)

     # base.class_eval do
     #
     #   def link_to_project_with_easy_gantt(project, options = {})
     #     { controller: 'easy_gantt', action: 'issues', project_id: project }
     #   end
     #
     # end
    end

    module InstanceMethods
      def patch_gantt_helper
        Redmine::Helpers::Gantt.include(BlagoGantt:RedmineHelpersGanttPatch) unless Redmine::Helpers::Gantt.method_defined?(:blago_patched)
      end
    end

    module ClassMethods
    end

  end
  module RedmineHelpersGanttPatch

    def self.included(base)
      base.extend(ClassMethods)
      base.send(:include, InstanceMethods)

     # base.class_eval do
     #
     #   def link_to_project_with_easy_gantt(project, options = {})
     #     { controller: 'easy_gantt', action: 'issues', project_id: project }
     #   end
     #
     # end
    end

    module InstanceMethods
      def blago_patched
        
      end
      def view_hooked
        @view_hooked ? "view hooked is #{@view_hooked}" : "view is not hooked"
      end
      def blago_extended
        "Blago instance extended"
      end
      def view=(new_view)
        @view_hooked = true
        @view = BlagoGantt::RedmineHelpersGanttPatch::ViewPatch.new(new_view)
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
    
    class ViewPatch < BasicObject
      def initialize(view)
        @view = view
      end
      
      def link_to_issue(issue, options={})
        title = nil
        subject = nil
        text = options[:tracker] == false ? "##{issue.id} tracker false" : "#{issue.tracker} ##{issue.id} tracker true"
        if options[:subject] == false
          title = issue.subject.truncate(60)
        else
          subject = "su " + issue.subject
          if truncate_length = options[:truncate]
          subject = subject.truncate(truncate_length)
          end
        end
        only_path = options[:only_path].nil? ? true : options[:only_path]
        s = link_to(text, issue_url(issue, :only_path => only_path),
              :class => issue.css_classes, :title => title)
        s << h(": #{subject}") if subject
        s = h("#{issue.project} - ") + s if options[:project]
        s
      end 
      
      def method_missing(sym, *args, &blk)
          @view.send(sym, *args, &blk)
        end
      end 
  end
  
  
end

RedmineExtensions::PatchManager.register_controller_patch 'GanntsController', 'BlagoGantt::GanttsControllerPatch'
