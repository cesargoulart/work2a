import 'package:firebase_core/firebase_core.dart';

class FirebaseConfig {
  static Future<void> initializeFirebase() async {
    try {
      await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: "AIzaSyBpQ9HYqZ1grqqLFSIC0gpNdKWgqK5Yar8",
          authDomain: "work-7dc75.firebaseapp.com",
          projectId: "work-7dc75",
          storageBucket: "work-7dc75.firebasestorage.app",
          messagingSenderId: "136855098907",
          appId: "1:136855098907:web:6cfbd00b62251228264abe",
          measurementId: "G-0F61LHF9RV",
          databaseURL: "https://work-7dc75-default-rtdb.europe-west1.firebasedatabase.app"
        ),
      );
      print('Firebase initialized successfully');
    } catch (e) {
      print('Error initializing Firebase: $e');
    }
  }
}