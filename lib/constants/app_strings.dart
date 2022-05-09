import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppStrings {
  static String karkarBaseUrl = dotenv.env['API_URL'] ?? '';

  static const String languageKey = 'lan_pref_key';
  static const String userPrefKey = 'user_pref_key';
  static const String staticMapBaseUrl = "https://maps.googleapis.com/maps/api/staticmap";
  static String mapUrl(String lat, String lng) => "https://maps.google.com/?q=$lat,$lng";
  static const String mapAPIKEY = 'AIzaSyBOOXEMMpDtojNMDmRe3rGjr-s77LC15PY';
  // static String countryList = '$karkarBaseUrl/country';
  static String countryList = karkarBaseUrl + '/country';

  // --- User login ---
  static String sendOTP = karkarBaseUrl + '/users/send-otp';
  static String register = karkarBaseUrl + '/users/register';
  static String verifyOtp = karkarBaseUrl + '/users/verify-otp';
  static String usersLogout = karkarBaseUrl + '/users/logout';
  static String usersDetails = karkarBaseUrl + '/users/detail';
  static String usersEdit = karkarBaseUrl + '/users/edit';
  static String setting = karkarBaseUrl + '/settings';
  static String addSupport = karkarBaseUrl + '/support/add';
  static String faqs = karkarBaseUrl + '/faq';
  static String reviewList = karkarBaseUrl + '/review';
  static String bookingList = karkarBaseUrl + '/bookings';
  static String aroundList = karkarBaseUrl + '/around';
  static String addaroundList = karkarBaseUrl + '/users/arounds/add';
  static String useraroundList = karkarBaseUrl + '/users/arounds';
  static String termsandconditionlist = karkarBaseUrl + '/settings';
  static String userServicesList = karkarBaseUrl + '/users/services';
  static String servicesList = karkarBaseUrl + '/services';
  static String addservices = karkarBaseUrl + '/users/services/add';
  static String providersOffers = karkarBaseUrl + '/providers/offers';
  static String offerPlan = karkarBaseUrl + '/offer-plans';
  static String beginCheckOut = karkarBaseUrl + '/providers/offers/create-begin-checkout';
  static String createOffer = karkarBaseUrl + '/providers/offers/create';
  static String chatSendNotification = karkarBaseUrl + '/users/chat/send-notification';
  static String chatList = karkarBaseUrl + '/users/chat/list';

  static String bookingDetials(int id) => '$karkarBaseUrl/bookings/$id';
  static String deleteBooking(int id) => '$karkarBaseUrl/bookings/$id/decline';
  static String acceptBooking(int id) => '$karkarBaseUrl/bookings/$id/accept';
  static String finisedBooking(int id) => '$karkarBaseUrl/bookings/$id/finish';
  static String cancelOffer(int id) => '$karkarBaseUrl/providers/offers/$id/cancel';
  static String googleSearch(String text) =>
      'https://maps.googleapis.com/maps/api/place/textsearch/json?query=$text&key=AIzaSyBOOXEMMpDtojNMDmRe3rGjr-s77LC15PY';

  //MAP Api key
  static const String MAP_API_KEY = 'AIzaSyBOOXEMMpDtojNMDmRe3rGjr-s77LC15PY';

  //Chat
  static const String messageTypeText = 'TEXT';
  static const String messageTypeImage = 'IMAGE';
  static const String messageTypeLocation = 'LOCATION';
  static const String messageTypePayment = 'PAYMENT';

  static const String chatPaymentStatusPending = 'PENDING';
  static const String chatPaymentStatusPaid = 'PAID';
}
