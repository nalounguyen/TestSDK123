
# 0. clean build directories
rm -rf   derived_data   ${PROJECT_NAME}.framework

# 1.1 Build framework for simulator
xcodebuild build -workspace ${PROJECT_NAME}.xcworkspace -scheme ${PROJECT_NAME} -configuration Release -derivedDataPath derived_data -arch x86_64 -sdk iphonesimulator

# 1.1 Build framework for iOS devices
xcodebuild build -workspace ${PROJECT_NAME}.xcworkspace -scheme ${PROJECT_NAME} -configuration Release -derivedDataPath derived_data -arch arm64 -sdk iphoneos
# 2. Create framework
mkdir CredifyKit.framework/


# 3. Create binary compatible with devices and simulators
lipo -create   derived_data/Build/Products/Release-iphoneos/CredifyKit.framework/CredifyKit   derived_data/Build/Products/Release-iphonesimulator/CredifyKit.framework/CredifyKit   -o CredifyKit.framework/CredifyKit

# 4.1 Create empty public interface directory
mkdir CredifyKit.framework/CredifyKit.swiftmodule
# 4.2 Copy public interfaces for device and simulators into static framework public interfaces directory
cp -r derived_data/Build/Products/*/CredifyKit.framework/Modules/${PROJECT_NAME}.swiftmodule/* CredifyKit.framework/CredifyKit.swiftmodule









