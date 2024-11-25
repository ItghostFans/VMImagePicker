#
# Be sure to run `pod lib lint VMImagePicker.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'VMImagePicker'
  s.version          = '1.0.0-dev'
  s.summary          = 'A short description of VMImagePicker.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/ItghostFans/VMImagePicker'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'ItghostFans' => 'ItghostFan@163.com' }
  s.source           = { :git => 'https://github.com/ItghostFans/VMImagePicker.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '13.0'

  s.default_subspec = 'Photos'
  s.preserve_paths = '**'
  
  s.subspec 'Localization' do |subspec|
    subspec.source_files = 'VMImagePicker/Classes/Localization/**/*', 'VMImagePicker/Private/Localization/**/*.h'
    subspec.private_header_files = 'VMImagePicker/Private/Localization/**/*.h'
  end
  
  s.subspec 'Photos' do |subspec|
    subspec.source_files = 'VMImagePicker/Classes/Photos/**/*', 'VMImagePicker/Private/Photos/**/*.h'
    subspec.private_header_files = 'VMImagePicker/Private/Photos/**/*.h'
  end
  
  s.subspec 'ViewModel' do |subspec|
    subspec.source_files = 'VMImagePicker/Classes/ViewModel/**/*', 'VMImagePicker/Private/ViewModel/**/*.h'
    subspec.private_header_files = 'VMImagePicker/Private/ViewModel/**/*.h'
    subspec.dependency 'VMImagePicker/Photos'
  end
  
  s.subspec 'UI' do |subspec|
    subspec.source_files = 'VMImagePicker/Classes/UI/**/*', 'VMImagePicker/Private/UI/**/*.h'
    subspec.private_header_files = 'VMImagePicker/Private/UI/**/*.h'
    subspec.resource = 'VMImagePicker/VMImagePicker.bundle'
    subspec.dependency 'VMImagePicker/ViewModel'
    subspec.dependency 'VMImagePicker/Localization'
    subspec.dependency 'Masonry'
    subspec.dependency 'VMLocalization'
  end
  
#   s.resource_bundles = {
#     'VMImagePicker' => ['VMImagePicker/Assets/**/*']
#   }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit', 'Photos', 'AVFoundation', 'CoreMedia', 'QuartzCore'
  # s.dependency 'AFNetworking', '~> 2.3'
  s.dependency 'ViewModel', '~> 1.0.2'
end
