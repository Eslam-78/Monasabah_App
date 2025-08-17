import 'package:flutter/services.dart';
import 'package:monasbah/core/app_theme.dart';
import 'package:monasbah/core/others/constants.dart';
import 'package:monasbah/core/widgets/AppSpecialContainer.dart';
import 'package:monasbah/core/widgets/Others/TextFormFieldContainer.dart';
import 'package:monasbah/core/widgets/Texts/SubTitleText.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class OurServicesContainerItems extends StatelessWidget {
  final _FormKey = GlobalKey<FormState>();
  String productName, unit, imageUrl;
  dynamic unitPrice, total, initialValue;
  int quantity;
  Function? onTap, onTapUp, onTapDown, onTapCart, onTepRemove;
  bool withCartIcon, withRemoveIcon;
  var onChange = (newValue) {};

  OurServicesContainerItems(
      {required this.productName,
      required this.unitPrice,
      required this.quantity,
      required this.total,
      required this.unit,
      required this.onTap,
      required this.onTapUp,
      required this.onTapDown,
      this.imageUrl = 'shimmer',
      this.withCartIcon = false,
      this.withRemoveIcon = false,
      this.onTapCart = null,
      this.onTepRemove = null,
      required this.onChange,
      this.initialValue = '1'});

  @override
  Widget build(BuildContext context) {
    print('reload');
    return GestureDetector(
        onTap: () {
          onTap!();
        },
        child: AppSpecialContainer(
          image: imageUrl,
          marginTop: 50,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    flex: 3,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SubTitleText(
                            text: productName,
                            textColor: AppTheme.primaryColor,
                            fontSize: 20,
                          ),

                          SubTitleText(
                            text: ' سعر الوحده :  Y.R ${unitPrice}',
                            textColor: AppTheme.primaryColor,
                            fontSize: 15,
                          ),
                          SubTitleText(
                            text: "نوع الوحده : ${unit}",
                            textColor: AppTheme.primaryColor,
                            fontSize: 15,
                          ),

                          SubTitleText(
                            text: "الإجمالي ${total.toString()} Y.R",
                            textColor: AppTheme.primaryColor,
                            fontSize: 13,

                          ),
                          Row(
                            textDirection: TextDirection.rtl,
                            children: [
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                flex: 2,
                                child: GestureDetector(
                                  child: SvgPicture.asset('${kIconsPath}/up.svg'),
                                  onTap: () {
                                    onTapUp!();
                                  },
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: TextFormField(
                                  textAlign: TextAlign.right,
                                  initialValue: initialValue.toString(),
                                  style: TextStyle(
                                      color: AppTheme.primaryColor,
                                      fontFamily: AppTheme.fontFamily),
                                  keyboardType: TextInputType.number,
                                  validator: (value) {},
                                  textDirection: TextDirection.rtl,

                                  onChanged: onChange,
                                ),),
                              Expanded(
                                flex: 1,
                                child: GestureDetector(
                                  child: SvgPicture.asset(
                                    '${kIconsPath}/down.svg',
                                  ),
                                  onTap: () {
                                    onTapDown!();
                                  },
                                ),
                              ),
                              Visibility(
                                visible: withCartIcon,
                                child: Expanded(
                                  flex: 1,
                                  child: GestureDetector(
                                    child: SvgPicture.asset(
                                      '${kIconsPath}/cart2.svg',
                                    ),
                                    onTap: () {
                                      onTapCart!();
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),

                        ],
                      ),
                    ),
                  ),



                ],
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Visibility(
                  visible: withRemoveIcon,
                  child: GestureDetector(
                    onTap: () {
                      onTepRemove!();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SvgPicture.asset(
                        '${kIconsPath}/Delete.svg',
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
