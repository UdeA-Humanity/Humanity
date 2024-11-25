import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:humanity/models/customer.dart' as UserApp;

class FirebaseApi {

  Future<String?> registerCustomer(String emailAddress, String password) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );
      return credential.user?.uid;
    } on FirebaseAuthException catch (e) {
      print("FirebaseAuthException ${e.code}");
      return e.code;
    } on FirebaseException catch (e) {
      print("FirebaseException ${e.code}");
      return e.code;
    }
  }

  Future<String?> signInUser(String emailAddress, String password) async {
    try {
      final credential =
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );
      return credential.user?.uid;
    } on FirebaseAuthException catch (e) {
      print("FirebaseAuthException ${e.code}");
      return e.code;
    } on FirebaseException catch (e) {
      print("FirebaseException ${e.code}");
      return e.code;
    }
  }

  Future<String> createCustomerDB(UserApp.Customer user) async{
    try{
      var db = FirebaseFirestore.instance;
      final document = await db.collection('customers').doc(user.uid).set(user.toJson());
      return user.uid;
    } on FirebaseException catch (e) {
      print("FirebaseException ${e.code}");
      return e.code;
    }
  }

}