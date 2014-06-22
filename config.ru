require File.join(File.dirname(__FILE__), "config", "application")

map "/" do
  run TamaramaApp
end
