# 0. clean build directories
rm -rf   derived_data   CredifyCore.framework
# 1.1 Build static library for simulator
xcodebuild build -workspace ${PROJECT_NAME}.xcworkspace -scheme CredifyCore   -derivedDataPath derived_data   -arch x86_64   -sdk iphonesimulator SKIP_INSTALL=NO BUILD_LIBRARIES_FOR_DISTRIBUTION=YES
# 1.2 Build static library for iOS devices
xcodebuild build -workspace ${PROJECT_NAME}.xcworkspace -scheme CredifyCore   -derivedDataPath derived_data   -arch arm64   -sdk iphoneos SKIP_INSTALL=NO BUILD_LIBRARIES_FOR_DISTRIBUTION=YES
# 2. Create framework
mkdir CredifyCore.framework/
# 3. Create binary compatible with devices and simulators
lipo -create   derived_data/Build/Products/Debug-iphoneos/libCredifyCore.a   derived_data/Build/Products/Debug-iphonesimulator/libCredifyCore.a   -o CredifyCore.framework/CredifyCore
# 4.1 Create empty public interface directory
mkdir CredifyCore.framework/CredifyCore.swiftmodule
# 4.2 Copy public interfaces for device and simulators into static framework public interfaces directory
cp -r derived_data/Build/Products/*/*.swiftmodule/* CredifyCore.framework/CredifyCore.swiftmodule
