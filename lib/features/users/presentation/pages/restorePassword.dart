import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monasbah/core/app_theme.dart';
import 'package:monasbah/core/others/MyFlashBar.dart';
import 'package:monasbah/core/others/constants.dart';
import 'package:monasbah/core/widgets/Buttons/primaryButton.dart';
import 'package:monasbah/core/widgets/Others/TextFormFieldContainer.dart';
import 'package:monasbah/core/widgets/Texts/SubTitleText.dart';
import 'package:monasbah/core/widgets/screens/Login_Signup_Screen.dart';
import 'package:flutter/material.dart';
import 'package:monasbah/features/users/presentation/manager/registration/registrationBloc.dart';
import 'package:monasbah/features/users/presentation/manager/registration/registrationEvent.dart';
import 'package:monasbah/features/users/presentation/manager/registration/registrationState.dart';
import 'package:monasbah/features/users/presentation/pages/editPasswordPage.dart';
import 'package:monasbah/injection_container.dart';

class RestorePassword extends StatefulWidget {
  String userBrand;

  RestorePassword({required this.userBrand});

  @override
  State<RestorePassword> createState() => _RestorePasswordState();
}

class _RestorePasswordState extends State<RestorePassword> {
  final _restorePasswordFormKey = GlobalKey<FormState>();
  late String buttonText = 'إرسال الرمز', email, confirmCode;
  bool codeVisibility = false, emailVisibility = true, requestPending = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppTheme.primaryColor,
        body: LoginAndSignupScreen(
          title: "إستعاده كلمة المرور",
          child: SingleChildScrollView(
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
                        if (buttonText == 'إرسال الرمز') {
                          setState(() {
                            buttonText = 'تحقق';
                            codeVisibility = true;
                            emailVisibility = false;
                          });
                        } else {
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) {
                            return EditPasswordPage(
                                email: email, userBrand: widget.userBrand);
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
                return Column(
                  children: [
                    SubTitleText(
                      textColor: kMyGrey,
                      fontWeight: FontWeight.bold,
                      textAlign: TextAlign.center,
                      text:
                          "ادخل الايميل الشخصي الذي قمت بالتسجيل فيه وسيتم ارسال رمز تاكيد اليك ",
                      fontSize: 20,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Form(
                      key: _restorePasswordFormKey,
                      child: Column(
                        children: [
                          Visibility(
                            visible: emailVisibility,
                            child: TextFormFieldContainer(
                              hint: "الإيميل",
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
                            ),
                          ),
                          Visibility(
                            visible: codeVisibility,
                            child: TextFormFieldContainer(
                              hint: "رمز التحقق",
                              textInputType: TextInputType.number,
                              onChange: (newValue) {
                                confirmCode = newValue.trim();
                              },
                              validator: (value) {
                                if (value.toString().isEmpty) {
                                  return 'الرجاء إدخال الكود';
                                } else if (value!.length < 6) {
                                  return 'يجب ان يتكون الكود من 6 خانات';
                                }

                                return null;
                              },
                              maxLength: 6,
                            ),
                          ),
                        ],
                      ),
                    ),
                    PrimaryButton(
                      title: buttonText,
                      marginTop: .01,
                      pending: requestPending,
                      onPressed: () {
                        if (_restorePasswordFormKey.currentState!.validate()) {
                          setState(() {
                            requestPending = true;
                          });
                          if (buttonText == 'إرسال الرمز') {
                            BlocProvider.of<RegistrationBloc>(context).add(
                                SendConfirmCodeEvent(
                                    email: email, userBrand: widget.userBrand));
                          } else {
                            BlocProvider.of<RegistrationBloc>(context).add(
                                CheckConfirmCodeEvent(
                                    email: email,
                                    confirmCode: confirmCode,
                                    userBrand: widget.userBrand));
                          }
                        } else {
                          print('error');
                        }
                      },
                    ),
                  ],
                );
              },
            ),
          )),
        ),
      ),
    );
  }
}
