#
#  Be sure to run `pod spec lint TSUtility.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "TSUtility"
  s.version      = "0.0.1"
  s.summary      = "A short description of TSUtility."

  s.description  = <<-DESC
                   DESC

  s.homepage     = "http://EXAMPLE/TSUtility"

  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author             = { "yuchenH" => "huangyuchen@caiqr.com" }
 
  s.source       = { :git => "http://EXAMPLE/TSUtility.git", :tag => 1.0.0 }

  s.source_files  = "source/*", "DevelopDocument.swift"
  s.exclude_files = "Classes/Exclude"

end
