import 'package:derma_diagnostic_app_1/app/config/theme/app_colores.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/onboarding_controller.dart';


class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: controller.skipOnboarding,
                    child: Text('skip'.tr),
                  ),
                ],
              ),
            ),
            
            // Page View
            Expanded(
              child: PageView.builder(
                controller: controller.pageController,
                onPageChanged: controller.onPageChanged,
                itemCount: controller.totalPages,
                itemBuilder: (context, index) {
                  final page = controller.pages[index];
                  return _buildPage(page);
                },
              ),
            ),
            
            // Bottom Navigation
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // Page Indicators
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      controller.totalPages,
                      (index) => _buildIndicator(index),
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Navigation Buttons
                  Obx(() => Row(
                    children: [
                      // Previous Button (if not first page)
                      if (controller.currentPage.value > 0)
                        Expanded(
                          child: OutlinedButton(
                            onPressed: controller.previousPage,
                            child: Text('previous'.tr),
                          ),
                        ),
                      
                      if (controller.currentPage.value > 0)
                        const SizedBox(width: 16),
                      
                      // Next/Get Started Button
                      Expanded(
                        flex: controller.currentPage.value > 0 ? 1 : 2,
                        child: ElevatedButton(
                          onPressed: controller.nextPage,
                          child: Text(
                            controller.currentPage.value == controller.totalPages - 1
                                ? 'get_started'.tr
                                : 'next'.tr,
                          ),
                        ),
                      ),
                    ],
                  )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildPage(OnboardingPage page) {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: page.color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              page.icon,
              size: 100,
              color: page.color,
            ),
          ),
          
          const SizedBox(height: 48),
          
          // Title
          Text(
            page.title.tr,
            textAlign: TextAlign.center,
            style: Get.textTheme.headlineLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Description
          Text(
            page.description.tr,
            textAlign: TextAlign.center,
            style: Get.textTheme.bodyLarge?.copyWith(
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildIndicator(int index) {
    return Obx(() {
      final isActive = controller.currentPage.value == index;
      return AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        height: 8,
        width: isActive ? 24 : 8,
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : AppColors.grey300,
          borderRadius: BorderRadius.circular(4),
        ),
      );
    });
  }
}