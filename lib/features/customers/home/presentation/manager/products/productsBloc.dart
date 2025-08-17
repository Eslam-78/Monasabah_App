import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:monasbah/dataProviders/error/failures.dart';
import 'package:monasbah/features/customers/home/data/repositories/categoriesRepository.dart';
import 'productsEvent.dart';
import 'productsState.dart';

class ProductsBlocBloc extends Bloc<ProductsEvent,ProductsState>{

  final CategoriesRepository repository;
  ProductsBlocBloc({required this.repository})
      : assert(repository != null),
        super(GetSubCategoriesInitial());

  @override
  Stream<ProductsState> mapEventToState(ProductsEvent event) async*{

    if(event is GetProductsEvent){
      yield GetSubCategoriesLoading();
      final failureOrData = await repository.getProducts(
        categoryId: event.categoryId,
        token: event.token,
      );
      yield* failureOrData.fold(
            (failure) async* {
          log('yield is error');

          yield GetSubCategoriesError(message: mapFailureToMessage(failure));
        },
            (data) async* {
          log('yield is loaded');
          yield GeSubCategoriesLoaded(productsModel: data);
        },
      );
    }

    if (event is AddToCartEvent) {
      final failureOrData = await repository.addToCart(cartModel: event.cartModel);
      if (failureOrData) {
        yield ProductAddedToCart();
      } else {
        yield ProductAddedToCartError(
            message: 'حدثت مشكلة أثناء الاضافة للسلة!');
      }
    }

  }



}