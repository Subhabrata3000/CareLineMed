// ignore_for_file: prefer_const_constructors, unused_import

import 'package:get/get.dart';
import 'package:laundry/screen/bottombarpro_screen.dart';
import 'package:laundry/screen/coupon_screen.dart';
import 'package:laundry/screen/loream_screen.dart';
import 'package:laundry/screen/my%20booking/mybooking_screen.dart';
import 'package:laundry/screen/notification_screen.dart';
import 'package:laundry/screen/shop/shop_coupon_screen.dart';
import '../screen/add_location/addressdetails_screen.dart';
import '../screen/add_location/deliveryaddress1.dart';
import '../screen/add_location/deliveryaddress2.dart';
import '../screen/authentication/onbording_screen.dart';
import 'package:laundry/screen/profile_screen.dart';
import 'package:laundry/screen/refer_earn_screen.dart';
import 'package:laundry/screen/wallet/wallethistory_screen.dart';

class Routes {
  static String initial = "/";
  static String homeScreen = "/homeScreen";
  static String categoryScreen = "/categoryScreen";
  static String categoryDetailsScreen = "/categoryDetailsScreen";
  static String bottombarProScreen = "/bottombarProScreen";
  static String couponScreen = "/couponScreen";
  static String deliveryaddress1 = "/deliveryaddress1";
  static String deliveryaddress2 = "/deliveryaddress2";
  static String addressDetailsScreen = "/addressDetailsScreen";
  static String prescriptionDetails = "/prescriptionDetails";
  static String profileScreen = "/profileScreen";
  static String myBookingScreen = "/myBookingScreen";
  //! ----------- Login And Signup -----------!//
  static String loginScreen = "/loginScreen";
  static String signUpScreen = "/signUpScreen";
  static String otpScreen = '/otpScreen';
  static String resetPassword = "/resetPassword";
  //!---------------------------------------!//
  static String loream = "/loream";
  static String orderdetailsScreen = "/OrderdetailsScreen";
  static String myPriscriptionOrder = "/MyPriscriptionOrder";
  static String myPriscriptionInfo = "/MyPriscriptionInfo";

  static String walletHistoryScreen = "/walletHistoryScreen";
  static String addWalletScreen = "/addWalletScreen";

  static String referFriendScreen = "/referFriendScreen";
  static String notificationScreen = "/notificationScreen";

  static String subScribeScreen = "/subScribeScreen";
  static String shopCouponScreen = "/shopCouponScreen";
}

final getPages = [
  GetPage(
    name: Routes.initial,
    page: () => SplashScreen(),
  ),
  GetPage(
    name: Routes.homeScreen,
    page: () => BottomBarScreen(),
  ),
  GetPage(
    name: Routes.bottombarProScreen,
    page: () => BottomBarScreen(),
  ),
  GetPage(
    name: Routes.couponScreen,
    page: () => CouponScreen(),
  ),
  GetPage(
    name: Routes.deliveryaddress1,
    page: () => DeliveryAddress1(),
  ),
  GetPage(
    name: Routes.deliveryaddress2,
    page: () => DelieryAddress2(),
  ),
  GetPage(
    name: Routes.addressDetailsScreen,
    page: () => AddressDetailsScreen(),
  ),
  GetPage(
    name: Routes.profileScreen,
    page: () => ProfileScreen(),
  ),
  GetPage(
    name: Routes.myBookingScreen,
    page: () => MyBookingScreen(),
  ),

   GetPage(
    name: Routes.loream,
    page: () => Loream(),
  ),

  GetPage(
    name: Routes.walletHistoryScreen,
    page: () => WalletHistoryScreen(),
  ),
  // GetPage(
  //   name: Routes.addWalletScreen,
  //   page: () => AddWalletScreen(),
  // ),
  GetPage(
    name: Routes.referFriendScreen,
    page: () => ReferFriendScreen(),
  ),
  GetPage(
    name: Routes.shopCouponScreen,
    page: () => ShopCouponScreen(),
  ),
];
