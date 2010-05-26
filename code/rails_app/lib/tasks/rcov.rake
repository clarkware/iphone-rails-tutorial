namespace :test do
  
  desc 'Tracks test coverage with rcov'
  task :coverage do
    rm_f "coverage"
    rm_f "coverage.data"
    
    unless PLATFORM['i386-mswin32']
      rcov = "rcov --sort coverage --rails --aggregate coverage.data " +
             "--text-summary -Itest -T -x \" rubygems/*,/Library/Ruby/Site/*,gems/*,rcov*\""
    else
      rcov = "rcov.cmd --sort coverage --rails --aggregate coverage.data " +
             "--text-summary -Itest -T"
    end
    
    system("#{rcov} --no-html test/unit/*_test.rb")
    system("#{rcov} --no-html test/functional/*_test.rb")
    system("#{rcov} --html test/integration/*_test.rb")
    
    unless PLATFORM['i386-mswin32']
      system("open coverage/index.html") if PLATFORM['darwin']
    else
      system("\"C:/Program Files/Mozilla Firefox/firefox.exe\" " +
             "coverage/index.html")
    end
  end
  
end