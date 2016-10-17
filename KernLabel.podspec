Pod::Spec.new do |s|
  s.name          = "KernLabel"
  s.version       = "0.5.0"
  s.summary       = "KernLabel is a UILabel replacement to show mainly Japanese texts kerning applied for readability."
  s.homepage      = "https://github.com/ikait/KernLabel"
  s.screenshots   = [ "https://raw.githubusercontent.com/ikait/KernLabel/master/images/sample1.png" ]
  s.license       = { :type => 'MIT', :file => 'LICENSE' }
  s.author        = { "Taishi Ikai" => "m@ikai.tokyo" }
  s.platform      = :ios, "8.0"
  s.source        = { :git => "https://github.com/ikait/KernLabel.git", :tag => "#{s.version}" }
  s.source_files  = "KernLabel/KernLabel/**/*.{h,swift}"
  s.requires_arc  = true
end
