
import 'package:flutter/foundation.dart';

/// enable/disable logging
class QuranLogger {

   static void log(String message) {
      if(kDebugMode) {
         print(message);
      }
   }

   static void logE(Object exception) {
     if(kDebugMode) {
       print(exception);
     }
   }
}