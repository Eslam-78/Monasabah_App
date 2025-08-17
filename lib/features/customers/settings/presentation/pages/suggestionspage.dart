import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:monasbah/core/app_theme.dart';

import 'package:monasbah/core/widgets/Texts/SubTitleText.dart';

class SuggestionsPage extends StatefulWidget {
  @override
  State<SuggestionsPage> createState() => _SuggestionsPageState();
}

class _SuggestionsPageState extends State<SuggestionsPage> {
  late String suggestion;
  File? galleryImage;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                  'assets/images/background.jpg',
                ),
                fit: BoxFit.cover),
          ),
          child: Column(
            textDirection: TextDirection.rtl,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ///start image
              GestureDetector(
                child: Center(
                  child: Container(
                    height: 150,
                    width: 150,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(50)),
                    child: ClipOval(
                      child: galleryImage != null
                          ? ClipOval(
                              child: Image.file(
                                galleryImage!,
                                height: 160,
                                width: 160,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Container(
                              color: AppTheme.primarySwatch.shade400,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.camera_alt_outlined,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  SubTitleText(
                                    text: 'اضف صوره إن وجد',
                                    textColor: Colors.white,
                                    fontSize: 15,
                                  )
                                ],
                              ),
                            ),
                    ),
                  ),
                ),
                onTap: () async {
                  FilePickerResult? result =
                      await FilePicker.platform.pickFiles();

                  if (result != null) {
                    setState(() {
                      galleryImage = File(result.files.single.path ?? '');
                    });
                  } else {
                    // User canceled the picker
                  }
                },
              ),

              ///end image
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  strutStyle: StrutStyle(height: 1.5),
                  maxLines: 3,
                  maxLength: 250,
                  decoration: InputDecoration(
                    border: new OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(10.0),
                      ),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.all(12.0),
                    hintText: "اترك أي ملاحظة إضافية تود تركها على الطلب !",
                    labelStyle: AppTheme.textTheme.headline2,
                    hintStyle: AppTheme.textTheme.headline2!
                        .copyWith(color: Colors.grey),
                    fillColor: Colors.white,
                    filled: true,
                    errorStyle: AppTheme.textTheme.headline4,
                  ),
                  style: AppTheme.textTheme.headline2,
                  // The validator receives the text that the user has entered.

                  onChanged: (value) {
                    suggestion = value;
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
