Pod::Spec.new do |s|
s.name = 'DUMessagingUIKit'
s.version = '0.1.0'
s.summary = 'An easy way to build a chat app UI for iOS'
s.homepage = 'http://api.diuit.com/'
s.license = 'MIT'
s.platform = :ios, '8.0'

s.author = 'Pofat Tseng'
s.social_media_url = 'https://www.facebook.com/Diuit-364831183708819/'




s.source = { :git => 'https://github.com/Diuit/DUMessagingUIKit-iOS', :tag => s.version }
s.source_files = "DUMessagingUIKit", "DUMessagingUIKit.framework/Headers/*.{h}"

s.frameworks = 'DUMessagingUIKit'
s.requires_arc = true

s.dependency 'DTTableViewManager', '~> 4.7.0'
end
