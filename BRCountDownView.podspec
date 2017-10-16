#
# Be sure to run `pod lib lint BRCountDownView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
s.name             = 'BRCountDownView'
s.version          = '0.1.0'
s.summary          = 'BRCountDownView is count-down animated UI Components'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

s.description      = "description : BRCountDownView is count-down animated UI Components"

s.homepage         = 'https://github.com/boraseoksoon/BRCountDownView'

s.license          = { :type => 'Apache License 2.0', :file => 'LICENSE' }
s.author           = { 'boraseoksoon@gmail.com' => 'boraseoksoon@gmail.com' }
s.source           = { :git => 'https://github.com/boraseoksoon/BRCountDownView.git', :tag => s.version.to_s }

s.ios.deployment_target = '9.0'

s.source_files = 'BRCountDownView/Classes/**/*'

# s.resource_bundles = {
#  'BRCountDownView' => ['BRCountDownView/Assets/*.png']
#}

# s.public_header_files = 'Pod/Classes/**/*.h'
s.frameworks = 'UIKit'

end
