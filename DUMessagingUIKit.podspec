Pod::Spec.new do |s|

  s.name         = "DUMessagingUIKit"
  s.version      = "0.2.0"
  s.summary      = "All UI elements you need to build an instant message app"
  s.homepage     = "http://api.diuit.com/"

  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author             = { "Pofat Tseng" => "pofattseng@diuit.com" }

  s.platform     = :ios, "8.0"

  s.source       = { :git => "https://github.com/Diuit/DUMessagingUIKit-iOS.git", :tag => s.version }

  s.source_files  = 'DUMessagingUIKit/*.swift'
  s.resources = ['DUMessagingUIKit/*.{xib}', 'DUMessagingUIKit/*.xcassets']

  s.requires_arc = true

  s.dependency "DTTableViewManager", "~> 5.0.0-beta.1"
  s.dependency "DUMessaging", "~> 2.0.1"
  s.dependency "URLEmbeddedView"

end
