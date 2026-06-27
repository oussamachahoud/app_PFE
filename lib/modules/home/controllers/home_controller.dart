import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../app/routes/app_routes.dart';
import '../../../core/services/connectivity_service.dart';

class HomeController extends GetxController {
  final ConnectivityService _connectivityService = Get.find<ConnectivityService>();
  final ImagePicker _imagePicker = ImagePicker();
  
  final isLoading = false.obs;
  
  @override
  void onInit() {
    super.onInit();
    _checkConnectivity();
  }
  
 void _checkConnectivity() {
  if (!_connectivityService.isOnline.value) {

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.snackbar(
        "No Internet",
        "Please check your connection",
      );
    });

  }
}
  
  // Navigate to Camera Screen
  Future<void> takePhoto() async {
    try {
      Get.toNamed(AppRoutes.CAMERA);
    } catch (e) {
      debugPrint('Error navigating to camera: $e');
      Get.snackbar('error'.tr, 'error_camera_permission'.tr);
    }
  }
  
  // Upload from Gallery
  Future<void> uploadFromGallery() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
        maxWidth: 1024,
        maxHeight: 1024,
      );
      
      if (image != null) {
        // Navigate to Clinical Form with image path
        Get.toNamed(
          AppRoutes.CLINICAL_FORM,
          arguments: {'imagePath': image.path},
        );
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
      Get.snackbar('error'.tr, 'error_invalid_image'.tr);
    }
  }
  
  // Navigate to History
  void viewHistory() {
    Get.toNamed(AppRoutes.HISTORY);
  }
  
  // Navigate to Settings
  void openSettings() {
    Get.toNamed(AppRoutes.SETTINGS);
  }
  
  // Navigate to Education
  void openEducation() {
    Get.toNamed(AppRoutes.EDUCATION);
  }
  
  // Navigate to About
  void openAbout() {
    Get.dialog(
      AlertDialog(
        title: Text('about'.tr),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('app_name'.tr, 
              style: Get.textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text('app_subtitle'.tr,
              style: Get.textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Text('app_version'.tr + ': 1.0.0',
              style: Get.textTheme.bodySmall,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('done'.tr),
          ),
        ],
      ),
    );
  }
}