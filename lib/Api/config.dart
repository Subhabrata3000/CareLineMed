import 'data_store.dart';

String agoraVcKey = "${getData.read("agoraVcKey")}";
String oneSignelKey = "${getData.read("OneSignalKey")}";
String googleMapKey = "${getData.read("GoogleMapKey")}";

class Config {
  static const String oneSignel = "c83f10d2-633c-4f53-9afb-609e57c8b701";

  static String socketUrlDoctor = "https://admindoc.digontom.com";

  static String imageBaseurlDoctor = "$socketUrlDoctor/";
  static String chatUrlDoctor = "${imageBaseurlDoctor}chat/";
  static String baseUrlDoctor = "${imageBaseurlDoctor}customer/";

  static String paypal = "paypal-payment";
  static String cancelPaypal = "paypal-success";

  static String strip = "strip-payment";

  static String payStack = "paystack-payment";
  static String returnUrlPayStack = "paystack-check";

  static String flutterWave = "flutterwave-payment";
  static String returnUrlFlutterWave = "flutterwave-check";

  static String payfastPayment = "payfast-payment";
  static String getPayfastTransactionid = "get-payfast-transactionid";
  static String payFastSuccess = "payfast-success";
  static String payFastFail = "payfast-cancel";

  static String midTrans = "midtrans-payment";
  static String midTransSuccess = "midtrans-success";
  static String midTransFail = "midtrans-cancel";

  static String senangPayPayment = "senangpay-payment";

  static String addAddress = "add_address";

  // ---------------------------------- Doctor Api ------------------------------------------------------

  static String mobileCheckDoctor = "mobile_check";
  static const otpGet = "otp_detail";
  static const msgOtp = "msg91";
  static const twilioOtp = "twilio";
  static String signUpDoctor = "signup";
  static String loginDoctor = "login";
  static String deleteAccount = "delete_account";
  static String forgotPassword = "forgot_password";
  static String familyMemberAddDetail = "family_member_add_detail";
  static String familyMemberDetail = "family_member_detail";
  static String addFamilyMember = "add_family_member";
  static String editFamilyMember = "edit_family_member";
  static String faqList = "faq_list";
  static String homeApi = "home";
  static String notificationList = "notification_list";
  static String searchDoctor = "search_doctor";
  static String doctorApi = "doctor_detail";
  static String favoriteAdd = "doc_favorite_add_remove";
  static String categoryDoctor = "dep_type_doctor";
  static String doctorTimeSlot = "doctor_appoint_slot";
  static String cartDetail = "cart_data";
  static String paymentDetail = "payment_list";
  static String walletPaymentDetail = "wallet_payment_list";
  static String addWallet = "add_wallet";
  static String bookAppointment = "book_appointment";
  static String bookListAppointment = "booked_appointment_list";
  static String walletDetail = "wallet_transaction_list";
  static String appointmentDetail = "appointment_detail";
  static String checkDocAppointUpload = "check_doc_appoint_upload";
  static String success = "success_appo_detail";
  static String patentHealth = "patient_health_concerns";
  static String addPatentHealth = "add_patient_health_concerns";
  static String deletePatentHealth = "remove_pati_heal_image";
  static String appointmentDetailVital = "appoi_vit_phy_list";
  static String appointmentMedicineList = "appo_dru_pres_list";
  static String appointmentDiagnosis = "appo_diagnosis_list";
  static String cancelOrderList = "appint_cancel_list";
  static String cancelOrderApi = "cancel_appointment";
  static String addReview = "add_appint_review";
  static String pdfDownload = "generate_patient_pdf";
  static String sendNotification = "send_doctor_notified";
  static String mapDoctor = "map_doctor_list";
  static String editProfile = "edit_profile";
  static String pages = "pages";
  static String referralData = "referral_data";
  static String categoryList = "category_list";
  static String storeList = "store_list";
  static String productList = "sub_category_list";
  static String productSubList = "sub_product_list";
  static String productSearch = "product_search";

  static String productDetails = "product_detail";
  static String cartShop = "cart_detail";
  static String checkOutList = "checkout_data";
  static String shopAddressList = "address_list";
  static String shopCouponList = "coupon_list";
  static String addOrderShop = "add_product_order";
  static String myOrderList = "order_list";
  static String shopOrderDetail = "product_order_detail";
  static String orderCancelShop = "product_order_cancel";
  static String addPatientPrescription = "add_patient_prescription";

  static String searchMeidicine = "search_meidicine";
  static String addMedicinceReminder = "add_medicince_reminder";
  static String editMedicinceReminder = "edit_medicince_reminder";
  static String medicinceReminderList = "medicince_reminder_list";
  static String deleteMedicinceReminder = "delete_medicince_reminder";

  static String appintCancelList = "appint_cancel_list";

  static String labCategoryList = "lab_category_list";
  static String labList = "category_lab_list";
  static String labPackageList = "lab_package_list";
  static String labPackageDetails = "lab_package_details";
  static String labPackageCart = "package_cart";
  static String labAddCart = "add_cart";
  static String addLabBook = "add_lab_book";
  static String labBookingList = "lab_booking_list";
  static String labBookingDetail = "lab_booking_detail";
  static String cancelLabAppointment = "cancel_lab_appointment";

// --------------------------- Doctor Chat ---------------------------

  static String allChat = "all_chat";
  static String messageData = "user_to_user_chat_list";
}
