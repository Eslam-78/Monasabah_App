import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:monasbah/dataProviders/error/failures.dart';
import 'package:monasbah/features/customers/cart/data/repositories/cartRepository.dart';
import 'package:monasbah/features/customers/locations/data/repository/customerLocationsRepository.dart';
import 'package:monasbah/features/customers/cart/presentation/pages/CartPage.dart';

import 'cartEvent.dart';
import 'cartState.dart';

class CartBloc
    extends Bloc<CartEvent, CartState> {
  final CartRepository repository;
  CartBloc({required this.repository})
      : assert(repository != null),
        super(CartInitial());
  @override
  Stream<CartState> mapEventToState(
      CartEvent event) async* {
    if (event is GetCart) {
      final failureOrData = await repository.getCart();
      yield failureOrData.fold(
            (failure) {
          return CartListError(errorMessage: mapFailureToMessage(failure));
        },
            (data) {
          return CartLoaded(cartList: data);
        },
      );
    }
    else if (event is UpdateCart) {
      await repository.updateCart(cart: event.cart);
    }
  }
}
