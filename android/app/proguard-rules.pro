# Suppress warnings for missing annotations
-dontwarn proguard.annotation.Keep
-dontwarn proguard.annotation.KeepClassMembers
-keepattributes *Annotation*
-dontwarn com.razorpay.**
-keep class com.razorpay.** {*;}
-optimizations !method/inlining/
-keepclasseswithmembers class * {
  public void onPayment*(...);
}