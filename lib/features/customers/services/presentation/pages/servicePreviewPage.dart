import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:monasbah/core/others/MyFlashBar.dart';
import 'package:monasbah/core/util/ScreenUtil.dart';
import 'package:monasbah/core/util/common.dart';
import 'package:monasbah/core/widgets/Buttons/primaryButton.dart';
import 'package:monasbah/core/widgets/Others/Label.dart';

import 'package:monasbah/core/widgets/Others/TextFormFieldContainer.dart';

import 'package:monasbah/core/widgets/errorScreen.dart';
import 'package:monasbah/features/customers/services/presentation/manager/servicePreview/servicesPreviewsBloc.dart';
import 'package:monasbah/features/customers/services/presentation/manager/servicePreview/servicesPreviewsEvent.dart';
import 'package:monasbah/features/customers/services/presentation/manager/servicePreview/servicesPreviewsState.dart';
import 'package:monasbah/features/customers/services/presentation/widgets/servicePreviewsWidget.dart';
import 'package:monasbah/features/users/data/models/customerModel.dart';
import 'package:monasbah/injection_container.dart';

import '../widgets/shimmer/servicePreviewsShimmer.dart';

class ServicePreviewPage extends StatefulWidget {
  dynamic id;

  ServicePreviewPage({required this.id});

  @override
  State<ServicePreviewPage> createState() => _ServicePreviewPageState();
}

class _ServicePreviewPageState extends State<ServicePreviewPage> {
  Widget servicePreviewWidget = Container();
  bool requestPending = false;
  final _servicePreviewFormKey = GlobalKey<FormState>();

  late String preview;
  CustomerModel? customerModel;
  final _previewFormKey = GlobalKey<FormState>();

  ScreenUtil screenUtil = ScreenUtil();
  late BuildContext blocContext;

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
    screenUtil.init(context);
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: Visibility(
          visible: customerModel != null ? true : false,
          child: Container(
            height: 200,
            width: double.infinity,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Form(
                    key: _previewFormKey,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormFieldContainer(
                        autofocus: true,
                        hint: "اضف مراجعتك ...",
                        textInputType: TextInputType.text,
                        onChange: (newValue) {
                          preview = newValue.trim();
                        },
                        validator: (value) {
                          if (value.toString().isEmpty) {
                            return 'الرجاء تعبئة الحقل';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  PrimaryButton(
                    title: 'اضف مراجعتك',
                    pending: requestPending,
                    onPressed: () {
                      if (_previewFormKey.currentState!.validate()) {
                        BlocProvider.of<ServicesPreviewsBloc>(blocContext).add(
                            AddServicePreview(
                                service_id: widget.id.toString(),
                                api_token: customerModel!.token,
                                preview: preview));
                        setState(() {
                          requestPending = true;
                        });
                      }
                    },
                    marginTop: .01,
                  ),
                ],
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(
                        'assets/images/background.jpg',
                      ),
                      fit: BoxFit.cover),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  textDirection: TextDirection.rtl,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    Label(labelText: 'المراجعات'),
                    Expanded(
                      flex: screenUtil.orientation == Orientation.portrait
                          ? 3
                          : 1,
                      child: BlocProvider(
                        create: (context) => sl<ServicesPreviewsBloc>(),
                        child: BlocConsumer<ServicesPreviewsBloc,
                            ServicesPreviewsState>(
                          listener: (_context, state) {
                            if (state is AddServicePreviewLoaded) {
                              MyFlashBar(
                                  title: 'نجاح',
                                  context: context,
                                  icon: Icons.check,
                                  iconColor: Colors.white,
                                  backgroundColor: Colors.green,
                                  message: state.message,
                                  thenDo: () {
                                    Navigator.pushReplacement(context,
                                        MaterialPageRoute(builder: (context) {
                                      return ServicePreviewPage(id: widget.id);
                                    }));
                                  }).showFlashBar();
                              setState(() {
                                requestPending = false;
                              });
                            }
                            if (state is ServicesPreviewsError) {
                              MyFlashBar(
                                  title: 'خطأ',
                                  context: context,
                                  icon: Icons.error,
                                  iconColor: Colors.white,
                                  backgroundColor: Colors.red,
                                  message: state.errorMessage,
                                  thenDo: () {
                                    Navigator.pop(_context);
                                  }).showFlashBar();
                              setState(() {
                                requestPending = false;
                              });
                            }
                          },
                          builder: (_context, state) {
                            blocContext = _context;
                            if (state is ServicesPreviewInitial) {
                              BlocProvider.of<ServicesPreviewsBloc>(_context)
                                  .add(GetServicePreview(
                                      service_id: widget.id.toString()));
                            } else if (state is GetServicesPreviewsLoading) {
                              servicePreviewWidget = ServicePreviewsShimmer();
                            } else if (state is GetServicesPreviewsLoaded) {
                              if (state.servicesPreviewsModel != null) {
                                if (state.servicesPreviewsModel.isNotEmpty) {
                                  print(
                                      jsonEncode(state.servicesPreviewsModel));
                                  servicePreviewWidget = ListView.builder(
                                    itemCount:
                                        state.servicesPreviewsModel.length,
                                    scrollDirection: Axis.vertical,
                                    itemBuilder: (context, index) {
                                      print(
                                          "IMAGE URL: ${state.servicesPreviewsModel[index].image}");
                                      return ServicePreviewsWidget(
                                        onPress: () {
                                          BlocProvider.of<ServicesPreviewsBloc>(
                                                  blocContext)
                                              .add(DeleteServicePreview(
                                            service_id: widget.id.toString(),
                                            api_token: customerModel!.token,
                                          ));
                                        },
                                        name: state.servicesPreviewsModel[index]
                                            .userName,
                                        image: state
                                            .servicesPreviewsModel[index].image,
                                        date: state.servicesPreviewsModel[index]
                                            .created_at,
                                        preview: state
                                            .servicesPreviewsModel[index]
                                            .preview,
                                      );
                                    },
                                  );
                                } else {
                                  servicePreviewWidget = Center(
                                    child: ErrorScreen(
                                        onPressed: null,
                                        buttonTitle: 'حسنا',
                                        height: screenUtil.orientation ==
                                                Orientation.portrait
                                            ? 400
                                            : 200,
                                        width: screenUtil.orientation ==
                                                Orientation.portrait
                                            ? 400
                                            : 200,
                                        imageName: 'empty.png',
                                        message: 'لا يوجد مراجعات لهذه الخدمه',
                                        withButton: false),
                                  );
                                }
                              }
                            }
                            return servicePreviewWidget;
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
