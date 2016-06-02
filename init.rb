Redmine::Plugin.register :blago_gannt do
  name 'Blago Gannt plugin'
  author 'Ladonkin Dmitry'
  version '0.0.2'
  url 'http://example.com/path/to/plugin'
  author_url 'http://example.com/about'
  app_dir = File.join(File.dirname(__FILE__), 'app')
  lib_dir = File.join(File.dirname(__FILE__), 'lib', 'blago_gantt')
  #description 'Change Gannt for Blagosostoyanie'
  # Redmine patches
  
  loaded_files = ""
  patch_path = File.join(lib_dir, 'redmine_patch', '**', '*.rb')
  Dir.glob(patch_path).each do |file|
    require_dependency file
    loaded_files += " " + file
#    loaded_files = "1"
  end
  description 'Change Gannt for Blagosostoyanie. Files ' + loaded_files

end

