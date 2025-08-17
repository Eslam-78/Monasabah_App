import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:monasbah/core/widgets/Texts/SubTitleText.dart';
import 'package:monasbah/features/ServiceProviders/mainMenu/data/model/citiesModel.dart';


import '../app_theme.dart';

class CustomDropDownForCities extends StatelessWidget {
  final String hint;
  final bool loading;
  final String dropDownValue;
   var onChange = (newValue) {};
  final List<CitiesModel> dropDownList;


  var dropDownItems;
  CustomDropDownForCities({required this.dropDownValue,required this.onChange,required this.dropDownList,required this.hint, this.loading = false });

  @override
  Widget build(BuildContext context) {
    print('this is dropDownList $dropDownList');
     dropDownItems= dropDownList != null
        ? dropDownList.map<DropdownMenuItem<String>>((CitiesModel item) {
            return DropdownMenuItem<String>(
              value: item.city,
              child: Center(
                child: SubTitleText(
                  text: item.city,
                  textColor: AppTheme.primaryColor,
                  fontSize: 20,
                ),
              ),
            );
          }).toList()
        : null;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 2.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(.03), blurRadius: 8, offset: Offset(0, 4)),
          ],
          color: Colors.white),
      child: loading
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: SpinKitThreeBounce(
                color: AppTheme.primaryColor,
                size: 14
              ),
            )
          : DropdownButton<String>(
              value: dropDownValue,
              underline: Container(),
              isExpanded: true,
              // try make radius
              icon: Icon(Icons.keyboard_arrow_down),
              iconSize: 24,
              elevation: 2,
              style: AppTheme.textTheme.headline2,
              hint: Text(hint, style: AppTheme.textTheme.headline2),
              onChanged: onChange,
              items: dropDownItems,
            ),
    );
  }
}
