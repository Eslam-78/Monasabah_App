import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monasbah/core/app_theme.dart';
import 'package:monasbah/core/others/MyFlashBar.dart';
import 'package:monasbah/core/util/ScreenUtil.dart';
import 'package:monasbah/core/widgets/Others/ScreenLine.dart';
import 'package:monasbah/core/widgets/Texts/SubTitleText.dart';
import 'package:monasbah/core/widgets/cachedNetworkImage.dart';
import 'package:monasbah/core/widgets/errorScreen.dart';
import 'package:monasbah/core/widgets/screens/Login_Signup_Screen.dart';
import 'package:monasbah/features/customers/home/presentation/manager/aboutApp/aboutAppBloc.dart';
import 'package:monasbah/features/customers/home/presentation/manager/aboutApp/aboutAppEvent.dart';
import 'package:monasbah/features/customers/home/presentation/manager/aboutApp/aboutAppState.dart';
import 'package:monasbah/features/customers/home/presentation/widgets/shimmer/aboutAppShimmer.dart';
import 'package:monasbah/injection_container.dart';

class AboutAppPage extends StatelessWidget {
  Widget appDetailsWidget = Container(), socialMediaWidget = Container();
  ScreenUtil screenUtil = ScreenUtil();
  @override
  Widget build(BuildContext context) {
    screenUtil.init(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppTheme.primaryColor,
        body: LoginAndSignupScreen(
          title: 'عن التطبيق',
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(
                      top: screenUtil.orientation == Orientation.portrait
                          ? screenUtil.screenHeight * .02
                          : screenUtil.screenWidth * .02,
                      bottom: screenUtil.orientation == Orientation.portrait
                          ? screenUtil.screenHeight * .01
                          : screenUtil.screenWidth * .01,
                      left: screenUtil.orientation == Orientation.portrait
                          ? screenUtil.screenWidth * .06
                          : screenUtil.screenHeight * .06,
                      right: screenUtil.orientation == Orientation.portrait
                          ? screenUtil.screenWidth * .06
                          : screenUtil.screenHeight * .06),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(40),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        ///app details bloc
                        BlocProvider(
                          create: (context) => sl<AboutAppBloc>(),
                          child: BlocConsumer<AboutAppBloc, AboutAppState>(
                            listener: (_context, state) {
                              if (state is GetAboutAppError) {
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
                              if (state is GetAboutAppInitial) {
                                BlocProvider.of<AboutAppBloc>(_context)
                                    .add(GetAppDetails());
                              } else if (state is GetAboutAppLoading) {
                                appDetailsWidget = Container(
                                  child: AboutAppShimmer(),
                                );
                              } else if (state is GetAppDetailsLoaded) {
                                if (state.aboutAppModel != null) {
                                  if (state.aboutAppModel.isNotEmpty) {
                                    appDetailsWidget = Column(
                                      children: [
                                        Container(
                                          child: Image.asset(
                                              'assets/images/logo.png'),
                                          width: double.infinity,
                                          height: screenUtil.orientation ==
                                                  Orientation.portrait
                                              ? screenUtil.screenHeight * .3
                                              : screenUtil.screenWidth * .3,
                                        ),
                                        ScreenLine(),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        SubTitleText(
                                            text: 'تطبيق مناسبه',
                                            textColor: AppTheme.primaryColor,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        SubTitleText(
                                            text:
                                                state.aboutAppModel[0].snapshot,
                                            textColor: AppTheme.primaryColor,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        SubTitleText(
                                            text: state.aboutAppModel[0].email,
                                            textColor: AppTheme.primaryColor,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        SubTitleText(
                                          text: state
                                              .aboutAppModel[0].phoneNumber,
                                          textColor: AppTheme.primaryColor,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        SubTitleText(
                                          text: state.aboutAppModel[0].teamName,
                                          textColor: AppTheme.primaryColor,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        ScreenLine(),
                                        SizedBox(
                                          height: 30,
                                        ),
                                        GestureDetector(
                                          child: SubTitleText(
                                            text: 'سيـاسـة الـخصوصيــه',
                                            textColor: AppTheme.primaryColor,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          onTap: () {
                                            print(state.aboutAppModel[0]
                                                .privicyPolicy);
                                          },
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    );
                                  }
                                } else {
                                  appDetailsWidget = Center(
                                    child: ErrorScreen(
                                      height: screenUtil.orientation ==
                                              Orientation.portrait
                                          ? 400
                                          : 200,
                                      width: screenUtil.orientation ==
                                              Orientation.portrait
                                          ? 400
                                          : 200,
                                      imageName: 'noInternet.png',
                                      message:
                                          'عذراً .. حدث خطأ غير متوقع تأكد من اتصالك بالانترنت وحاول لاحقاً',
                                      withButton: false,
                                    ),
                                  );
                                }
                              }
                              return appDetailsWidget;
                            },
                          ),
                        ),

                        ///social media bloc

                        // BlocProvider(
                        //   create: (context) => sl<AboutAppBloc>(),
                        //   child: BlocConsumer<AboutAppBloc, AboutAppState>(
                        //     listener: (_context, state) {
                        //       if (state is GetAboutAppError) {
                        //         MyFlashBar(
                        //             title: 'خطأ',
                        //             context: context,
                        //             icon: Icons.error,
                        //             iconColor: Colors.white,
                        //             backgroundColor: Colors.red,
                        //             message: state.errorMessage,
                        //             thenDo: () {
                        //               print(state.errorMessage);
                        //             }).showFlashBar();
                        //       }
                        //     },
                        //     builder: (_context, state) {
                        //       if (state is GetAboutAppInitial) {
                        //         BlocProvider.of<AboutAppBloc>(_context)
                        //             .add(GetSocialMediaAccounts());
                        //       } else if (state is GetAboutAppLoading) {
                        //         socialMediaWidget = Container(
                        //           child: Text('loading'),
                        //         );
                        //       } else if (state
                        //           is GetSocialMediaAccountsLoaded) {
                        //         if (state.socialMediaAccountsModel != null) {
                        //           if (state
                        //               .socialMediaAccountsModel.isNotEmpty) {
                        //             appDetailsWidget = SizedBox(
                        //               height: 100,
                        //               child: Align(
                        //                 alignment: Alignment.centerRight,
                        //                 child: ListView.builder(
                        //                   itemCount:
                        //                       state.socialMediaAccountsModel.length,
                        //                   scrollDirection: Axis.horizontal,
                        //                   itemBuilder:
                        //                       (BuildContext context, int index) {
                        //                     return Container(
                        //                       height: 30,
                        //                       width: 30,
                        //                       decoration: BoxDecoration(
                        //                         borderRadius:
                        //                             BorderRadius.circular(20),
                        //                       ),
                        //                       child: CircleAvatar(backgroundColor: Colors.black26,)
                        //                     );
                        //                   },
                        //                 ),
                        //               ),
                        //             );
                        //           }
                        //         } else {
                        //           appDetailsWidget = Container(
                        //             child: Text('error'),
                        //           );
                        //         }
                        //       }
                        //       return appDetailsWidget;
                        //     },
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
