import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monasbah/core/widgets/Buttons/primaryButton.dart';

import '../../../../../../core/app_theme.dart';
import '../../../../../../core/others/MyFlashBar.dart';
import '../../../../../../core/widgets/Texts/SubTitleText.dart';
import '../ServiceProviderMainHome.dart';
import '../../../../../customers/services/presentation/manager/services/servicesBloc.dart';
import '../../../../../customers/services/presentation/manager/services/servicesEvent.dart';
import '../../../../../customers/services/presentation/manager/services/servicesState.dart';
import '../../../../../../injection_container.dart';

class AddNewServiceImagePage extends StatefulWidget {

  String id;

  AddNewServiceImagePage({required this.id});

  @override
  State<AddNewServiceImagePage> createState() => _AddNewServiceImagePageState();
}

class _AddNewServiceImagePageState extends State<AddNewServiceImagePage> {
  File? galleryImage;
  bool requestPending = false;
  String image = '';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ServicesBloc>(),
      child: BlocConsumer<ServicesBloc, ServicesState>(
        listener: (_context, state) {
          if (state is Loaded) {
            setState(() {
              requestPending = false;
            });
            MyFlashBar(
                title: 'تم',
                context: context,
                icon: Icons.check,
                iconColor: Colors.white,
                backgroundColor: Colors.green,
                message: state.message,
                thenDo: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                    return ServiceProviderMainHomeRoute(currentIndex: 1);
                  }));
                }).showFlashBar();
          } else if (state is Error) {
            setState(() {
              requestPending = false;
            });
            MyFlashBar(
                title: 'خطأ',
                context: context,
                icon: Icons.error,
                iconColor: Colors.white,
                backgroundColor: Colors.red,
                message: state.errorMessage,
                thenDo: () {

                }).showFlashBar();
          }
        },
        builder: (_context, state) {
          return Column(
            textDirection: TextDirection.rtl,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 10,),
              GestureDetector(
                child: Center(
                  child: Container(
                    height: 200,
                    width: 200,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: galleryImage != null
                          ? ClipRRect(
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
                              text: 'اضف صوره لخدمتك',
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
                  FilePickerResult? result = await FilePicker.platform.pickFiles(
                    type: FileType.custom,
                    allowedExtensions: ['jpg', 'jpeg', 'png', 'gif'],
                  );

                  if (result != null) {
                    String? filePath = result.files.single.path;
                    String fileExtension = filePath!.split('.').last.toLowerCase();

                    if (['jpg', 'jpeg', 'png', 'gif'].contains(fileExtension)) {
                      setState(() {
                        galleryImage = File(filePath);
                        image = base64.encode(galleryImage!.readAsBytesSync());
                      });
                    } else {
                      MyFlashBar(
                        title: 'خطأ',
                        context: context,
                        icon: Icons.error,
                        iconColor: Colors.white,
                        backgroundColor: Colors.red,
                        message: 'الرجاء اختيار صورة من الأنواع المسموح بها (jpg, jpeg, png, gif)',
                        thenDo: () {},
                      ).showFlashBar();
                    }
                  } else {
                    // User canceled the picker
                  }
                },
              ),

              PrimaryButton(
                title: "اضافه",
                pending: requestPending,
                onPressed: () {
                  if (!image.isEmpty) {
                    setState(() {
                      requestPending = true;
                    });
                    BlocProvider.of<ServicesBloc>(_context).add(AddNewServiceImage(id: widget.id, image: image));
                  } else {
                    Navigator.pop(context);
                  }

                },
                marginTop: .04,
              ),

            ],
          );
        },
      ),
    );
  }
}
