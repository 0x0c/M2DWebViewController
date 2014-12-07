#
# Be sure to run `pod lib lint M2DWebViewController.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "M2DWebViewController"
  s.version          = "0.1.4"
  s.summary          = "Simple built-in web view controller."
  s.homepage         = "https://github.com/0x0c/M2DWebViewController"
  s.license          = 'MIT'
  s.author           = { "Akira Matsuda" => "akira.m.itachi@gmail.com" }
  s.source           = { :git => "https://github.com/0x0c/M2DWebViewController.git", :tag => s.version.to_s }
  s.screenshots     = "https://raw.github.com/0x0c/M2DWebViewController/master/images/1.png", "https://raw.github.com/0x0c/M2DWebViewController/master/images/2.png", "https://raw.github.com/0x0c/M2DWebViewController/master/images/3.png"

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*.{h,m}'

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'WebKit'
end
