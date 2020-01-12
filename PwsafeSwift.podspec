Pod::Spec.new do |s|
  s.name = 'PwsafeSwift'
  s.version = '0.0.1'
  s.license = 'MIT'
  s.summary = 'Pwsafe parsing library written (mostly) in swift language.'
  s.homepage = 'https://github.com/antvs/PwsafeSwift'
  s.authors = { 'Anton Selyanin' => 'anton.selyanin@gmail.com' }
  s.social_media_url = 'http://twitter.com/antonthisone'
  s.source = { :git => 'https://github.com/antonselyanin/pwsafe', :tag => '0.0.1' }

  s.ios.deployment_target = '8.0'
  # s.osx.deployment_target = '10.10'

  s.source_files = 'PwsafeSwift/**/**.swift', 'PwsafeSwift/PwsafeSwift.h'

  s.requires_arc = true
end