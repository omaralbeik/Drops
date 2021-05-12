Pod::Spec.new do |s|
    s.name = 'Drops'
    s.version = '1.1.0'
    s.summary = 'A µFramework for showing iOS 13 like system alerts'
    s.description = <<-DESC
    A µFramework for showing alerts like the one used when copying from pasteboard or connecting Apple pencil.
    DESC
    s.homepage = 'https://github.com/omaralbeik/Drops'
    s.license = { :type => 'MIT', :file => 'LICENSE' }
    s.social_media_url = 'http://twitter.com/omaralbeik'
    s.documentation_url = 'https://omaralbeik.github.io/Drops'
    s.authors = { 'Omar Albeik' => 'https://twitter.com/omaralbeik' }
    s.module_name  = 'Drops'
    s.source = { :git => 'https://github.com/omaralbeik/Drops.git', :tag => s.version }
    s.source_files = 'Sources/**/*.swift'
    s.swift_versions = ['5.1', '5.2', '5.3']
    s.requires_arc = true
    s.ios.deployment_target = '10.0'
end
