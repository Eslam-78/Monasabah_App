import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:monasbah/core/app_theme.dart';
import 'package:monasbah/core/others/MyFlashBar.dart';
import 'package:monasbah/core/others/constants.dart';
import 'package:monasbah/core/util/ScreenUtil.dart';
import 'package:monasbah/core/util/common.dart';
import 'package:monasbah/core/widgets/Buttons/primaryButton.dart';
import 'package:monasbah/core/widgets/Others/Label.dart';
import 'package:monasbah/core/widgets/Texts/SubTitleText.dart';
import 'package:monasbah/dataProviders/local_data_provider.dart';
import 'package:monasbah/features/customers/home/presentation/pages/customerMainHomeRoute.dart';
import 'package:monasbah/features/customers/settings/presentation/pages/aboutAppPage.dart';
import 'package:monasbah/features/customers/settings/presentation/pages/editUserDetailsPage.dart';
import 'package:monasbah/features/customers/settings/presentation/widgets/SettingsScreen.dart';
import 'package:flutter/material.dart';
import 'package:monasbah/features/customers/settings/presentation/widgets/settingsListTile.dart';
import 'package:monasbah/features/users/data/models/customerModel.dart';
import 'package:monasbah/features/users/presentation/manager/registration/registrationBloc.dart';
import 'package:monasbah/features/users/presentation/manager/registration/registrationEvent.dart';
import 'package:monasbah/features/users/presentation/manager/registration/registrationState.dart';
import 'package:monasbah/features/users/presentation/pages/loginMethodpage.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:monasbah/injection_container.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class SettingsPage extends StatefulWidget {
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late String title;

  late Widget child;

  late CustomerModel? customerModel;
  bool switchBool = false, requestPending = false;

  @override
  void initState() {
    checkCustomerLoggedIn().fold((l) {
      customerModel = l;
    }, (r) {
      customerModel = null;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil().init(context);
    return SettingsScreen(
      userName: customerModel?.userName ?? 'مناسبه',
      email: customerModel?.email ?? 'monasabah@gmail.com',
      onTapEditIcon: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return EditUserDetailsPage(
              userBrand: 'customer', image: customerModel!.image);
        }));
      },
      child: Column(
        textDirection: TextDirection.rtl,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10),
          Label(labelText: "الإعدادات"),
          Expanded(
            flex: 10,
            child: SingleChildScrollView(
              child: Column(
                textDirection: TextDirection.rtl,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      textDirection: TextDirection.rtl,
                      children: [
                        ListTile(
                          title: SubTitleText(
                            textAlign: TextAlign.start,
                            textColor: Colors.grey,
                            fontSize: 20,
                            text: "الإشعارات",
                          ),
                          leading: Switch(
                            value: switchBool,
                            activeColor: AppTheme.primaryColor,
                            activeTrackColor: AppTheme.primarySwatch.shade500,
                            inactiveTrackColor: AppTheme.primarySwatch.shade200,
                            onChanged: (bool value) {
                              setState(() {
                                switchBool = value;
                              });
                            },
                          ),
                          trailing:
                              SvgPicture.asset('$kIconsPath/notifications.svg'),
                        ),
                        SettingsListTile(
                          title: 'قيم التطبيق',
                          iconPath: '$kIconsPath/Star.svg',
                          onTap: () {
                            openPlayStore();
                          },
                        ),
                        SettingsListTile(
                          title: 'مشاركه التطبيق',
                          iconPath: '$kIconsPath/share.svg',
                          onTap: () async {
                            Directory tempDir = await getTemporaryDirectory();
                            String tempPath = tempDir.path;
                            String apkPath =
                                '$tempPath/app.apk'; // تحديد اسم الملف APK هنا

                            // نسخ ملف APK من assets إلى المسار المؤقت
                            ByteData data =
                                await rootBundle.load('assets/app.apk');
                            List<int> bytes = data.buffer.asUint8List();
                            await File(apkPath).writeAsBytes(bytes);

                            // مشاركة الملف APK
                            Share.shareFiles([apkPath],
                                text: 'تحقق من هذا التطبيق الرائع!');
                          },
                        ),
                        SettingsListTile(
                          title: 'الدعم والمساعده',
                          iconPath: '$kIconsPath/help.svg',
                          onTap: () {
                            _launchEmail();
                          },
                        ),
                        SettingsListTile(
                          title: 'عن التطبيق',
                          iconPath: '$kIconsPath/mobile.svg',
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return AboutAppPage();
                            }));
                          },
                        ),
                        BlocProvider(
                          create: (context) => sl<RegistrationBloc>(),
                          child:
                              BlocConsumer<RegistrationBloc, RegistrationState>(
                            listener: (_context, state) {
                              if (state is RegisterLoaded) {
                                setState(() {
                                  requestPending = false;
                                });
                                MyFlashBar(
                                    title: 'تم',
                                    context: context,
                                    icon: Icons.check,
                                    iconColor: Colors.white,
                                    backgroundColor: Colors.green.shade600,
                                    message: state.message,
                                    thenDo: () {
                                      LocalDataProvider(
                                              sharedPreferences:
                                                  sl<SharedPreferences>())
                                          .clearCache(key: 'CUSTOMER_USER');
                                      Navigator.pushReplacement(context,
                                          MaterialPageRoute(builder: (context) {
                                        return CustomerMainHomeRoute(
                                            currentIndex: 4);
                                      }));
                                    }).showFlashBar();
                              } else if (state is RegisterError) {
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
                                      print(state.errorMessage);
                                    }).showFlashBar();
                              }
                            },
                            builder: (_context, state) {
                              return PrimaryButton(
                                title: customerModel == null
                                    ? 'تسجيل الدخول'
                                    : 'تسجيل الخروج',
                                pending: requestPending,
                                onPressed: () {
                                  if (customerModel == null) {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return LoginMethodPage();
                                    }));
                                  } else {
                                    setState(() {
                                      requestPending = true;
                                    });
                                    BlocProvider.of<RegistrationBloc>(_context)
                                        .add(LogoutEvent(
                                            token: customerModel!.token));
                                  }
                                },
                                marginTop: .01,
                                backgroundColor: customerModel == null
                                    ? AppTheme.primaryColor
                                    : Colors.red,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  openPlayStore() async {
    const url =
        'https://play.google.com/store/apps/developer?id=<Developer_ID>';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _launchEmail() async {
    const email = 'Eslamalejil@gmail.com';
    final url = 'mailto:$email';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
