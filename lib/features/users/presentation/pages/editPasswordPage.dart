import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monasbah/core/others/MyFlashBar.dart';
import 'package:monasbah/core/widgets/Buttons/primaryButton.dart';
import 'package:monasbah/core/widgets/Others/TextFormFieldContainer.dart';
import 'package:monasbah/core/widgets/screens/Login_Signup_Screen.dart';
import 'package:monasbah/features/users/presentation/manager/registration/registrationBloc.dart';
import 'package:monasbah/features/users/presentation/manager/registration/registrationEvent.dart';
import 'package:monasbah/features/users/presentation/pages/loginMethodpage.dart';
import 'package:monasbah/injection_container.dart';

import '../manager/registration/registrationState.dart';

class EditPasswordPage extends StatefulWidget {
  String email, userBrand;

  EditPasswordPage({required this.email, required this.userBrand});

  @override
  State<EditPasswordPage> createState() => _EditPasswordPageState();
}

class _EditPasswordPageState extends State<EditPasswordPage> {
  late String password, confirmPassword;
  final _editPasswordKeyForm = GlobalKey<FormState>();
  bool requestPending = false;

  @override
  Widget build(BuildContext context) {
    return LoginAndSignupScreen(
      title: 'إعاده تعيين كلمه المرور',
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
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) {
                      return LoginMethodPage();
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
            return Form(
              key: _editPasswordKeyForm,
              child: Column(
                children: [
                  TextFormFieldContainer(
                    hint: "كلمه المرور الجديده",
                    textInputType: TextInputType.text,
                    onChange: (newValue) {
                      password = newValue.trim();
                    },
                    validator: (value) {
                      if (value.toString().isEmpty) {
                        return 'الرجاء تعبئة الحقل';
                      } else if (value!.length > 6) {
                        return 'كلمه المرور يجب ان تتكون من 6 خانات او اكثر';
                      }
                      return null;
                    },
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
                      } else if (value! != password) {
                        return 'كلمه المرور غير متطابقه';
                      }
                      return null;
                    },
                  ),
                  PrimaryButton(
                    title: 'إعاده نعيين',
                    marginTop: .01,
                    pending: requestPending,
                    onPressed: () {
                      if (_editPasswordKeyForm.currentState!.validate()) {
                        setState(() {
                          requestPending = true;
                        });

                        BlocProvider.of<RegistrationBloc>(context).add(
                          EditPasswordEvent(
                            email: widget.email,
                            password: password,
                            userBrand: widget.userBrand,
                          ),
                        );
                      } else {
                        print('error');
                      }
                    },
                  ),
                ],
              ),
            );
          },
        ),
      )),
    );
  }
}
