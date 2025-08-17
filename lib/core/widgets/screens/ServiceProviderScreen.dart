// ignore: file_names
import 'package:flutter_svg/svg.dart';
import 'package:monasbah/core/app_theme.dart';
import 'package:monasbah/core/others/Constants.dart';
import 'package:monasbah/core/util/ScreenUtil.dart';
import 'package:monasbah/core/util/common.dart';
import 'package:monasbah/core/widgets/Texts/SubTitleText.dart';
import 'package:flutter/material.dart';
import 'package:monasbah/core/widgets/cachedNetworkImage.dart';
import 'package:monasbah/features/customers/settings/presentation/pages/editUserDetailsPage.dart';
import 'package:monasbah/features/users/data/models/serviceProviderModel.dart';

class ServiceProviderScreen extends StatefulWidget {
  final Widget child;
 final String ?title,subTitle,image;
 final bool withEditImageIcon;

 const ServiceProviderScreen({Key? key, required this.child,required this.title,required this.subTitle,required this.image,this.withEditImageIcon=false}) : super(key: key);

  @override
  State<ServiceProviderScreen> createState() => _ServiceProviderScreenState();
}

class _ServiceProviderScreenState extends State<ServiceProviderScreen> {
  ScreenUtil screenUtil=ScreenUtil();

  ServiceProviderModel? serviceProviderModel;
@override
  void initState() {
    checkServiceProviderLoggedIn().fold((l) {
      serviceProviderModel = l;
    }, (r) {
      serviceProviderModel = null;
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    screenUtil.init(context);
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            //Expanded Containers
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    color: AppTheme.primaryColor,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/background.jpg',),
                          fit: BoxFit.cover
                      ),
                    ),
                  ),
                )
              ],
            ),

            Column(
              children: [
                Expanded(
                  flex: screenUtil.orientation == Orientation.portrait ? 1 : 2,
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: AppTheme.primaryColor,
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(70),
                      ),
                    ),
                    height: screenUtil.screenHeight * 1,
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Row(
                        textDirection: TextDirection.rtl,
                        children: [
                          Stack(
                            alignment: Alignment.bottomLeft,
                            children: [
                              Container(
                                height: 100,
                                width: 100,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: GestureDetector(
                                  onTap: (){
                                    widget.image!=null?showImagesDialog(context,widget.image as String ):null;
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(50),

                                    child:widget.image!=null? cachedNetworkImage(widget.image??'', imagePath: widget.image):CircleAvatar(child: Image.asset('assets/images/logo.png'),radius: 50,backgroundColor: Colors.white),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context){
                                    return EditUserDetailsPage(userBrand: 'serviceProvider',image: serviceProviderModel!.image,);
                                  }));
                                },
                                child:widget.withEditImageIcon==true? CircleAvatar(
                                    backgroundColor: Colors.white,
                                    child:SvgPicture.asset("$kIconsPath/edit.svg",height: 20,width: 20,),
                                ):const SizedBox.shrink(),
                              ),
                            ],
                          ),

                          SizedBox(width:screenUtil.orientation ==Orientation.portrait? screenUtil.screenWidth*.1:screenUtil.screenWidth*.25,),
                          Column(
                            children: [
                              SizedBox(height: screenUtil.orientation==Orientation.portrait?screenUtil.screenHeight*.04:screenUtil.screenHeight* .05),
                              SubTitleText(
                                text: widget.title??'',
                                textColor: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              SubTitleText(
                                text: widget.subTitle??'',
                                textColor: Colors.white,
                                fontSize: 15,
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Container(
                      // margin: EdgeInsets.only(top: 170),
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/images/background.jpg',),
                            fit: BoxFit.cover
                        ),
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(70),
                        ),
                      ),
                      width: double.infinity,
                      child: widget.child
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
