
import 'package:derma_diagnostic_app_1/app/config/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'app/routes/app_pages.dart';
import 'app/routes/app_routes.dart';
import 'app/translations/app_translations.dart';
import 'core/services/storage_service.dart';
import 'core/services/connectivity_service.dart';
import 'core/services/api_service.dart';
import 'core/services/pdf_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize GetStorage
  //await GetStorage.init();
  
  // Initialize Services
  await initServices();
  
  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  
  runApp(const MyApp());
}

Future<void> initServices() async {
  debugPrint('🔧 Starting services initialization...');
  
  // Initialize Storage Service
  await Get.putAsync(() => StorageService().init());
  debugPrint('✅ Storage Service initialized');
  
  // Initialize Connectivity Service
  Get.put(ConnectivityService());
  debugPrint('✅ Connectivity Service initialized');
  
  // Initialize API Service
  Get.put(ApiService());
  debugPrint('✅ API Service initialized');
  
  // Initialize PDF Service
  Get.put(PdfService());
  debugPrint('✅ PDF Service initialized');
  
  debugPrint('🎉 All services initialized successfully');
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'MedAssist AI',
      debugShowCheckedModeBanner: false,
      
      // Theme
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      
      // Translations
      translations: AppTranslations(),
      locale: const Locale('en', 'US'),
      fallbackLocale: const Locale('en', 'US'),
      
      // Routes
      initialRoute: AppRoutes.SPLASH,
      getPages: AppPages.pages,
      
      // Default Transition
      defaultTransition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
      
      // Error builder
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: child!,
        );
      },
    );
  }
}