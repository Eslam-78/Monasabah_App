
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:monasbah/dataProviders/local_data_provider.dart';
import 'package:monasbah/dataProviders/network/Network_info.dart';
import 'package:monasbah/dataProviders/remote_data_provider.dart';
import 'package:monasbah/features/ServiceProviders/mainMenu/data/repository/serviceProviderRepository.dart';
import 'package:monasbah/features/ServiceProviders/mainMenu/presintaion/manager/cities/citiesBloc.dart';
import 'package:monasbah/features/customers/adds/data/repositories/addsRepository.dart';
import 'package:monasbah/features/customers/adds/presentation/manager/addsBloc.dart';
import 'package:monasbah/features/customers/cart/data/repositories/cartRepository.dart';
import 'package:monasbah/features/customers/locations/data/repository/customerLocationsRepository.dart';
import 'package:monasbah/features/customers/cart/presentation/manager/cart/cartBloc.dart';
import 'package:monasbah/features/customers/locations/presentation/manager/customerLocationsBloc.dart';
import 'package:monasbah/features/customers/home/data/repositories/aboutAppRepository.dart';
import 'package:monasbah/features/customers/home/data/repositories/mainMinuRepository.dart';
import 'package:monasbah/features/customers/home/data/repositories/myOrdersRepository.dart';
import 'package:monasbah/features/customers/home/presentation/manager/aboutApp/aboutAppBloc.dart';
import 'package:monasbah/features/customers/home/presentation/manager/categories/CategoriesBloc.dart';
import 'package:monasbah/features/customers/home/presentation/manager/favorite/favoriteBloc.dart';
import 'package:monasbah/features/customers/home/presentation/manager/mainMenu/mainMenuBloc.dart';
import 'package:monasbah/features/customers/services/data/repositories/servicePreviewsRepository.dart';
import 'package:monasbah/features/customers/services/data/repositories/servicesDetailsRepository.dart';
import 'package:monasbah/features/customers/services/data/repositories/servicesReservationsRepository.dart';
import 'package:monasbah/features/customers/services/presentation/manager/servicePreview/servicesPreviewsBloc.dart';
import 'package:monasbah/features/customers/services/presentation/manager/serviceReservations/servicesReservationsBloc.dart';
import 'package:monasbah/features/customers/services/presentation/manager/servicesDetails/servicesDetailsBloc.dart';
import 'package:monasbah/features/users/data/repositories/editUserDetailsRepository.dart';

import 'package:monasbah/features/users/data/repositories/registrationRepository.dart';
import 'package:monasbah/features/users/presentation/manager/editUserDetails/editUsersDetailsBloc.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'features/customers/home/data/repositories/categoriesRepository.dart';
import 'features/customers/home/data/repositories/favoriteRepository.dart';
import 'features/customers/home/presentation/manager/myOrders/myOrdersBloc.dart';
import 'features/customers/home/presentation/manager/products/productsBloc.dart';
import 'features/customers/services/data/repositories/ReservationsReportRepository.dart';
import 'features/customers/services/data/repositories/servicesRepository.dart';
import 'features/customers/services/presentation/manager/ReservationsReport/ReservationsReportBloc.dart';
import 'features/customers/services/presentation/manager/services/servicesBloc.dart';
import 'features/users/presentation/manager/registration/registrationBloc.dart';

final sl = GetIt.instance; //sl = service locator

Future<void> init() async {
  print('start injection');

//  ! Features
  _initRegisterFeature();
  _initEditUserDetailsFeature();
  _initAddsFeature();
  _initMainMenuSectionsFeature();
  _initMainMenuOurServicesFeature();
  _initSAboutAppFeature();
  _initCustomerAddressesFeature();
  _initServicesFeature();
  _initServicesDetailsFeature();
  _initServicesPreviewsFeature();
  _initCartFeature();
  _initServicesReservationsFeature();
  _initFavoriteFeature();
  _initCitiesFeature();
  _initMyOrdersFeature();
  _initReservationsReportFeature();


  ///service provider

  //! Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
  //data providers

  // data sources
  sl.registerLazySingleton<RemoteDataProvider>(() => RemoteDataProvider(client: sl()));
  sl.registerLazySingleton<LocalDataProvider>(() => LocalDataProvider(sharedPreferences: sl()));

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => DataConnectionChecker());

}



void _initRegisterFeature() {
//bloc
  sl.registerFactory(() => RegistrationBloc(repository: sl()));

  //repositories
  sl.registerLazySingleton<RegistrationRepository>(
    () => RegistrationRepository(
      remoteDataProvider: sl(),
      localDataProvider: sl(),
      networkInfo: sl(),
    ),
  );

}

void _initEditUserDetailsFeature() {
//bloc
  sl.registerFactory(() => EditUserDetailsBloc(repository: sl()));

  //repositories
  sl.registerLazySingleton<EditUserDetailsRepository>(
    () => EditUserDetailsRepository(
      remoteDataProvider: sl(),
      localDataProvider: sl(),
      networkInfo: sl(),
    ),
  );

}

void _initAddsFeature(){
  sl.registerFactory(() => AddsBloc(repository: sl()));

  //repositories
  sl.registerLazySingleton<AddsRepository>(
        () => AddsRepository(
      remoteDataProvider: sl(),
      localDataProvider: sl(),
      networkInfo: sl(),
    ),
  );

}
void _initMainMenuSectionsFeature(){
  sl.registerFactory(() => MainMenuBloc(repository: sl()));

  //repositories
  sl.registerLazySingleton<MainMenuRepository>(
  () => MainMenuRepository(
  remoteDataProvider: sl(),
  localDataProvider: sl(),
  networkInfo: sl(),
  ),
  );

}

void _initMainMenuOurServicesFeature(){
  sl.registerFactory(() => CategoriesBloc(repository: sl()));
  sl.registerFactory(() => ProductsBlocBloc(repository: sl()));

  //repositories
  sl.registerLazySingleton<CategoriesRepository>(
        () => CategoriesRepository(
      remoteDataProvider: sl(),
      localDataProvider: sl(),
      networkInfo: sl(),
    ),
  );

}

void _initFavoriteFeature(){
  sl.registerFactory(() => FavoriteBloc(repository: sl()));

  sl.registerLazySingleton<FavoriteRepository>(
        () => FavoriteRepository(
      remoteDataProvider: sl(),
      localDataProvider: sl(),
      networkInfo: sl(),
    ),
  );

}

void _initCustomerAddressesFeature(){
  sl.registerFactory(() => CustomerLocationsBloc(repository: sl()));

  //repositories
  sl.registerLazySingleton<CustomerLocationsRepository>(
        () => CustomerLocationsRepository(
      remoteDataProvider: sl(),
      localDataProvider: sl(),
      networkInfo: sl(),
    ),
  );

}

void _initServicesFeature(){
  sl.registerFactory(() => ServicesBloc(repository: sl()));

  //repositories
  sl.registerLazySingleton<ServicesRepository>(
        () => ServicesRepository(
      remoteDataProvider: sl(),
      localDataProvider: sl(),
      networkInfo: sl(),
    ),
  );

}

void _initServicesDetailsFeature(){
  sl.registerFactory(() => ServicesDetailsBloc(repository: sl()));

  //repositories
  sl.registerLazySingleton<ServicesDetailsRepository>(
        () => ServicesDetailsRepository(
      remoteDataProvider: sl(),
      localDataProvider: sl(),
      networkInfo: sl(),
    ),
  );

}

void _initServicesPreviewsFeature(){
  sl.registerFactory(() => ServicesPreviewsBloc(repository: sl()));

  //repositories
  sl.registerLazySingleton<ServicesPreviewsRepository>(
        () => ServicesPreviewsRepository(
      remoteDataProvider: sl(),
      localDataProvider: sl(),
      networkInfo: sl(),
    ),
  );

}

void _initServicesReservationsFeature(){
  sl.registerFactory(() => ServicesReservationsBloc(repository: sl()));

  //repositories
  sl.registerLazySingleton<ServicesReservationsRepository>(
        () => ServicesReservationsRepository(
      remoteDataProvider: sl(),
      localDataProvider: sl(),
      networkInfo: sl(),
    ),
  );

}

void _initCitiesFeature(){
  sl.registerFactory(() => CitiesBloc(repository: sl()));

  //repositories
  sl.registerLazySingleton<ServiceProviderRepository>(
        () => ServiceProviderRepository(
      remoteDataProvider: sl(),
      localDataProvider: sl(),
      networkInfo: sl(),
    ),
  );

}

void _initMyOrdersFeature(){
  sl.registerFactory(() => MyOrdersBloc(repository: sl()));

  //repositories
  sl.registerLazySingleton<MyOrdersRepository>(
        () => MyOrdersRepository(
      remoteDataProvider: sl(),
      localDataProvider: sl(),
      networkInfo: sl(),
    ),
  );

}

void _initSAboutAppFeature(){
  sl.registerFactory(() => AboutAppBloc(repository: sl()));

  sl.registerLazySingleton<AboutAppRepository>(
        () => AboutAppRepository(
      remoteDataProvider: sl(),
      localDataProvider: sl(),
      networkInfo: sl(),
    ),
  );

}

void _initCartFeature(){
  sl.registerFactory(() => CartBloc(repository: sl()));

  sl.registerLazySingleton<CartRepository>(
        () => CartRepository(
      remoteDataProvider: sl(),
      localDataProvider: sl(),
      networkInfo: sl(),
    ),
  );

}

void _initReservationsReportFeature() {
  sl.registerFactory(() => ReservationsReportBloc(repository: sl()));

  sl.registerLazySingleton<ReservationsReportRepository>(
        () => ReservationsReportRepository(
      remoteDataProvider: sl(),
      localDataProvider: sl(),
      networkInfo: sl(),
    ),
  );
}








