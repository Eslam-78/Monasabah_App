import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monasbah/core/others/MyFlashBar.dart';
import 'package:monasbah/core/util/ScreenUtil.dart';
import 'package:monasbah/core/util/common.dart';
import 'package:monasbah/core/widgets/Others/Label.dart';
import 'package:monasbah/core/widgets/Others/ScreenLine.dart';
import 'package:monasbah/core/widgets/errorScreen.dart';
import 'package:monasbah/core/widgets/screens/ScreenStyle.dart';
import 'package:monasbah/features/customers/adds/presentation/manager/addsBloc.dart';
import 'package:monasbah/features/customers/adds/presentation/manager/addsEvent.dart';
import 'package:monasbah/features/customers/adds/presentation/manager/addsState.dart';
import 'package:monasbah/features/customers/adds/presentation/widget/mySliderBar.dart';
import 'package:monasbah/features/customers/adds/presentation/widget/shimmer/mySliderBarShimmer.dart';
import 'package:monasbah/features/customers/home/data/models/mainMenuSectionsModel.dart';
import 'package:monasbah/features/customers/home/presentation/manager/mainMenu/mainMenuBloc.dart';
import 'package:monasbah/features/customers/home/presentation/manager/mainMenu/mainMenuEvent.dart';
import 'package:monasbah/features/customers/home/presentation/manager/mainMenu/mainMinuState.dart';

import 'package:monasbah/features/customers/home/presentation/widgets/HomeSectionsWidget.dart';

import 'package:monasbah/features/customers/services/presentation/pages/servicesPage.dart';
import 'package:flutter/material.dart';
import 'package:monasbah/injection_container.dart';

import '../widgets/shimmer/homeSectionSimmer.dart';
import 'customerMainHomeRoute.dart';

class MainMenuPage extends StatefulWidget {
  String token = '';

  @override
  State<MainMenuPage> createState() => _MainMenuPageState();
}

class _MainMenuPageState extends State<MainMenuPage> {
  ScreenUtil screenUtil = ScreenUtil();
  Widget sectionsWidget = Container(),
      addsWidget = Container(),
      mostBookedServicesWidget = Container(),
      mostRatedServicesWidget = Container();

  MainMenuSectionsModel? mainMenuSectionsModel;
  bool inErrorState = false;
  bool mostBookedEmpty = false, mostRatedEmpty = false;
  String errorMessage = '';

  late BuildContext addsContext,
      sectionsContext,
      mostBookedContext,
      mostRatedContext;

  @override
  void initState() {
    check().fold((l) {
      mainMenuSectionsModel = l;
    }, (r) {
      mainMenuSectionsModel = null;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screenUtil.init(context);

    return ScreenStyle(
      onTapRightSideIcon: () {},
      child: !inErrorState
          ? GestureDetector(
              onPanUpdate: (details) {
                // Swiping in right direction
                if (details.delta.dx > 0) {
                  Navigator.pop(context);
                }
              },
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  textDirection: TextDirection.rtl,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    BlocProvider(
                      create: (context) => sl<AddsBloc>(),
                      child: BlocConsumer<AddsBloc, AddsState>(
                        listener: (_context, state) {
                          if (state is GetAddsError) {
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
                            setState(() {
                              errorMessage = state.errorMessage;
                              inErrorState = true;
                            });
                          }
                        },
                        builder: (_context, state) {
                          addsContext = _context;
                          if (state is GetAddsInitial) {
                            BlocProvider.of<AddsBloc>(_context).add(
                              GetAllAdds(),
                            );
                            return Container(); // Default widget while the state is loading
                          } else if (state is GetAddsLoading) {
                            return MySliderBarShimmer();
                          } else if (state is GetAddsLoaded) {
                            if (state.addsModel != null) {
                              print('data in main menu is not null');
                              if (state.addsModel.isNotEmpty) {
                                addsWidget =
                                    MySliderBar(addsModel: state.addsModel);
                              }
                            } else {
                              addsWidget = Container();
                            }
                          } else {
                            return Container(); // Ensure a default widget is returned in all cases
                          }
                          return addsWidget;
                        },
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ScreenLine(),
                    SizedBox(height: 20),
                    Label(labelText: "الاقسام"),
                    SizedBox(
                      height: 30,
                    ),
                    BlocProvider(
                      create: (context) => sl<MainMenuBloc>(),
                      child: BlocConsumer<MainMenuBloc, MainMenuState>(
                        listener: (_context, state) {
                          if (state is MainMenuError) {
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
                            setState(() {
                              errorMessage = state.errorMessage;
                              inErrorState = true;
                            });
                          }
                        },
                        builder: (_context, state) {
                          sectionsContext = _context;
                          if (state is MainMenuInitial) {
                            BlocProvider.of<MainMenuBloc>(_context).add(
                              GetMainMenuSections(token: widget.token),
                            );
                            return Container(); // Default widget while the state is loading
                          } else if (state is MainMenuLoading) {
                            return HomeSectionSimmer(title: 'القسم');
                          } else if (state is GetMainMenuSectionsLoaded) {
                            if (state.mainMenuSectionsModel != null &&
                                state.mainMenuSectionsModel.isNotEmpty) {
                              return SizedBox(
                                height: screenUtil.orientation ==
                                        Orientation.portrait
                                    ? screenUtil.screenHeight
                                    : screenUtil.screenWidth,
                                child: GridView.builder(
                                  scrollDirection: Axis.vertical,
                                  itemCount: state.mainMenuSectionsModel.length,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2, // Two columns per row
                                    crossAxisSpacing: 10.0,
                                    mainAxisSpacing: 30.0,
                                    childAspectRatio:
                                        3 / 2, // Adjust this ratio as needed
                                  ),
                                  itemBuilder: (context, index) {
                                    return HomeSectionsWidget(
                                      onTap: () {
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return ServicesPage(
                                            section_id: state
                                                .mainMenuSectionsModel[index].id
                                                .toString(),
                                            section: state
                                                .mainMenuSectionsModel[index]
                                                .sectionName,
                                          );
                                        }));
                                      },
                                      title: state.mainMenuSectionsModel[index]
                                          .sectionName,
                                      imageUri: state
                                          .mainMenuSectionsModel[index]
                                          .sectionImage,
                                    );
                                  },
                                ),
                              );
                            } else {
                              return Container();
                            }
                          } else {
                            return Container(); // Ensure a default widget is returned in all cases
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            )
          : ErrorScreen(
              height:
                  screenUtil.orientation == Orientation.portrait ? 400 : 200,
              width: screenUtil.orientation == Orientation.portrait ? 400 : 200,
              imageName: 'noInternet.png',
              message: errorMessage,
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            CustomerMainHomeRoute(currentIndex: 1)));
              },
              buttonTitle: 'إعاده المحاوله',
              withButton: true,
            ),
    );
  }

  //TODO::remove this function
  refreshPage() {
    setState(() {
      BlocProvider.of<AddsBloc>(addsContext).add(
        GetAllAdds(),
      );
      BlocProvider.of<MainMenuBloc>(sectionsContext).add(
        GetMainMenuSections(token: widget.token),
      );

      BlocProvider.of<MainMenuBloc>(mostBookedContext).add(
        GetMainMenuMostBookedServices(token: widget.token),
      );

      BlocProvider.of<MainMenuBloc>(mostRatedContext).add(
        GetMainMenuMostRatedServices(token: widget.token),
      );
    });
  }
}
