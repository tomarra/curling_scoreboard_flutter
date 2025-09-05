import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class FirebaseService {
  FirebaseService();

  var db = FirebaseFirestore.instance;

  Future<void> doAnonymousLogin() async {
    try {
      final userCredential = await FirebaseAuth.instance.signInAnonymously();
      print("Signed in with temporary account.");
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "operation-not-allowed":
          print("Anonymous auth hasn't been enabled for this project.");
          break;
        default:
          print("Unknown error.");
      }
    }
  }

  void getClubsList() {
    db.collection("clubs").get().then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        print(doc["name"]);
      }
    });
  }
}
