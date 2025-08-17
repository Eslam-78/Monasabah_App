import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monasbah/core/app_theme.dart';
import 'package:monasbah/core/others/MyFlashBar.dart';
import 'package:monasbah/core/util/ScreenUtil.dart';
import 'package:monasbah/core/widgets/Others/Label.dart';
import 'package:monasbah/core/widgets/Others/ScreenLine.dart';
import 'package:monasbah/core/widgets/errorScreen.dart';
import 'package:monasbah/core/widgets/screens/ScreenStyle.dart';
import 'package:monasbah/features/customers/cart/data/models/cartModel.dart';
import 'package:monasbah/features/customers/home/presentation/manager/categories/CategoriesBloc.dart';
import 'package:monasbah/features/customers/home/presentation/manager/categories/categoriesEvent.dart';
import 'package:monasbah/features/customers/home/presentation/manager/categories/categoriesState.dart';
import 'package:monasbah/features/customers/home/presentation/manager/products/productsEvent.dart';
import 'package:monasbah/features/customers/home/presentation/manager/products/productsState.dart';
import 'package:monasbah/features/customers/home/presentation/widgets/HomeSectionsWidget.dart';
import 'package:monasbah/features/customers/home/presentation/widgets/OurServicesContainerItems.dart';
import 'package:flutter/material.dart';
import 'package:monasbah/features/customers/home/presentation/widgets/shimmer/homeSectionSimmer.dart';
import 'package:monasbah/features/customers/home/presentation/widgets/shimmer/ourServicesShimmer.dart';
import 'package:monasbah/injection_container.dart';

import '../manager/products/productsBloc.dart';

class ProductsPage extends StatefulWidget {
  late String token="";
  String categoryId='1';
  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  ScreenUtil screenUtil = ScreenUtil();
  late BuildContext categoriesContext,subCategoriesContext;
   Widget categoriesWidget=Container(),productsWidget=Container();
  int SectionIndexColor=0; ///to make the selected section with dark color and other with opacity
  int amount=1;
  late BuildContext rootContext;
  @override
  Widget build(BuildContext context) {
    screenUtil.init(context);
    return ScreenStyle(
      onTapRightSideIcon: (){},
      rightSideIcon: 'filter1.svg',
      child: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: SingleChildScrollView(
          child: Column(
            textDirection: TextDirection.rtl,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Label(labelText: "الأصناف"),
              SizedBox(
                height: 20,
              ),

              /// categories bloc
              BlocProvider(
                create: (context) => sl<CategoriesBloc>(),
                child: BlocConsumer<CategoriesBloc,CategoriesState>(listener: (_context, state) {
                  if (state is GetCategoriesError) {
                    MyFlashBar(
                        title: 'خطأ',
                        context: context,
                        icon: Icons.error,
                        iconColor: Colors.white,
                        backgroundColor: Colors.red,
                        message: state.message,
                        thenDo: () {
                          print(state.message);
                        }).showFlashBar();
                  }
                }, builder: (_context, state) {
                  categoriesContext=_context;
                  if (state is GetCategoriesInitial) {
                    BlocProvider.of<CategoriesBloc>(categoriesContext).add(
                      GetCategoriesEvent(token: widget.token),
                    );
                  } else if (state is GetCategoriesLoading) {
                    categoriesWidget= HomeSectionSimmer(title: 'الصنف');
                  } else if (state is GetCategoriesLoaded) {
                    if (state.categoriesModel != null) {
                      if (state.categoriesModel.isNotEmpty) {
                        categoriesWidget=SizedBox(
                          height: screenUtil.orientation == Orientation.portrait
                              ? screenUtil.screenHeight / 5
                              : screenUtil.screenWidth / 5,
                          child: ListView.builder(
                            itemCount: state.categoriesModel.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return HomeSectionsWidget(

                                containerColor: SectionIndexColor==index? AppTheme.primaryColor:AppTheme.primarySwatch.shade500,
                                onTap: () {
                                  print(state.categoriesModel[index].id);
                                  BlocProvider.of<ProductsBlocBloc>(subCategoriesContext).add(
                                      GetProductsEvent(token: widget.token,categoryId: state.categoriesModel[index].id.toString())
                                  );
                                  print(state.categoriesModel[index].id);
                                  setState(() {
                                    SectionIndexColor=index;
                                    widget.categoryId=state.categoriesModel[0].id.toString();
                                  });
                                },
                                title: state.categoriesModel[index].categoryName,
                                imageUri:
                                    state.categoriesModel[index].categoryImage,
                              );
                            },
                          ),
                        );
                      }
                    }
                  }
                  return categoriesWidget;
                }),
              ),
              /// categories bloc

              SizedBox(
                height: 10,
              ),
              ScreenLine(),
              SizedBox(
                height: 10,
              ),

              Label(labelText: "المنتجات"),


              ///products categories bloc

              BlocProvider(
                create: (context)=>sl<ProductsBlocBloc>(),
                child: BlocConsumer<ProductsBlocBloc,ProductsState>(

                  listener: (_context,state) {
                    rootContext=_context;

                    if(state is GetSubCategoriesError){
                      MyFlashBar(
                          title: 'خطأ',
                          context: context,
                          icon: Icons.error,
                          iconColor: Colors.white,
                          backgroundColor: Colors.red,
                          message: state.message,
                          thenDo: () {
                            print(state.message);
                          }).showFlashBar();
                    }

                    if(state is ProductAddedToCartError){
                      MyFlashBar(
                          title: 'خطأ',
                          context: context,
                          icon: Icons.error,
                          iconColor: Colors.white,
                          backgroundColor: Colors.red,
                          message: state.message,
                          thenDo: () {
                            print(state.message);
                          }).showFlashBar();
                    }

                    if (state is ProductAddedToCart) {
                      MyFlashBar(title:'تم', context: context,icon: Icons.check,iconColor: Colors.white,
                          backgroundColor: Colors.green.shade600,message: 'تمت الإضافه الى السله بنجاح',thenDo: (){
                            BlocProvider.of<ProductsBlocBloc>(subCategoriesContext).add(
                                GetProductsEvent(token: widget.token,categoryId: widget.categoryId));
                          }).showFlashBar();

                    }

                  },
                  builder: (_context,state){
                    subCategoriesContext=_context;
                    if (state is GetSubCategoriesInitial) {
                      BlocProvider.of<ProductsBlocBloc>(subCategoriesContext).add(
                        GetProductsEvent(token: widget.token,categoryId: widget.categoryId),
                      );
                    }else if (state is GetSubCategoriesLoading) {
                      productsWidget= ourServicesShimmer();
                    }else if(state is GeSubCategoriesLoaded){
                      if(state.productsModel!=null){
                        if(state.productsModel.isNotEmpty){
                          productsWidget=Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),

                            child: ListView.builder(
                              itemCount: state.productsModel.length,
                              shrinkWrap: true,
                              physics: ClampingScrollPhysics(),
                            scrollDirection: Axis.vertical,
                              itemBuilder: (context, index) {
                                return OurServicesContainerItems(
                                  withCartIcon: true,
                                  imageUrl: state.productsModel[index].Image,
                                    productName: state.productsModel[index].name,
                                    unitPrice: state.productsModel[index].unitPrice,
                                    quantity: state.productsModel[index].quantity,
                                    total:state.productsModel[index].quantity*state.productsModel[index].unitPrice,
                                    unit: state.productsModel[index].unit,
                                    onTap: (){


                                    },
                                  onChange: (value){
                                    setState(() {
                                      state.productsModel[index].quantity=int.parse(value);
                                    });
                                  },
                                    onTapUp: (){
                                      setState(() {
                                        state.productsModel[index].quantity=state.productsModel[index].quantity+1;
                                        state.productsModel[index].totalPrice=state.productsModel[index].totalPrice+state.productsModel[index].unitPrice;

                                      });
                                    },
                                    onTapDown: (){
                                      setState(() {
                                        state.productsModel[index].quantity>1?state.productsModel[index].quantity--:null;
                                        state.productsModel[index].quantity>1?state.productsModel[index].totalPrice=state.productsModel[index].totalPrice-state.productsModel[index].unitPrice:null;
                                      });
                                    },
                                  onTapCart: (){
                                    print(state.productsModel[index].quantity);
                                    BlocProvider.of<ProductsBlocBloc>(_context).add(
                                      AddToCartEvent(cartModel: CartModel(
                                        id:  state.productsModel[index].id,
                                        category_id: state.productsModel[index].category_id,
                                        name:  state.productsModel[index].name,
                                        unitPrice:  state.productsModel[index].unitPrice,
                                        totalPrice:state.productsModel[index].quantity==1? state.productsModel[index].unitPrice: state.productsModel[index].totalPrice,
                                        unit:  state.productsModel[index].unit,
                                        quantity:   state.productsModel[index].quantity,
                                        image: state.productsModel[index].Image,
                                      )),
                                    );
                                  },

                                );
                              },
                            ),

                          );
                        }
                      }
                    }else{
                      productsWidget=Center(
                        child: ErrorScreen(height: screenUtil.orientation==Orientation.portrait?200:200,width: screenUtil.orientation==Orientation.portrait?400:200,imageName: 'empty.png',message: 'لا يوجد منتجات لهذا الصنف في الوقت الحالي',withButton: false,),
                      );
                    }
                    return productsWidget;
                  },
                ),
              ),

              ///products categories bloc

            ],
          ),
        ),
      ),
    );
  }
}
