Pod::Spec.new do |s|
s.name = 'YHPageViewController'
s.version = '1.0.0'
s.license = 'MIT'
s.summary = 'An example of a good film performance.'
s.homepage = 'https://github.com/RabbitHan/YHPageViewController'
s.authors = { 'RabbitHan' => '617584527@qq.com' }
s.source = { :git => 'https://github.com/RabbitHan/YHPageViewController.git', :tag => s.version.to_s }
s.requires_arc = true
s.ios.deployment_target = '9.0'
s.source_files = 'YHPageViewController/*'
s.resources = 'YHPageViewController/*'
end
