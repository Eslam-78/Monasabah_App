import 'dart:core';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monasbah/core/app_theme.dart';
import 'package:monasbah/core/others/constants.dart';
import 'package:monasbah/core/others/MyFlashBar.dart';
import 'package:monasbah/core/widgets/Buttons/primaryButton.dart';
import 'package:monasbah/core/widgets/Others/TextFormFieldContainer.dart';
import 'package:monasbah/core/widgets/Texts/SubTitleText.dart';
import 'package:monasbah/core/widgets/Texts/TapedText.dart';
import 'package:monasbah/core/widgets/screens/Login_Signup_Screen.dart';
import 'package:monasbah/dataProviders/local_data_provider.dart';
import 'package:monasbah/features/ServiceProviders/mainMenu/presintaion/pages/serviceProviderMainMenuPage.dart';
import 'package:monasbah/features/customers/home/presentation/pages/customerMainHomeRoute.dart';
import 'package:monasbah/features/users/data/models/loginModel.dart';
import 'package:monasbah/features/users/presentation/manager/registration/registrationBloc.dart';
import 'package:monasbah/features/users/presentation/manager/registration/registrationEvent.dart';
import 'package:monasbah/features/users/presentation/manager/registration/registrationState.dart';
import 'package:monasbah/features/users/presentation/pages/signupMethodpage.dart';
import 'package:flutter/material.dart';
import 'package:monasbah/injection_container.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  String userBrand;

  LoginPage({required this.userBrand});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late String email, password;

  bool rememberMe = false;
  final _loginFormKey = GlobalKey<FormState>();
  late LoginModel loginModel;
  bool requestPending = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.userBrand);
    return SafeArea(
      child: Scaffold(
          body: LoginAndSignupScreen(
        title: "تسجيل الدخول",
        child: BlocProvider(
          create: (context) => sl<RegistrationBloc>(),
          child: BlocConsumer<RegistrationBloc, RegistrationState>(
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
                      ///here check the user if customer and service provider and push the appropriate route for him

                      if (widget.userBrand == 'customer') {
                        LocalDataProvider(
                                sharedPreferences: sl<SharedPreferences>())
                            .clearCache(key: 'SERVICE_PROVIDER_USER');

                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) {
                          return CustomerMainHomeRoute(currentIndex: 1);
                        }));
                      } else {
                        LocalDataProvider(
                                sharedPreferences: sl<SharedPreferences>())
                            .clearCache(key: 'CUSTOMER_USER');

                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) {
                          return ServiceProviderMainMenuPage();
                        }));
                      }
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
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/logo.png',
                      height: 250,
                      width: 250,
                    ),
                    SubTitleText(
                      textColor: kMyGrey,
                      fontWeight: FontWeight.bold,
                      text:
                          "للتمكن من حجز خدماتنا الرجاء التسجيل ببيانات حقيقيه",
                      fontSize: 20,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Form(
                      key: _loginFormKey,
                      child: Column(
                        children: [
                          TextFormFieldContainer(
                            hint: "الايميل",
                            textInputType: TextInputType.text,
                            onChange: (newValue) {
                              email = newValue.trim();
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'يجب ادخال عنوان البريد الالكتروني';
                              } else if (!RegExp(
                                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(value)) {
                                return "عذراً الإيميل الذي ادخلته غير صحيح";
                              }

                              return null;
                            },
                            autofocus: true,
                            maxLength: 50,
                          ),
                          TextFormFieldContainer(
                            hint: "كلمه المرور",
                            textInputType: TextInputType.text,
                            onChange: (newValue) {
                              password = newValue.trim();
                            },
                            validator: (value) {
                              if (value.toString().isEmpty) {
                                return 'الرجاء تعبئة الحقل';
                              }
                              if (value!.length < 6) {
                                return 'كلمه المرور تتكون من 6 حروف وارفام على الاقل';
                              }
                              return null;
                            },
                            obscureText: true,
                            maxLength: 10,
                            enable: true,
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      textDirection: TextDirection.rtl,
                      children: [
                        Row(
                          children: [
                            SubTitleText(
                              text: "تذكرني",
                              fontSize: 15,
                              textColor: kMyGrey,
                            ),
                            Checkbox(
                              checkColor: Colors.white,
                              activeColor: AppTheme.primaryColor,
                              value: rememberMe,
                              onChanged: (newValue) {
                                setState(() {
                                  rememberMe = newValue!;
                                });
                              },
                            )
                          ],
                        ),
                        /* TapedText(
                                  text: "نسيت كلمة المرور",
                                  color: AppTheme.primaryColor,
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                RestorePassword(userBrand: widget.userBrand,)));
                                  },
                                ),*/
                      ],
                    ),
                    PrimaryButton(
                      pending: requestPending,
                      title: 'دخول',
                      marginTop: .01,
                      onPressed: () {
                        if (_loginFormKey.currentState!.validate()) {
                          print('ok');
                          BlocProvider.of<RegistrationBloc>(_context).add(
                              LoginRequest(
                                  loginModel: LoginModel(
                                      email: email,
                                      password: password,
                                      userBrand: widget.userBrand)));

                          setState(() {
                            requestPending = true;
                          });
                        } else {
                          print('error');
                        }
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      textDirection: TextDirection.rtl,
                      children: [
                        Text("لايوجد لديك حساب ؟  "),
                        SizedBox(
                          width: 10.0,
                        ),
                        TapedText(
                          text: "   إنشاء حساب",
                          color: AppTheme.primaryColor,
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignupMethodPAge()));
                          },
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      )),
    );
  }
}
