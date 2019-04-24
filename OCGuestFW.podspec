#
# Be sure to run `pod lib lint OCGuestFW.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name            = 'OCGuestFW'
  s.version         = '2.0.2'
  s.summary         = 'Open readers with your iOS device'
  s.homepage        = 'http://www.cloudhospitality.com/es/'
  s.license         = {
      :type => 'Copyright',
      :text => <<-LICENSE
      Copyright 2019 Cloud Hospitality S.L.. All rights reserved.
      LICENSE
  }
  s.author          = { 'Cloud Hospitality S.L.' => 'support@cloudhospitality.com' }
  s.source = { :git => 'https://github.com/PrestigeApps/OCGuestFW.git', :tag => '2.0.2'}
  
  s.platform     = :ios, '10.0'
  s.ios.deployment_target = '10.0'
  s.ios.frameworks = 'Foundation', 'CoreTelephony', 'Security', 'CoreLocation', 'CoreBluetooth', 'CoreMotion', 'UIKit', 'SystemConfiguration', 'LocalAuthentication'
  s.source_files = 'OCGuestFW/Classes/**/*'
  
  s.module_name = 'OCGuestFW'
 
  s.requires_arc = true
  
  s.vendored_frameworks = ['SeosMobileKeysSDK.framework', 'SaltoJustINMobile.framework']
 
  s.dependency 'JSONModel', '~> 1.7.0'
  s.dependency 'CocoaLumberjack', '~> 3.2.1'
  s.dependency 'Mixpanel', '~> 3.3.3'
  s.dependency 'BerTlv', '~> 0.2.3'
  s.resource = 'Resources/OCGuestFW'
  s.resources = ['OCGuestFW/Assets/*.*']
  
end
