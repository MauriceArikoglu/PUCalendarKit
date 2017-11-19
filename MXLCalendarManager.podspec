Pod::Spec.new do |spec|
  spec.platform = :ios
  spec.name         = 'PUCalendarKit'
  spec.version      = '1.0.0'
  spec.license      = { :type => 'MIT' }
  spec.homepage     = 'https://github.com/MauriceArikoglu/PUCalendarManager'
  spec.authors      = { 'Maurice Arikoglu' => 'development@mauricearikoglu.de' }
  spec.summary      = 'A set of classes used to parse and handle iCalendar (.ICS) files'
  spec.source       = { :git => 'https://github.com/MauriceArikoglu/PUCalendarManager.git', :tag => '1.0.0' }
  spec.source_files = 'PUCalendarKit/*.{h,m}'
  spec.frameworks = 'UIKit', 'Foundation'
  spec.requires_arc = true
end
