import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:monasbah/core/app_theme.dart';
import 'package:monasbah/core/widgets/Buttons/primaryButton.dart';
import 'package:monasbah/core/widgets/Texts/SubTitleText.dart';
import 'package:monasbah/core/widgets/cachedNetworkImage.dart';
import 'package:monasbah/dataProviders/local_data_provider.dart';
import 'package:monasbah/features/customers/cart/data/models/cartModel.dart';
import 'package:monasbah/features/customers/home/data/models/mainMenuSectionsModel.dart';
import 'package:monasbah/features/customers/services/data/models/servicesModel.dart';
import 'package:monasbah/features/users/data/models/customerModel.dart';
import 'package:monasbah/features/users/data/models/serviceProviderModel.dart';
import 'package:monasbah/injection_container.dart';
import 'package:shared_preferences/shared_preferences.dart';

Either<CustomerModel, bool> checkCustomerLoggedIn() {
  try {
    final customer =
        LocalDataProvider(sharedPreferences: sl<SharedPreferences>())
            .getCachedData(
                key: 'CUSTOMER_USER',
                retrievedDataType: CustomerModel.init(),
                returnType: List<CustomerModel>);
    if (customer != null) {
      return Left(customer);
    }
    return Right(false);
  } catch (e) {
    print("checkLoggedIn catch");
    return Right(false);
  }
}

Either<ServiceProviderModel, bool> checkServiceProviderLoggedIn() {
  try {
    final serviceProvider =
        LocalDataProvider(sharedPreferences: sl<SharedPreferences>())
            .getCachedData(
                key: 'SERVICE_PROVIDER_USER',
                retrievedDataType: ServiceProviderModel.init(),
                returnType: List<ServiceProviderModel>);
    if (serviceProvider != null) {
      return Left(serviceProvider);
    }
    return Right(false);
  } catch (e) {
    print("checkLoggedIn catch");
    return Right(false);
  }
}

Either<String, bool> checkOnboarding() {
  try {
    final onboarding =
        LocalDataProvider(sharedPreferences: sl<SharedPreferences>())
            .getCachedData(
                key: 'onbordingShowen',
                retrievedDataType: String,
                returnType: String);
    if (onboarding != null) {
      return Left(onboarding);
    }
    return Right(false);
  } catch (e) {
    print("checkLoggedIn catch");
    return Right(false);
  }
}

Either<ServicesModel, bool> checkCachedService() {
  try {
    final user = LocalDataProvider(sharedPreferences: sl<SharedPreferences>())
        .getCachedData(
            key: 'CACHED_SERVICE',
            retrievedDataType: ServicesModel.init(),
            returnType: List<CustomerModel>);
    if (user != null) {
      return Left(user);
    }
    return Right(false);
  } catch (e) {
    print("checkLoggedIn catch");
    return Right(false);
  }
}

Either<MainMenuSectionsModel, bool> check() {
  try {
    final user = LocalDataProvider(sharedPreferences: sl<SharedPreferences>())
        .getCachedData(
            key: 'CACHED_MAIN_MENU_SECTIONS',
            retrievedDataType: MainMenuSectionsModel.init(),
            returnType: List<MainMenuSectionsModel>);
    if (user != null) {
      return Left(user);
    }
    return Right(false);
  } catch (e) {
    print("checkLoggedIn catch");
    return Right(false);
  }
}

Either<int, bool> checkCart() {
  try {
    final data = LocalDataProvider(sharedPreferences: sl<SharedPreferences>())
        .getCachedData(
            key: 'CACHED_CART',
            retrievedDataType: CartModel.init(),
            returnType: List) as List;

    if (data != null) {
      return Left(data.length);
    }
    return Right(false);
  } catch (e) {
    return Right(false);
  }
}

// دالة تستخدم لعرض الصورة عند النقر عليها
void showImagesDialog(BuildContext context, String image) {
  showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          elevation: 20,
          insetAnimationDuration:
              Duration(seconds: 10), //مدة الأنيميشن عند ظهور الـ Dialog.
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Container(
            height: 300,
            width: 300,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: cachedNetworkImage(image, imagePath: ''),
            ),
          ),
        );
      });
}

void commonDialog(BuildContext context, String iconPath, String message) {
  showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          elevation: 20,
          insetAnimationDuration: Duration(seconds: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Container(
            width: double.infinity,
            height: 250,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
            child: Column(
              children: [
                Positioned(
                  top: -180,
                  child: SvgPicture.asset(iconPath),
                ),
                SizedBox(
                  height: 15,
                ),
                SubTitleText(
                    text: message,
                    textColor: AppTheme.primaryColor,
                    fontSize: 20),
                SizedBox(
                  height: 15,
                ),
                PrimaryButton(
                  title: 'حسناً',
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  marginTop: .01,
                )
              ],
            ),
          ),
        );
      });
}

void loginDialog(BuildContext context, String iconPath, String message) {
  showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          elevation: 20,
          insetAnimationDuration: Duration(seconds: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
            child: Column(
              children: [
                Positioned(
                  top: -40,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: SvgPicture.asset(iconPath),
                  ),
                ),
                SubTitleText(
                    text: message,
                    textColor: AppTheme.primaryColor,
                    fontSize: 20),
                PrimaryButton(
                  title: 'حسناً',
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  marginTop: .01,
                )
              ],
            ),
          ),
        );
      });
}

Future<void> AppDialog({
  required BuildContext context,
  required String svgImage,
  required String message,
  required Function onYesClicked,
  required Function onNoClicked,
  String yesText = "نعم",
  String noText = "لا",
  bool allowPop = true, //هل يُسمح بإغلاق الـ dialog بالرجوع للخلف.
  bool pending = false, //هل نعرض مؤشر انتظار بدل زر نعم.
}) async {
  await showDialog(
    context: context,
    builder: (_) {
      return WillPopScope(
        //WillPopScope تمنع المستخدم من إغلاق الـ dialog إذا كانت allowPop = false.
        onWillPop: () => Future.value(allowPop),
        child: Dialog(
          //Dialog هو الحاوية الأساسية.
          elevation: 0, //elevation: 0: بدون ظل.
          backgroundColor: Colors.transparent,
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 40),
                padding: EdgeInsets.symmetric(
                  vertical: 44,
                  horizontal: 12,
                ).copyWith(
                    bottom: (onYesClicked == null && onNoClicked == null)
                        ? 24.0
                        : 8.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        message,
                        style: Theme.of(context).textTheme.subtitle1?.copyWith(
                              color: AppTheme.primaryColor,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          if (onYesClicked != null)
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ElevatedButton(
                                  onPressed:
                                      pending ? null : () => onYesClicked(),
                                  style: ElevatedButton.styleFrom(
                                    primary: AppTheme.primaryColor,
                                  ),
                                  child: pending
                                      ? Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: SpinKitThreeBounce(
                                            // نعرض دائرة تحميل (SpinKit) بدل النص.
                                            color: AppTheme
                                                .scaffoldBackgroundColor,
                                            size: 15.0,
                                          ),
                                        )
                                      : Text(
                                          yesText,
                                          style: AppTheme.textTheme.headline3
                                              ?.copyWith(
                                            color: Colors.white,
                                          ),
                                        ),
                                ),
                              ),
                            ),
                          if (onNoClicked != null)
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: OutlinedButton(
                                  onPressed: () => onNoClicked(),
                                  style: OutlinedButton.styleFrom(
                                    side: BorderSide(
                                      color: AppTheme.primaryColor,
                                      width: 1.0,
                                    ),
                                  ),
                                  child: Text(
                                    noText,
                                    style: AppTheme.textTheme.headline3,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              //صورة الـ SVG في الأعلى:
              Positioned(
                top: -40,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: SvgPicture.asset(svgImage),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
