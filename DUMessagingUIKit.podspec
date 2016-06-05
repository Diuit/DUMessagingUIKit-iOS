Pod::Spec.new do |s|

  s.name         = "DUMessagingUIKit"
  s.version      = "0.1.0"
  s.summary      = "An easy way to build a chat app within seconds"
  s.homepage     = "http://api.diuit.com/"

  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author             = { "Pofat Tseng" => "pofattseng@diuit.com" }

  s.platform     = :ios, "8.0"

  s.source       = { :git => "http://EXAMPLE/DUMessagingUIKit-iOS.git" }

  s.source_files  = 'DUMessagingUIKit/*.swift'

  # s.framework  = "SomeFramework"
  # s.frameworks = "SomeFramework", "AnotherFramework"

  # s.library   = "iconv"
  # s.libraries = "iconv", "xml2"


  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If your library depends on compiler flags you can set them in the xcconfig hash
  #  where they will only apply to your library. If you depend on other Podspecs
  #  you can include multiple dependencies to ensure it works.

  s.requires_arc = true

  s.dependency "DTTableViewManager", "~> 4.7.0"

end
