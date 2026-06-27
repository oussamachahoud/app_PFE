import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/services/storage_service.dart';

class SettingsController extends GetxController {
  final StorageService _storageService = Get.find<StorageService>();
  
  final apiController = TextEditingController();
  final currentLanguage = 'en'.obs;
  
  @override
  void onInit() {
    super.onInit();
    apiController.text = _storageService.apiUrl;
    currentLanguage.value = _storageService.language;
  }
  
  void saveApiUrl() {
    final url = apiController.text.trim();
    if (url.isNotEmpty && url.startsWith('http')) {
      _storageService.setApiUrl(url);
      Get.snackbar(
        'success'.tr, 
        'API URL updated successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      Get.snackbar(
        'error'.tr, 
        'Please enter a valid URL starting with http/https',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void changeLanguage(String langCode) {
    currentLanguage.value = langCode;
    _storageService.setLanguage(langCode);
    Get.updateLocale(Locale(langCode));
  }

  Future<void> clearAllData() async {
    final confirm = await Get.dialog<bool>(
      AlertDialog(
        title: Text('delete_confirmation'.tr),
        content: const Text('This will delete all history and preferences. Are you sure?'),
        actions: [
          TextButton(onPressed: () => Get.back(result: false), child: Text('cancel'.tr)),
          TextButton(
            onPressed: () => Get.back(result: true), 
            style: TextButton.styleFrom(foregroundColor: Get.theme.colorScheme.error),
            child: Text('delete'.tr),
          ),
        ],
      )
    );

    if (confirm == true) {
      await _storageService.clearAll();
      Get.snackbar('success'.tr, 'All data cleared successfully', snackPosition: SnackPosition.BOTTOM);
    }
  }

  @override
  void onClose() {
    apiController.dispose();
    super.onClose();
  }
}
