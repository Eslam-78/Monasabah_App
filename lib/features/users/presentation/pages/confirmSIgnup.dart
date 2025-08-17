import 'dart:core';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monasbah/core/app_theme.dart';
import 'package:monasbah/core/others/constants.dart';
import 'package:monasbah/core/others/MyFlashBar.dart';
import 'package:monasbah/core/widgets/Buttons/primaryButton.dart';
import 'package:monasbah/core/widgets/Others/TextFormFieldContainer.dart';
import 'package:monasbah/core/widgets/Texts/SubTitleText.dart';
import 'package:monasbah/core/widgets/screens/Login_Signup_Screen.dart';
import 'package:flutter/material.dart';
import 'package:monasbah/features/users/data/models/SignUpModel.dart';
import 'package:monasbah/features/users/presentation/manager/registration/registrationBloc.dart';
import 'package:monasbah/features/users/presentation/manager/registration/registrationEvent.dart';
import 'package:monasbah/features/users/presentation/manager/registration/registrationState.dart';
import 'package:monasbah/injection_container.dart';

class ConfirmSignup extends StatefulWidget {
  late SignUpModel signUpModel;
  ConfirmSignup({required this.signUpModel});

  @override
  State<ConfirmSignup> createState() => _ConfirmSignupState();
}

class _ConfirmSignupState extends State<ConfirmSignup> {
  final _confirmSignupFormKey = GlobalKey<FormState>();
  FirebaseAuth auth = FirebaseAuth.instance;
  String? _verificationID;
  String code = '';

  bool checkCodeButton = false, requestPending = true, verifyCodeEnable = true;

  @override
  Widget build(BuildContext context) {
    verifyNumber();
    printDetails();

    return SafeArea(
      child: Scaffold(
          backgroundColor: AppTheme.primaryColor,
          body: LoginAndSignupScreen(
              title: "تأكيد الحساب",
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
                            print(state.message);
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
                          SubTitleText(
                            textColor: kMyGrey,
                            fontWeight: FontWeight.bold,
                            textAlign: TextAlign.center,
                            text:
                                "اسلام العجل اسلام العجل اسلام العجل اسلام العجل",
                            fontSize: 20,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Form(
                            key: _confirmSignupFormKey,
                            child: Column(
                              children: [
                                TextFormFieldContainer(
                                  enable: verifyCodeEnable,
                                  hint: "الكود",
                                  textInputType: TextInputType.number,
                                  onChange: (newValue) {
                                    setState(() {
                                      code = newValue;
                                    });
                                  },
                                  validator: (value) {
                                    if (value.toString().isEmpty) {
                                      return 'الرجاء إدخال الكود';
                                    }
                                    return null;
                                  },
                                  autofocus: true,
                                  maxLength: 9,
                                ),
                              ],
                            ),
                          ),
                          Visibility(
                            visible: checkCodeButton,
                            child: PrimaryButton(
                              title: "التحقق من الكود",
                              marginTop: .1,
                              onPressed: () {
                                if (_confirmSignupFormKey.currentState!
                                    .validate()) {
                                  // verifyCode(_context);
                                  setState(() {
                                    verifyCodeEnable = false;
                                    requestPending = true;
                                  });
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ))),
    );
  }

  void verifyNumber() {
    print('pressed');
    auth.verifyPhoneNumber(
      phoneNumber: '+967782513351',
      verificationCompleted: (PhoneAuthCredential credential) async {
        log('completed');

        await auth.signInWithCredential(credential).then((value) => () {
              setState(() {
                requestPending = false;
              });
            });
      },
      verificationFailed: (FirebaseAuthException exception) {
        log('error');
        log(exception.message.toString());
      },
      codeSent: (String verificationID, int? resendToken) {
        log('sent');
        this._verificationID = verificationID;
        setState(() {
          requestPending = false;
          checkCodeButton = true;
        });
      },
      codeAutoRetrievalTimeout: (String verificationID) {
        print('time out');
      },
    );
  }

  // verifyCode(BuildContext context) async {
  //   PhoneAuthCredential credential = PhoneAuthProvider.credential(
  //       verificationId: _verificationID!, smsCode: code);
  //   try {
  //     await auth.signInWithCredential(credential).then((value) {
  //       BlocProvider.of<RegistrationBloc>(context)
  //           .add(CreateNewUserRequest(signUpModel: widget.signUpModel));
  //     });
  //   } catch (e) {
  //     log(e.toString());
  //     setState(() {
  //       requestPending=false;
  //       verifyCodeEnable=true;
  //     });
  //   }
  // }
  //

  void printDetails() {
    print(widget.signUpModel.userName);
    print(widget.signUpModel.phoneNumber);
    print(widget.signUpModel.password);
  }
}
