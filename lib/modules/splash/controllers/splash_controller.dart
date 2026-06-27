import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../app/routes/app_routes.dart';
import '../../../core/services/storage_service.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _navigateToNextScreen();
  }
  
  Future<void> _navigateToNextScreen() async {
    try {
      debugPrint('🕐 Splash: Waiting 3 seconds...');
      
      // Wait for 3 seconds to show splash
      await Future.delayed(const Duration(seconds: 3));
      
      debugPrint('✅ Splash: 3 seconds passed');
      
      // Get storage service
      final storageService = Get.find<StorageService>();
      
      // Check if first time
      final isFirstTime = storageService.isFirstTime;
      debugPrint('📱 Splash: isFirstTime = $isFirstTime');
      
      if (isFirstTime) {
        // Navigate to onboarding
        debugPrint('🎯 Splash: Navigating to Onboarding');
        Get.offAllNamed(AppRoutes.ONBOARDING);
      } else {
        // Navigate to home
        debugPrint('🎯 Splash: Navigating to Home');
        Get.offAllNamed(AppRoutes.HOME);
      }
    } catch (e) {
      debugPrint('❌ Splash Error: $e');
      // If error, go to onboarding as fallback
      debugPrint('🔄 Splash: Fallback to Onboarding');
      Get.offAllNamed(AppRoutes.ONBOARDING);
    }
  }
}