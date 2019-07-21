defineEnvVar ANDROID_STUDIO_VERSION MANDATORY "The Android Studio version" '145.3360264';
defineEnvVar ANDROID_STUDIO_FILENAME MANDATORY "The Android Studio filename" 'android-studio-ide-${ANDROID_STUDIO_VERSION}-linux.zip';
defineEnvVar ANDROID_STUDIO_COMMERCIAL_MAJOR_VERSION MANDATORY "The commercial name of the Android Studio version" '2.2';
defineEnvVar ANDROID_STUDIO_COMMERCIAL_VERSION MANDATORY "The commercial name of the Android Studio version" '2.2.2.0';
overrideEnvVar TAG '${ANDROID_STUDIO_COMMERCIAL_VERSION}';
defineEnvVar ANDROID_STUDIO_URL MANDATORY "The Android Studio url" 'https://dl.google.com/dl/android/studio/ide-zips/${ANDROID_STUDIO_COMMERCIAL_VERSION}/${ANDROID_STUDIO_FILENAME}';
defineEnvVar SERVICE_USER MANDATORY "The service user" "developer";
defineEnvVar SERVICE_GROUP MANDATORY "The service group" "developers";
defineEnvVar BASE_GUI_TAG MANDATORY "The tag of the parent image" "0.11";
# vim: syntax=sh ts=2 sw=2 sts=4 sr noet
