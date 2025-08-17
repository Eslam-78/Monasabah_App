import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monasbah/core/app_theme.dart';
import 'package:monasbah/core/others/constants.dart';
import 'package:monasbah/core/others/MyFlashBar.dart';
import 'package:monasbah/core/widgets/Buttons/primaryButton.dart';
import 'package:monasbah/core/widgets/Others/TextFormFieldContainer.dart';
import 'package:monasbah/core/widgets/Texts/SubTitleText.dart';
import 'package:monasbah/core/widgets/Texts/TapedText.dart';
import 'package:monasbah/core/widgets/screens/Login_Signup_Screen.dart';
import 'package:monasbah/features/users/data/models/SignUpModel.dart';
import 'package:monasbah/features/users/presentation/manager/registration/registrationBloc.dart';
import 'package:monasbah/features/users/presentation/manager/registration/registrationEvent.dart';
import 'package:monasbah/features/users/presentation/manager/registration/registrationState.dart';
import 'package:monasbah/features/users/presentation/pages/loginMethodpage.dart';
import 'package:monasbah/injection_container.dart';

class SignupPage extends StatefulWidget {
  String userBrand;

  SignupPage({required this.userBrand});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  late String userName = '',
      managerName = '',
      phoneNumber,
      email,
      password,
      confirmPassword;

  final _signupFormKey = GlobalKey<FormState>();

  bool managerNameVisibility = false;

  late SignUpModel signUpModel;
  bool requestPending = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppTheme.primaryColor,
        body: LoginAndSignupScreen(
          title: 'إنشاء حساب',
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
                      icon: state.message == 'ok' ? Icons.check : Icons.error,
                      iconColor: Colors.white,
                      backgroundColor: state.message != 'ok'
                          ? Colors.red
                          : Colors.green.shade600,
                      message: state.message == 'ok'
                          ? 'تم انشاء الحساب بنجاح'
                          : state.message,
                      thenDo: () {
                        if (state.message == 'ok') {
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) {
                            return LoginMethodPage();
                          }));

                          /*Navigator.push(context, MaterialPageRoute(builder: (context){
                            return ConfirmSignup(signUpModel: SignUpModel(
                                userName: userName,
                                password: password,
                                phoneNumber: phoneNumber,
                                email: email,
                                managerName: managerName,
                                userBrand: 'customer'
                            ));
                          }));*/

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
                          thenDo: () {})
                      .showFlashBar();
                }
              },
              builder: (_context, state) {
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/images/logo.png',
                        height: 200,
                        width: 200,
                      ),
                      SubTitleText(
                        textColor: kMyGrey,
                        fontWeight: FontWeight.bold,
                        textAlign: TextAlign.center,
                        text:
                            "للتمكن من حجز خدماتنا الرجاء التسجيل ببيانات حقيقيه",
                        fontSize: 20,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Form(
                        key: _signupFormKey,
                        child: Column(
                          children: [
                            Visibility(
                              visible:
                                  widget.userBrand == 'customer' ? true : false,
                              child: TextFormFieldContainer(
                                hint: "إسم المستخدم",
                                autofocus: true,
                                onChange: (newValue) {
                                  userName = newValue.trim();
                                },
                                validator: (value) {
                                  if (value.toString().isEmpty) {
                                    return 'الرجاء تعبئة الحقل';
                                  } else if (!RegExp(
                                          r'^[a-zA-Z\u0621-\u064A\s]+$')
                                      .hasMatch(value.toString())) {
                                    return 'يجب أن يحتوي إسم المستخدم على أحرف فقط';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Visibility(
                              visible:
                                  widget.userBrand == 'customer' ? false : true,
                              child: TextFormFieldContainer(
                                hint: "إسم المدير",
                                onChange: (newValue) {
                                  managerName = newValue.trim();
                                },
                                validator: (value) {
                                  if (value.toString().isEmpty) {
                                    return 'الرجاء تعبئة الحقل';
                                  } else if (!RegExp(
                                          r'^[a-zA-Z\u0621-\u064A\s]+$')
                                      .hasMatch(value.toString())) {
                                    return 'يجب أن يحتوي إسم المدير على أحرف فقط';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            TextFormFieldContainer(
                              hint: "رقم الهاتف",
                              textInputType: TextInputType.phone,
                              onChange: (newValue) {
                                phoneNumber = newValue.trim();
                              },
                              validator: (value) {
                                if (value.toString().isEmpty) {
                                  return 'الرجاء تعبئة الحقل';
                                }
                                if (value.toString().length < 9) {
                                  return 'يجب أن يتكون رقم الهاتف من 9 أرقام';
                                }
                                if (!value
                                    .toString()
                                    .startsWith(new RegExp(r'[7][7|1|3|0]'))) {
                                  return 'يجب أن يبدا رقم الهاتف ب 73 او 70 او 71 او 77 ';
                                }

                                return null;
                              },
                              maxLength: 9,
                            ),
                            TextFormFieldContainer(
                              hint: "الإيميل",
                              textInputType: TextInputType.text,
                              onChange: (newValue) {
                                email = newValue.trim();
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'يجب ادخال عنوان البريد الالكتروني';
                                } else if (!RegExp(
                                        r"^[a-zA-Z]{3}[a-zA-Z0-9]{0,5}@[a-zA-Z0-9]+\.[a-zA-Z]+$")
                                    .hasMatch(value)) {
                                  // Handle invalid email

                                  return "لقد قمت بادخال الايميل بطريقة خاطئة";
                                }

                                return null;
                              },
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
                            ),
                            TextFormFieldContainer(
                              hint: "تأكيد كلمه المرور",
                              textInputType: TextInputType.text,
                              onChange: (newValue) {
                                confirmPassword = newValue.trim();
                              },
                              validator: (value) {
                                if (value.toString().isEmpty) {
                                  return 'الرجاء تعبئة الحقل';
                                }
                                if (value.toString() != password) {
                                  return 'كلمة المرور غير متطابقه';
                                }
                                return null;
                              },
                              obscureText: true,
                            ),
                          ],
                        ),
                      ),
                      PrimaryButton(
                        title: "إنشاء",
                        pending: requestPending,
                        marginTop: .01,
                        onPressed: () {
                          if (_signupFormKey.currentState!.validate()) {
                            BlocProvider.of<RegistrationBloc>(_context).add(
                              SignupRequest(
                                  signUpModel: SignUpModel(
                                      userName: userName,
                                      password: password,
                                      phoneNumber: phoneNumber,
                                      email: email,
                                      managerName: managerName,
                                      userBrand: widget.userBrand)),
                            );
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
                        children: [
                          TapedText(
                            text: "تسجيل الدخول",
                            color: AppTheme.primaryColor,
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginMethodPage()));
                            },
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text("لديك حساب مسبقاً ؟"),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
