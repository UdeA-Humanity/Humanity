import 'dart:io';

import 'package:flutter/material.dart';
import 'package:humanity/services/select_image.dart';
import 'package:humanity/services/upload_image.dart';

class DescubreScreen extends StatefulWidget {

  const DescubreScreen({super.key});

  @override

  DescubreScreenState createState() => DescubreScreenState();

}

class DescubreScreenState extends State<DescubreScreen> {

  File? image_to_upload;

  @override

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Discover"),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => throw Exception(),
              child: const Text("Throw Test Exception"),
            ),
            const SizedBox(height: 20),
            
            if (image_to_upload != null) 
              Image.file(
              image_to_upload!,
              height: 300,
              width: 400,
              fit: BoxFit.cover,
              )
            else 
              Container(
                margin: const EdgeInsets.all(10),
                height: 300,
                width: 400,
                color: Colors.grey,
                child: const Center(child: Text("No image selected")),
              ),

            const SizedBox(height: 20),

            ElevatedButton(onPressed: () async{

              final imagen = await selectImage();

              setState(() {
                image_to_upload = File(imagen!.path);
              });
            }, child: const Text("Select image")),

            const SizedBox(height: 20),

            ElevatedButton(onPressed: () async{

              if (image_to_upload == null) {
                return;
              }

              final uploaded = await uploadImage(image_to_upload!);

              if (uploaded){
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Imagen subida correctamente")));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Error al subir la imagen")));
              }

            }, child: const Text("Subir a Firebase")),
          ],
        ),
      ),
    );
  }
}
