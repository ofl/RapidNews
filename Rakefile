# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")

require 'motion/project/template/ios'
require 'bundler'
Bundler.require
require 'rubygems'
require 'motion-cocoapods'

Motion::Project::App.setup do |app|
  app.name = 'RapidNews'
  app.version = "1.0.0"
  app.short_version = "1.0.0"
  app.deployment_target = "7.1"
  app.device_family = [:iphone]
  app.interface_orientations = [:portrait]
  app.identifier = "jp.covered.rapidnews"
  app.info_plist['CFBundleURLTypes'] = [
    { 'CFBundleURLName' => "jp.covered.rapidnews", 'CFBundleURLSchemes' => ['rapidnews'] },
    { 'CFBundleURLName' => 'com.getpocket.sdk', 'CFBundleURLSchemes' => ['pocketapp17764']},
  ]
  app.my_env.file = 'Resources/yaml/environment.yaml'
  app.fonts = ["ionicons.ttf"]

  app.libs += ['/usr/lib/libsqlite3.dylib']
  app.frameworks += %w(Security SafariServices MessageUI MapKit QuartzCore ImageIO)

  # app.files_dependencies 'app/models/channel.rb' => 'app/lib/util/model.rb'

  app.pods do
    pod 'FlurrySDK'
    pod "AFNetworking", "~> 2.0"
    # pod 'HatenaBookmarkSDK'
    pod 'XMLReader'
    pod 'PocketAPI', :git => 'git@github.com:naoya/Pocket-ObjC-SDK.git', :branch => 'cocoapods-dependency'
    pod 'TUSafariActivity'
    pod 'SVProgressHUD'
    pod 'FXReachability'
    pod 'KNSemiModalViewController'
    pod 'JMImageCache'
  end

  app.entitlements['keychain-access-groups'] = [app.seed_id + '.' + app.identifier]

  app.development do
    app.entitlements['get-task-allow'] = true
    app.codesign_certificate='iPhone Developer: Shin Morichika (PVVSR9FPL7)'
    app.provisioning_profile = "./Provisioning/RapidNewsDev.mobileprovision"
  end

  app.release do
    app.entitlements['get-task-allow'] = false
    app.codesign_certificate='iPhone Developer: Shin Morichika (PVVSR9FPL7)'
    app.provisioning_profile = "./Provisioning/RapidNewsDev.mobileprovision"
  end
end

desc "Open latest crash log"
task :log do
  app = Motion::Project::App.config
  exec "less '#{Dir[File.join(ENV['HOME'], "/Library/Logs/DiagnosticReports/#{app.name}*")].last}'"
end
