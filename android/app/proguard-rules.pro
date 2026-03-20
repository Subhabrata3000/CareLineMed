# Keep the SplitCompatApplication class
-keep class com.google.android.play.core.splitcompat.SplitCompatApplication { *; }

# Keep OkHttp classes used by gRPC
-keep class com.squareup.okhttp.CipherSuite { *; }
-keep class com.squareup.okhttp.ConnectionSpec { *; }
-keep class com.squareup.okhttp.TlsVersion { *; }

# Keep java.lang.reflect.AnnotatedType
-keep class java.lang.reflect.AnnotatedType { *; }

# Keep Google Guava reflection
-keep class com.google.common.reflect.Invokable$ConstructorInvokable { *; }

# Keep JavascriptInterface methods
-keepclassmembers class * {
    @android.webkit.JavascriptInterface <methods>;
}
-keepattributes JavascriptInterface
-keepattributes *Annotation*

# Razorpay SDK related rules
-dontwarn com.razorpay.**
-keep class com.razorpay.** {*;}

# Disable method inlining optimizations
-optimizations !method/inlining/*

# Keep payment-related methods
-keepclasseswithmembers class * {
    public void onPayment*(...);
}

# Preserve Firebase-related methods (if using Firebase)
-dontwarn com.google.firebase.**
-keep class com.google.firebase.** {*;}
-keep class com.google.android.gms.** {*;}
-dontwarn com.google.android.gms.**

# Rules for Flutter's generated code (if needed)
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-dontwarn io.flutter.embedding.**
-dontwarn io.flutter.plugin.common.**
-dontwarn io.flutter.plugin.platform.**

# General Android ProGuard rules
-keep class * extends android.app.Activity
-keepclassmembers class * extends android.app.Activity {
    public void *(...);
}

# Preserve enums
-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}

# General ProGuard optimizations
-dontshrink
-dontoptimize
-dontobfuscate
