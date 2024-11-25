import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

final FirebaseStorage storage = FirebaseStorage.instance;

Future<String> uploadImageAndGetUrl(File image) async {
  try {
    final String fileName = basename(image.path);
    final Reference ref = storage.ref().child('images/$fileName');
    final UploadTask uploadTask = ref.putFile(image);

    final TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => true);
    if (taskSnapshot.state == TaskState.success) {
      return await taskSnapshot.ref.getDownloadURL();
    }
  } catch (e) {
    print("Image upload failed: $e");
  }
  return '';
}

Future<bool> uploadImage(File image) async {
  print(image.path);
  // try {
    final String fileName = basename(image.path);
    final Reference ref = storage.ref().child('images/$fileName');
    final UploadTask uploadTask = ref.putFile(image);
    print(uploadTask);

    final TaskSnapshot taskSnapshot = await uploadTask.whenComplete(()=> true); 

    print(taskSnapshot);

    final String url = await taskSnapshot.ref.getDownloadURL();
    print('URL: $url');

    if (taskSnapshot.state == TaskState.success) {
      return true;
    } else {
      return false;
    }

    // await ref.putFile(image);
    // return true;


  // } catch (e) {
  //   print(e);
  //   return false;
  // }
}

String basename(String path) {
  final int index = path.lastIndexOf('/');
  return path.substring(index + 1);
}