target 'WorkoutLog' do
  
  use_frameworks!

  pod 'DZNEmptyDataSet'

  pod 'RxSwift', '3.0.0-rc.1'
  pod 'RxCocoa', '3.0.0-rc.1'
  pod 'RealmSwift'

  target 'WorkoutLogTests' do
    inherit! :search_paths
  end

  target 'WorkoutLogUITests' do
    inherit! :search_paths
  end

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '3.0'
      config.build_settings['MACOSX_DEPLOYMENT_TARGET'] = '10.10'
    end
  end
end 
