import 'package:get/get.dart';
import 'app_routes.dart';

// Import all bindings
import '../../modules/splash/bindings/splash_binding.dart';
import '../../modules/onboarding/bindings/onboarding_binding.dart';
import '../../modules/home/bindings/home_binding.dart';
import '../../modules/camera/bindings/camera_binding.dart';
import '../../modules/clinical_form/bindings/clinical_form_binding.dart';
import '../../modules/analysis/bindings/analysis_binding.dart';
import '../../modules/result/bindings/result_binding.dart';
import '../../modules/history/bindings/history_binding.dart';
import '../../modules/education/bindings/education_binding.dart';
import '../../modules/settings/bindings/settings_binding.dart';

// Import all views
import '../../modules/splash/views/splash_view.dart';
import '../../modules/onboarding/views/onboarding_view.dart';
import '../../modules/home/views/home_view.dart';
import '../../modules/camera/views/camera_view.dart';
import '../../modules/clinical_form/views/clinical_form_view.dart';
import '../../modules/analysis/views/analysis_view.dart';
import '../../modules/result/views/result_view.dart';
import '../../modules/history/views/history_view.dart';
import '../../modules/education/views/education_view.dart';
import '../../modules/settings/views/settings_view.dart';

class AppPages {
  static final pages = [
    // Splash Screen
    GetPage(
      name: AppRoutes.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
      transition: Transition.fadeIn,
    ),
    
    // Onboarding
    GetPage(
      name: AppRoutes.ONBOARDING,
      page: () => const OnboardingView(),
      binding: OnboardingBinding(),
      transition: Transition.fadeIn,
    ),
    
    // Home
    GetPage(
      name: AppRoutes.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
      transition: Transition.fadeIn,
    ),
    
    // Camera
    GetPage(
      name: AppRoutes.CAMERA,
      page: () => const CameraView(),
      binding: CameraBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    
    // Clinical Form
    GetPage(
      name: AppRoutes.CLINICAL_FORM,
      page: () => const ClinicalFormView(),
      binding: ClinicalFormBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    
    // Analysis
    GetPage(
      name: AppRoutes.ANALYSIS,
      page: () => const AnalysisView(),
      binding: AnalysisBinding(),
      transition: Transition.fadeIn,
    ),
    
    // Result
    GetPage(
      name: AppRoutes.RESULT,
      page: () => const ResultView(),
      binding: ResultBinding(),
      transition: Transition.zoom,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    
    // History
    GetPage(
      name: AppRoutes.HISTORY,
      page: () => const HistoryView(),
      binding: HistoryBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    
    // Education
    GetPage(
      name: AppRoutes.EDUCATION,
      page: () => const EducationView(),
      binding: EducationBinding(),
      transition: Transition.fadeIn,
    ),
    
    // Settings
    GetPage(
      name: AppRoutes.SETTINGS,
      page: () => const SettingsView(),
      binding: SettingsBinding(),
      transition: Transition.rightToLeft,
    ),
  ];
}