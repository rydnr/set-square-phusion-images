defineEnvVar ANDROID_STUDIO_VERSION "The Android Studio version" '145.3360264';
defineEnvVar ANDROID_STUDIO_FILENAME "The Android Studio filename" 'android-studio-ide-${ANDROID_STUDIO_VERSION}-linux.zip';
defineEnvVar ANDROID_STUDIO_COMMERCIAL_MAJOR_VERSION "The commercial name of the Android Studio version" '2.2';
defineEnvVar ANDROID_STUDIO_COMMERCIAL_VERSION "The commercial name of the Android Studio version" '2.2.2.0';
overrideEnvVar TAG '${ANDROID_STUDIO_COMMERCIAL_VERSION}';
defineEnvVar ANDROID_STUDIO_URL "The Android Studio url" 'https://dl.google.com/dl/android/studio/ide-zips/${ANDROID_STUDIO_COMMERCIAL_VERSION}/${ANDROID_STUDIO_FILENAME}';
defineEnvVar SERVICE_USER "The service user" "developer";
defineEnvVar SERVICE_GROUP "The service group" "developers";
defineEnvVar BASE_GUI_TAG "The tag of the parent image" "201611";
