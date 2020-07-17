#
#  Be sure to run `pod spec lint RQMediator.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
  s.name             = 'RQMediator'
  s.version          = '1.0.0'
  s.summary          = 'iOS组件化方案'
  s.description      = 'RQMediator组件化解耦方案'

  s.homepage         = 'https://github.com/CoderXie/RQMediator'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'CoderXie' => '1173044198@qq.com' }
  s.source           = { :git => 'https://github.com/CoderXie/RQMediator.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'
  s.requires_arc = true
  s.source_files = 'RQMediator/RQMediator/RQMediator.{h,m}'

end
