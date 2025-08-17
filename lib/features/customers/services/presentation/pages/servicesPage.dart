import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monasbah/core/app_theme.dart';
import 'package:monasbah/core/util/ScreenUtil.dart';
import 'package:monasbah/core/widgets/Buttons/primaryButton.dart';
import 'package:monasbah/core/widgets/Others/Label.dart';
import 'package:monasbah/core/widgets/Others/ScreenLine.dart';
import 'package:monasbah/core/widgets/Others/TextFormFieldContainer.dart';
import 'package:monasbah/core/widgets/Texts/SubTitleText.dart';
import 'package:monasbah/core/widgets/errorScreen.dart';
import 'package:monasbah/core/widgets/screens/ScreenStyle.dart';
import 'package:monasbah/features/customers/adds/presentation/manager/addsBloc.dart';
import 'package:monasbah/features/customers/adds/presentation/manager/addsEvent.dart';
import 'package:monasbah/features/customers/adds/presentation/widget/mySliderBar.dart';
import 'package:monasbah/features/customers/adds/presentation/widget/shimmer/mySliderBarShimmer.dart';
import 'package:monasbah/features/customers/services/presentation/manager/services/servicesState.dart';
import 'package:monasbah/features/customers/services/presentation/pages/ServicesDetailsPage.dart';
import 'package:monasbah/injection_container.dart';
import '../../../../../core/util/common.dart';
import '../../../../users/data/models/customerModel.dart';
import '../../../adds/presentation/manager/addsState.dart';
import '../manager/services/servicesBloc.dart';
import '../manager/services/servicesEvent.dart';
import '../widgets/SearchMethodeWidget.dart';
import '../widgets/ServicesWidget.dart';
import '../widgets/shimmer/ServicesShimmer.dart';

class ServicesPage extends StatefulWidget {
  final String section_id;
  final String section;

  const ServicesPage({required this.section_id, required this.section});

  @override
  State<ServicesPage> createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {
  final ScreenUtil screenUtil = ScreenUtil();
  final _searchFormKey = GlobalKey<FormState>();
  CustomerModel? customerModel;

  // Search variables
  List<String> searchMethods = [];
  int activeSearchIndex = 0;
  DateTime selectedDate = DateTime.now();
  String serviceName = '',
      priceFrom = '',
      priceTo = '',
      scaleFrom = '',
      scaleTo = '';

  // Widgets
  Widget servicesWidget = Container();
  Widget addsWidget = Container();
  late BuildContext blocContext;

  @override
  void initState() {
    super.initState();
    _initCustomer();
    _initSearchMethods();
  }

  void _initCustomer() {
    checkCustomerLoggedIn().fold(
      (customer) => customerModel = customer,
      (error) => customerModel = null,
    );
  }

  void _initSearchMethods() {
    searchMethods = widget.section == 'الصالات'
        ? ['الإسم', 'التاريخ', 'السعر', 'السعه']
        : ['الإسم', 'التاريخ', 'السعر'];
  }

  @override
  Widget build(BuildContext context) {
    screenUtil.init(context);

    return ScreenStyle(
      onTapRightSideIcon: () {},
      rightSideIcon: 'filter1.svg',
      child: SingleChildScrollView(
        child: Column(
          textDirection: TextDirection.rtl,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //القسم الخاص بالاعلانات وبنيتها
            _buildAddsSection(),
            const SizedBox(height: 10),
            ScreenLine(), // دالة ترسم خط اخضر للفصل جزء اعلانات عن الخدمات
            const SizedBox(height: 10),
            Label(labelText: widget.section), //عنوان الخدمة بناء على القسم
            const SizedBox(height: 20),
            _buildSearchMethods(),
            _buildServicesSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildAddsSection() {
    return BlocProvider(
      create: (context) => sl<AddsBloc>(),
      child: BlocConsumer<AddsBloc, AddsState>(
        listener: (context, state) {
          if (state is GetAddsError) {
            _showErrorFlashBar(context, state.errorMessage);
          }
        },
        builder: (context, state) {
          if (state is GetAddsInitial) {
            BlocProvider.of<AddsBloc>(context).add(
              GetSectionAdds(sections_id: widget.section_id),
            );
            return Container();
          } else if (state is GetAddsLoading) {
            return MySliderBarShimmer();
          } else if (state is GetAddsLoaded) {
            return state.addsModel.isEmpty
                ? Center(
                    child: SubTitleText(
                        text: 'لا يوجد إعلانات لهذا القسم',
                        textColor: AppTheme.primaryColor,
                        fontSize: 20))
                : MySliderBar(addsModel: state.addsModel);
          }
          return Container();
        },
      ),
    );
  }

  Widget _buildSearchMethods() {
    return Container(
      padding: const EdgeInsets.all(5),
      height: screenUtil.screenHeight / 10,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        textDirection: TextDirection.rtl,
        children: [
          SubTitleText(
            text: "طريقه البحث : ",
            textColor: AppTheme.primaryColor,
            fontSize: 15,
            fontWeight: FontWeight.bold,
            textAlign: TextAlign.right,
          ),
          SizedBox(
            height: screenUtil.screenHeight * .05,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: searchMethods.length,
              itemBuilder: (context, index) => SearchMethodeWidget(
                onTap: () => _handleSearchMethodTap(index),
                searchMethode: searchMethods[index],
                textColor: Colors.white,
                backgroundColor: activeSearchIndex == index
                    ? AppTheme.primaryColor
                    : AppTheme.primarySwatch.shade500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServicesSection() {
    return BlocProvider(
      create: (context) => sl<ServicesBloc>(),
      child: BlocConsumer<ServicesBloc, ServicesState>(
        listener: (context, state) {
          if (state is GetServicesError) {
            _showErrorFlashBar(context, state.errorMessage);
          }
          if (state is ServiceAddedToFavorite) {
            _showSuccessFlashBar(context, 'تمت الإضافه الى المفضله بنجاح');
          }
        },
        builder: (context, state) {
          blocContext = context;

          if (state is GetServicesInitial) {
            BlocProvider.of<ServicesBloc>(context).add(
              GetServices(section_id: widget.section_id),
            );
            return Container();
          } else if (state is GetServicesLoading) {
            return ServicesShimmer(title: 'خدمه');
          } else if (state is GetServicesLoaded) {
            return state.servicesModel.isEmpty
                ? Center(
                    child: ErrorScreen(
                    height: 300,
                    width: 300,
                    imageName: 'empty.png',
                    message: 'لا يوجد خدمات',
                    onPressed: () => _refreshServices(),
                    buttonTitle: 'اظهر الكل',
                    withButton: true,
                  ))
                : GridView.count(
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    crossAxisCount: 2,
                    children: state.servicesModel
                        .map((service) => ServicesWidget(
                              onTapFavoriteIcon: () => _addToFavorite(service),
                              onTap: () => _navigateToDetails(service),
                              servicePrice: service.price.toString(),
                              serviceName: service.name,
                              imageUri: service.image,
                            ))
                        .toList(),
                  );
          }
          return Container();
        },
      ),
    );
  }

  void _handleSearchMethodTap(int index) {
    setState(() => activeSearchIndex = index);
    _showSearchDialog();
  }

  void _showSearchDialog() {
    final isNameSearch = searchMethods[activeSearchIndex] == 'الإسم';
    final isDateSearch = searchMethods[activeSearchIndex] == 'التاريخ';
    final isPriceSearch = searchMethods[activeSearchIndex] == 'السعر';
    final isScaleSearch = searchMethods[activeSearchIndex] == 'السعه';

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: SizedBox(
          height: screenUtil.screenHeight / 2,
          child: Column(
            children: [
              Expanded(
                flex: 2,
                child: Image.asset(
                  "assets/illustrations/search.png",
                  fit: BoxFit.cover,
                ),
              ),
              Expanded(
                flex: 2,
                child: SingleChildScrollView(
                  child: Form(
                    key: _searchFormKey,
                    child: Column(
                      children: [
                        if (isNameSearch) _buildNameSearchField(),
                        if (isDateSearch) _buildDateSearchField(),
                        if (isPriceSearch) _buildPriceSearchFields(),
                        if (isScaleSearch) _buildScaleSearchFields(),
                        _buildSearchButton(isNameSearch, isDateSearch,
                            isPriceSearch, isScaleSearch),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNameSearchField() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: TextFormFieldContainer(
        hint: "بحث بالإسم",
        onChange: (value) => serviceName = value.trim(),
        validator: (value) => value!.isEmpty ? 'فضلاً إكتب إسم الخدمه' : null,
        autofocus: true,
      ),
    );
  }

  Widget _buildDateSearchField() {
    return GestureDetector(
      onTap: _selectDate,
      child: Container(
        padding: const EdgeInsets.all(8),
        height: screenUtil.height / 28,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: ListTile(
            title: Text(
              "${selectedDate.year}/${selectedDate.month}/${selectedDate.day}",
              style: const TextStyle(fontFamily: "Cocon"),
            ),
            trailing: const Icon(Icons.date_range),
          ),
        ),
      ),
    );
  }

  Widget _buildPriceSearchFields() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: TextFormFieldContainer(
            hint: "السعر من",
            textInputType: TextInputType.number,
            onChange: (value) => priceFrom = value.trim(),
            validator: (value) =>
                value!.isEmpty ? 'فضلاً أدخل السعر الإبتدائي' : null,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: TextFormFieldContainer(
            hint: "السعر الى",
            textInputType: TextInputType.number,
            onChange: (value) => priceTo = value.trim(),
            validator: (value) {
              if (value!.isEmpty) return 'فضلاً أدخل السعر النهائي';
              if (priceFrom.isNotEmpty &&
                  int.parse(value) < int.parse(priceFrom)) {
                return 'الرجاء التأكد من صحه القيم المدخله';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildScaleSearchFields() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: TextFormFieldContainer(
            hint: "من",
            textInputType: TextInputType.number,
            onChange: (value) => scaleFrom = value.trim(),
            validator: (value) =>
                value!.isEmpty ? 'فضلاً أدخل السعه الإبتدائي' : null,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: TextFormFieldContainer(
            hint: "الى",
            textInputType: TextInputType.number,
            onChange: (value) => scaleTo = value.trim(),
            validator: (value) {
              if (value!.isEmpty) return 'فضلاً أدخل السعه النهائي';
              if (scaleFrom.isNotEmpty &&
                  int.parse(value) < int.parse(scaleFrom)) {
                return 'الرجاء التأكد من صحه القيم المدخله';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSearchButton(
      bool isName, bool isDate, bool isPrice, bool isScale) {
    return PrimaryButton(
      marginTop: 0.01, // أو يمكن استخدام 0 إذا كنت تريد إزالة الهامش تماماً
      title: 'بحث',
      backgroundColor: AppTheme.primaryColor,
      textColor: Colors.white,
      onPressed: () {
        if (_searchFormKey.currentState!.validate()) {
          Navigator.pop(context);
          if (isName) {
            _searchByName();
          } else if (isDate) {
            _searchByDate();
          } else if (isPrice) {
            _searchByPrice();
          } else if (isScale) {
            _searchByScale();
          }
        }
      },
    );
  }

  Future<void> _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: selectedDate,
      lastDate: DateTime(selectedDate.year + 10),
    );
    if (date != null) setState(() => selectedDate = date);
  }

  void _searchByName() {
    BlocProvider.of<ServicesBloc>(blocContext).add(
      GetServicesByName(
          section_id: widget.section_id, serviceName: serviceName),
    );
  }

  void _searchByDate() {
    BlocProvider.of<ServicesBloc>(blocContext).add(
      GetServicesByDate(
        section_id: widget.section_id,
        date: '${selectedDate.year}-${selectedDate.month}-${selectedDate.day}',
      ),
    );
  }

  void _searchByPrice() {
    BlocProvider.of<ServicesBloc>(blocContext).add(
      GetServicesByPrice(
        section_id: widget.section_id,
        priceFrom: priceFrom,
        priceTo: priceTo,
      ),
    );
  }

  void _searchByScale() {
    BlocProvider.of<ServicesBloc>(blocContext).add(
      GetServicesByScale(
        section_id: widget.section_id,
        scaleFrom: scaleFrom,
        scaleTo: scaleTo,
      ),
    );
  }

  void _addToFavorite(service) {
    if (customerModel != null) {
      BlocProvider.of<ServicesBloc>(blocContext).add(
        AddToFavorite(
          servicesModel: service,
          customerId: customerModel!.id,
        ),
      );
    }
  }

  void _navigateToDetails(service) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ServiceDetailsPage(servicesModel: service),
        ));
  }

  void _refreshServices() {
    BlocProvider.of<ServicesBloc>(blocContext).add(
      GetServices(section_id: widget.section_id),
    );
  }

  void _showErrorFlashBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showSuccessFlashBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }
}
