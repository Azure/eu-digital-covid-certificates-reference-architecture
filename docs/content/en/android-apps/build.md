---
title: "Build"
linkTitle: "Build"
weight: 10
description: >
    Description of how to build the Android Apps
---

### Prerequisites
* Java JDK. The app has been sucessfully build with JDK 8 and JDK 11, but other later versions should also build the app correctly. We will be also use the keytool from Java JDK to generate the signing certificates for testing.
* [Android SDK](https://developer.android.com/studio) required to compress and align the aplication to apk format. Android studio must be started at least once, so it downloads all the additional build tools. 
* Apk signing certificates.


### Android Wallet Build
Android Wallet app, can be downloaded from [TODO](), and introduce the URL and the certificates at runtime,  but it is also possible to build it.
The source code for the wallet app, can be found in the git repository: git@ssh.dev.azure.com:v3/PE-COE/EU-Digital-Green-Certificate/dgca-wallet-app-android.
The app, depends on another packages of the same project, which needs to be cloned/downloaded before attempting to run the build. The three repositories, wallet app, and the two depencendies listed below, needs to be placed under the same folder structure.
* app-core-android git@ssh.dev.azure.com:v3/PE-COE/EU-Digital-Green-Certificate/dgca-app-core-android
* dgc-certlogic-android git@ssh.dev.azure.com:v3/PE-COE/EU-Digital-Green-Certificate/dgc-certlogic-android


## Build
```bash
#Update the paths and versions to your specific platform and installation, MAC os and android SDK have been successfully tested.
export ANDROID_SDK_VERSION="31.0.0"
export ANDROID_BUILD_TOOLS_PATH=~/"Library/Android/sdk/build-tools/$ANDROID_SDK_VERSION"

git clone git@ssh.dev.azure.com:v3/PE-COE/EU-Digital-Green-Certificate/dgca-wallet-app-android
git clone git@ssh.dev.azure.com:v3/PE-COE/EU-Digital-Green-Certificate/dgca-app-core-android
git clone git@ssh.dev.azure.com:v3/PE-COE/EU-Digital-Green-Certificate/dgc-certlogic-android
pushd dgca-wallet-app-android

./gradlew --no-daemon build
${ANDROID_BUILD_TOOLS_PATH}/zipalign -v 4 app/build/outputs/apk/acc/release/app-acc-release-unsigned.apk app/build/outputs/apk/acc/release/app-acc-release-zipaligned.apk

#Generate the certs to sign the applicaion
keytool -genkeypair -alias dgca-wallet-sign-cert -keypass dgca-wallet-sign-cert -keystore dgca-wallet-sign-cert.jks -storepass dgca-wallet-sign-cert

#Sign the apk with the certificate created in the pre-requisites.
${ANDROID_BUILD_TOOLS_PATH}/apksigner sign --ks ./dgca-wallet-sign-cert.jks --ks-pass pass:dgca-wallet-sign-cert --ks-key-alias dgca-wallet-sign-cert --key-pass pass:dgca-wallet-sign-cert --verbose ./app/build/outputs/apk/acc/release/app-acc-release-zipaligned.apk
popd
```


### Android Verifier Build
Similarly to the wallet app, it can be downloaded from [TODO](), in order to build it yourself, you can follow the script below.

```bash
#Update the paths and versions to your specific platform and installation, MAC os and android SDK have been successfully tested.
export ANDROID_SDK_VERSION="31.0.0"
export ANDROID_BUILD_TOOLS_PATH=~/"Library/Android/sdk/build-tools/$ANDROID_SDK_VERSION"

git clone git@ssh.dev.azure.com:v3/PE-COE/EU-Digital-Green-Certificate/dgca-verifier-app-android
git clone git@ssh.dev.azure.com:v3/PE-COE/EU-Digital-Green-Certificate/dgca-app-core-android
git clone git@ssh.dev.azure.com:v3/PE-COE/EU-Digital-Green-Certificate/dgc-certlogic-android

pushd dgca-verifier-app-android
./gradlew --no-daemon build

${ANDROID_BUILD_TOOLS_PATH}/zipalign -v 4 app/build/outputs/apk/acc/release/app-acc-release-unsigned.apk app/build/outputs/apk/acc/release/app-acc-release-zipaligned.apk

#Generate the certs to sign the applicaion
keytool -genkeypair -alias dgca-verifier-sign-cert -keypass dgca-verifier-sign-cert -keystore dgca-verifier-sign-cert.jks -storepass dgca-verifier-sign-cert

#Sign the apk with the certificate created in the pre-requisites.
${ANDROID_BUILD_TOOLS_PATH}/apksigner sign --ks ./dgca-verifier-sign-cert.jks --ks-pass pass:dgca-verifier-sign-cert --ks-key-alias dgca-verifier-sign-cert --key-pass pass:dgca-verifier-sign-cert --verbose app/build/outputs/apk/acc/release/app-acc-release-zipaligned.apk
```
