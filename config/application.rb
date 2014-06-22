_root = File.join(File.dirname(__FILE__), "..")

#
# This file loads all dependencies required by application
#


require File.join(_root, "lib", "app_configuration")
require File.join(_root, "lib", "search_form")
require File.join(_root, "lib", "sponsor_pay")

require File.join(_root, "config", "boot")

require File.join(_root, "lib", "tamarama_app")
