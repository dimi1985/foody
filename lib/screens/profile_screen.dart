import 'dart:io';
import 'package:foody/utils/http_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:foody/utils/shared_preference.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  final String? username;
  final String? id;
  final String? email;
  final String? userImage;

  const ProfileScreen({
    super.key,
    this.username,
    this.id,
    this.email,
    this.userImage,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? loggedUserID;
  String? userImage;
  bool isMe = false;
  File mobileImage = File("zz");
  String pickedImagePathName = 'zz';
  Uint8List webImage = Uint8List(10);
  static var baseUrl = defaultTargetPlatform == TargetPlatform.android
      ? Uri.parse(HttpService.mobileUrl)
      : Uri.parse(HttpService.webUrl);

  @override
  void initState() {
    checkIfMe();
    userImage = '$baseUrl${widget.userImage}';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.username ?? 'No username at this time'),
      ),
      body: Center(
        child: Column(
          children: [
            CircleAvatar(
              backgroundColor: Colors.transparent,
              radius: 28,
              backgroundImage: NetworkImage(
                ('$userImage'),
              ),
            ),
            //#################Later USe For Edit####################
            // ClipRRect(
            //   child: mobileImage.path == "zz" || userImage!.isEmpty
            //       ? const Center(
            //           child: Text(
            //             'Please Select an Image',
            //             style: TextStyle(
            //                 color: Colors.grey,
            //                 fontWeight: FontWeight.w600,
            //                 fontSize: 16),
            //           ),
            //         )
            //       : (kIsWeb)
            //           ? Image.memory(webImage)
            //           : Image.file(
            //               mobileImage,
            //               fit: BoxFit.cover,
            //             ),
            // ),
            if (isMe)
              IconButton(
                onPressed: pickImage,
                icon: const Icon(Icons.edit),
              )
          ],
        ),
      ),
    );
  }

  Future checkIfMe() async {
    GlobalSharedPreference.getUserID().then((value) {
      setState(() {
        loggedUserID = value;
      });
      if (loggedUserID == widget.id) {
        setState(() {
          isMe = true;
        });
      }
    });
  }

  pickImage() async {
    // MOBILE
    if (!kIsWeb) {
      final ImagePicker picker = ImagePicker();
      XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        var selected = File(image.path);

        setState(() {
          mobileImage = selected;
        });
      } else {
        //Something went wrong
      }
    }
    // WEB
    else if (kIsWeb) {
      final ImagePicker picker = ImagePicker();
      XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        var f = await image.readAsBytes();
        setState(() {
          mobileImage = File(image.path);
          webImage = f;
          pickedImagePathName = image.path;
          HttpService.updateUserImageWeb(webImage);
        });
      } else {
        //Something went wrong
      }
    }
  }
}
