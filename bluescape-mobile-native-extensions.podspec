require "json"

package = JSON.parse(File.read(File.join(__dir__, "package.json")))

Pod::Spec.new do |s|
  s.name         = "bluescape-mobile-native-extensions"
  s.version      = package["version"]
  s.summary      = package["description"]
  s.description  = <<-DESC
                  bluescape-mobile-native-extensions
                   DESC
  s.homepage     = "https://github.com/leah-bluescape/bluescape-mobile-native-extensions"
  s.license      = "MIT"
  # s.license    = { :type => "MIT", :file => "FILE_LICENSE" }
  s.authors      = { "Leah Xia" => "leah.xia@bluescape.com" }
  s.platforms    = { :ios => "9.0", :tvos => "10.0" }
  s.source       = { :git => "https://github.com/leah-bluescape/bluescape-mobile-native-extensions.git", :tag => "#{s.version}" }

  s.source_files = "ios/**/*.{h,m,swift}"
  s.requires_arc = true

  s.dependency "React"
	
  # s.dependency "..."
end

