Pod::Spec.new do |s|
s.name             = 'BRCountDownView'
s.version          = '1.0.0'
s.summary          = 'BRCountDownView is count-down animated UI Components'

s.description      = "description : BRCountDownView is count-down animated UI Components"

s.homepage         = 'https://github.com/boraseoksoon/BRCountDownView'

s.license          = { :type => 'MIT', :file => 'LICENSE' }
s.author           = { 'boraseoksoon@gmail.com' => 'boraseoksoon@gmail.com' }
s.source           = { :git => 'https://github.com/boraseoksoon/BRCountDownView.git', :tag => s.version.to_s }

s.ios.deployment_target = '9.0'

s.source_files = 'BRCountDownView/Classes/**/*'

s.resources = "BRCountDownView/Assets/*"

s.frameworks = 'UIKit'

end
