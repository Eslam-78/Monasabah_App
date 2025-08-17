class DataSourceURL {
  static String baseUrl = 'http://192.168.0.124/api/';
  static String baseImagesUrl = 'http://192.168.0.124/';

  ///necessary
  static String signup = 'signup';
  static String login = 'login';
  static String logout = 'logout';
  static String sendConfirmCode = 'send/confirm/code';
  static String checkConfirmCode = 'check/confirm/code';
  static String editPassword = 'edit/password';
  static String editUserDetails = 'edit/user/details';

  ///necessary MAIN MENU
  static String mainMenuAdds = 'customer/get/all/adds';
  static String mainMenuSections = 'customer/get/sections';
  static String mainMenuMostBookedServices =
      'customer/get/most/Booked/Services';
  static String mainMenuMostRatedServices = 'customer/get/most/rated/services';

  ///services
  static String sectionsAdds = 'customer/get/adds/of/section';
  static String servicesOfSection = 'customer/get/services/of/section';
  static String servicesOfServiceProvider =
      'serviceProvider/get/services/of/service/provider';
  static String getServicePreviews = 'customer/get/service/previews';
  static String addServicePreview = 'customer/add/service/preview';
  //delete
  static String deleteServicePreview = 'customer/delete/service/preview';
  static String getServiceReservations = 'customer/get/service/reservations';
  static String getCustomerReservations = 'customer/get/customer/reservations';
  static String addOrder = 'customer/add/customer/order';
  static String getCustomerOrders = 'customer/get/customer/orders';
  static String addServiceReservation = 'customer/add/service/reservation';

  ///services details
  static String getServiceAddress = 'customer/get/service/address';
  static String getServiceRating = 'customer/get/service/rating';
  static String getServiceImages = 'customer/get/service/images';
  static String getCustomerServiceImages =
      'customer/get/service/customer/rating';
  static String addCustomerRate = 'customer/customer/rate';

  ///customer locations
  static String addNewCustomerLocation = 'customer/add/new/customer/location';
  static String customerLocations = 'customer/get/customer/locations';
  static String removeCustomerLocations = 'customer/remove/customer/location';

  ///necessary
  static String mainMenuCategories = 'customer/get/categories';
  static String mainMenuSubCategories = 'customer/get/products';

  ///necessary
  static String appDetails = 'customer/get/app/details';
  static String appSocialMedia = 'customer/get/social/media/accounts';

  ///service Provider
  static String getCities = 'serviceProvider/get/cities';
  static String editSingleDetailOfService =
      'serviceProvider/edit/single/detail/of/service';
  static String addNewService = 'serviceProvider/add/new/service';
  static String addNewServiceImage = 'serviceProvider/add/new/service/image';
  static String editServiceDetails = 'serviceProvider/edit/service/details';
  static String blockDateReservation = 'serviceProvider/block/date/reservation';
  static String getHighlightedDates = 'serviceProvider/get/highlighted/Dates';
  static String acceptReservation = 'serviceProvider/accept/reservation';
  static String declineReservation = 'serviceProvider/decline/reservation';
  static String removeService = 'serviceProvider/remove/service';
  static String getReservationsReport =
      'serviceProvider/get/provider/service/reservations'; // URL الجديد لتقارير الحجوزات

  ///filters
  ///services
  static String filterServicesByNameAsc =
      'customer/filter/services/by/name/asc';
  static String filterServicesByNameDesc =
      'customer/filter/services/by/name/Desc';
  static String filterServicesByPriceAsc =
      'customer/filter/services/by/price/asc';
  static String filterServicesByPriceDesc =
      'customer/filter/services/by/price/Desc';
  static String filterServicesByMostBooked =
      'customer/filter/services/by/most/booked';
  static String filterServicesByMostRated =
      'customer/filter/services/by/most/rated';

  ///products
  static String filterProductsByPriceAsc = 'filter/products/by/price/asc';
  static String filterProductsByPriceDesc = 'filter/products/by/price/Desc';

  ///search
  ///services
  static String searchAllServicesByName =
      'customer/search/all/services/by/name';
  static String searchServicesByName = 'customer/search/services/by/name';
  static String searchServicesByDate = 'customer/search/services/by/date';
  static String searchServicesByPrice = 'customer/search/services/by/price';
  static String searchServicesByScale = 'customer/search/services/by/scale';

  ///products
  static String searchAllProductsByName =
      'customer/search/all/products/by/name';

  /// Reports

}
