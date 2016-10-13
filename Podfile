platform :ios, '8.0'

def swift3_overrides
    pod 'Kanna', git: 'https://github.com/tid-kijyun/Kanna.git', branch: 'swift3.0'
end

target 'DUMessagingUIKit' do
    use_frameworks!
    swift3_overrides
    pod 'DUMessaging'
    pod 'DTTableViewManager', '~> 5.0.0-beta.1'
    pod 'URLEmbeddedView', :git => 'https://github.com/marty-suzuki/URLEmbeddedView.git', :tag => '0.6.0'
end

target 'DUMessagingDemo' do
    use_frameworks!
    swift3_overrides
    pod 'DUMessaging'
    pod 'DTTableViewManager', '~> 5.0.0-beta.1'
    pod 'URLEmbeddedView', :git => 'https://github.com/marty-suzuki/URLEmbeddedView.git', :tag => '0.6.0'
end
