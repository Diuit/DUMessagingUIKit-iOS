Pod::Spec.new do |s|

  s.name         = "DUMessagingUIKit"
  s.version      = "0.1.1"
  s.summary      = "An easy way to build a chat app within seconds"
  s.homepage     = "http://api.diuit.com/"

  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author             = { "Pofat Tseng" => "pofattseng@diuit.com" }

  s.platform     = :ios, "8.0"

  s.source       = { :git => "https://github.com/Diuit/DUMessagingUIKit-iOS.git", :tag => s.version }

  s.source_files  = 'DUMessagingUIKit/*.swift'

  s.requires_arc = true

  s.dependency "DTTableViewManager", "~> 4.7.0"
  s.dependency "DUMessaging", "~> 1.1.8"
  s.dependency "URLEmbeddedView", "~> 0.4.0"

end
