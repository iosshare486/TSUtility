#
#  Be sure to run `pod spec lint TSUtility.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "TSUtility"
  s.version      = "1.0.3"
  s.summary      = "this is utility for scale font and color"

  s.description  = <<-DESC
                  这是一个工具类 包含 比例、文字大小、颜色的适配
                  以及设备信息的获取，这是一个工具类 包含 比例、文字大小、颜色的适配
                  以及设备信息的获取
                   DESC
  s.platform     = :ios, "8.0"
  s.homepage     = "https://baidu.com"

  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author             = { "yuchenH" => "huangyuchen@caiqr.com" }
 
  s.source       = { :git => "http://gitlab.caiqr.com/ios_module/TSUtility.git", :tag => s.version }

  s.source_files  = "TSUtility/source", "TSUtility/DevelopDocument.swift"

  #s.exclude_files = "Classes/Exclude"

  s.framework  = "UIKit","Foundation"

  s.requires_arc = true
end
