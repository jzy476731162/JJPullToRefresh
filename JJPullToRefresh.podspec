Pod::Spec.new do |s|
s.name             = 'JJPullToRefresh'
s.version          = '0.0.1'
s.summary          = 'A pull-to-refresh component.'

s.description      = <<-DESC
A pull-to-refresh component which can customize animation based on states.
DESC

s.homepage         = 'https://github.com/zty0/JJPullToRefresh'

s.license          = { :type => 'AGPL-3.0', :file => 'LICENSE' }
s.author           = { 'jox' => 'jox.jeong@icloud.com' }
s.source           = { :git  => 'git@github.com:zty0/JJPullToRefresh.git', :tag => "0.0.1" }

s.platform         = :ios
s.ios.deployment_target = '7.0'

s.source_files = 'JJPullToRefresh/*.{h,m}'
s.public_header_files = 'JJPullToRefresh/*.h'

s.resource_bundles = {
  'JJPullToRefresh' => ['JJPullToRefresh/*.{storyboard,xib,xcassets,json,imageset,png}']
}

s.frameworks = 'UIKit'
end

