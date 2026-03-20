import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:laundry/Api/data_store.dart';
import 'package:laundry/helpar/routes_helper.dart';
import 'package:laundry/model/font_family_model.dart';
import 'package:laundry/screen/language/localstring.dart';
import 'package:laundry/utils/custom_colors.dart';
import 'package:laundry/utils/customwidget.dart';
import 'package:laundry/screen/video_call/vc_provider.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  initPlatformState();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => VcProvider()),
      ],
      child: GetMaterialApp(
        title: "Doctor",
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
          dividerColor: Colors.transparent,
          primarySwatch: Colors.blue,
          iconTheme: IconThemeData(color: BlackColor),
          fontFamily: FontFamily.gilroyRegular,
          useMaterial3: false,
          appBarTheme: AppBarTheme(
            actionsIconTheme: IconThemeData(color: BlackColor),
            iconTheme: IconThemeData(color: BlackColor),
          ),
        ),
        translations: LocaleString(),
        locale: getData.read("lan2") != null
            ? Locale(getData.read("lan2"), getData.read("lan1"))
            : Locale('en_US', 'en_US'),
        initialRoute: Routes.initial,
        getPages: getPages,
      ),
    ),
  );
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
