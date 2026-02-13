# Google Sign-In
-keep class com.google.android.gms.** { *; }
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.auth.api.signin.** { *; }
-keep class com.google.android.gms.common.api.** { *; }

# Firebase
-keep class com.google.firebase.auth.** { *; }
-keep class com.google.firebase.firestore.** { *; }

# Prevent obfuscation of Google Play Services
-dontwarn com.google.android.gms.**
-dontwarn com.google.firebase.**