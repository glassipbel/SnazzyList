# `pod lib lint SnazzyList.podspec'

Pod::Spec.new do |s|
  s.name             = 'SnazzyList'
  s.version          = '1.0.1'
  s.summary          = 'A short description of SnazzyList.'
  
# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  TODO: Add long description of the pod here.
                       DESC
  s.homepage         = 'https://github.com/kbelter/SnazzyList'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'Apache-2.0', :file => 'LICENSE' }
  s.author           = { 'Kevin Belter' => 'kevin.belter@outlook.com' }
  s.source           = { :git => 'https://github.com/kbelter/SnazzyList.git', :tag => s.version.to_s }
  s.ios.deployment_target = '11.0'
  s.swift_versions = '5.0'
  s.source_files = 'SnazzyList/Classes/**/*'
  s.frameworks = 'UIKit'
  s.dependency 'SnazzyAccessibility', '0.1.4'
  s.dependency 'SwiftLint'
end
