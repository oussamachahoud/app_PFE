import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/routes/app_routes.dart';
import '../../../core/services/storage_service.dart';

class OnboardingController extends GetxController {
  final StorageService _storageService = Get.find<StorageService>();
  final PageController pageController = PageController();
  
  final currentPage = 0.obs;
  final totalPages = 3;
  
  // Onboarding pages data
  final List<OnboardingPage> pages = [
    OnboardingPage(
      title: 'onboarding_title_1',
      description: 'onboarding_desc_1',
      icon: Icons.psychology_rounded,
      color: const Color(0xFF2196F3),
    ),
    OnboardingPage(
      title: 'onboarding_title_2',
      description: 'onboarding_desc_2',
      icon: Icons.camera_alt_rounded,
      color: const Color(0xFF4CAF50),
    ),
    OnboardingPage(
      title: 'onboarding_title_3',
      description: 'onboarding_desc_3',
      icon: Icons.security_rounded,
      color: const Color(0xFFFF9800),
    ),
  ];
  
  void onPageChanged(int index) {
    currentPage.value = index;
  }
  
  void nextPage() {
    if (currentPage.value < totalPages - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      finishOnboarding();
    }
  }
  
  void previousPage() {
    if (currentPage.value > 0) {
      pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }
  
  void skipOnboarding() {
    finishOnboarding();
  }
  
  Future<void> finishOnboarding() async {
    await _storageService.setFirstTime(false);
    Get.offAllNamed(AppRoutes.HOME);
  }
  
  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}

class OnboardingPage {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  
  OnboardingPage({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });
}