#
#  Be sure to run `pod spec lint CSHRadioGroup.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
  s.name         = "CSHRadioGroup"
  s.version      = "0.0.1"
  s.summary      = "You can use CSHRadioGroup for simple table view radio management."
  s.description  = <<-DESC
                       CSHRadioGroup is inspired by nimbus`s NIRadioGroup. You can use it for simple table view radio management.
                   DESC
  s.homepage     = "http://blog.underpinetree.com"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "chengshun" => "chengshun.1990@qq.com" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/shunchengGit/CSHRadioGroup.git", :tag => "0.0.1" }
  s.source_files = "*.{h,m}"
end
