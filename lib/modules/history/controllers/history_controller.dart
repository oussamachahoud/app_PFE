import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../core/services/storage_service.dart';

class HistoryController extends GetxController {
  final StorageService _storageService = Get.find<StorageService>();
  
  final history = <Map<String, dynamic>>[].obs;
  final isLoading = true.obs;
  
  @override
  void onInit() {
    super.onInit();
    loadHistory();
  }
  
  Future<void> loadHistory() async {
    try {
      isLoading.value = true;
      
      // Load from storage
      final historyData = _storageService.diagnosisHistory;
      history.value = historyData;
      
      debugPrint('✅ Loaded ${history.length} history entries');
    } catch (e) {
      debugPrint('❌ Error loading history: $e');
      Get.snackbar(
        'error'.tr,
        'Failed to load history',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
  
  Future<void> deleteEntry(int index) async {
    try {
      // Show confirmation dialog
      final confirmed = await Get.dialog<bool>(
        AlertDialog(
          title: Text('delete_confirmation'.tr),
          content: Text('This action cannot be undone'),
          actions: [
            TextButton(
              onPressed: () => Get.back(result: false),
              child: Text('cancel'.tr),
            ),
            TextButton(
              onPressed: () => Get.back(result: true),
              style: TextButton.styleFrom(
                foregroundColor: Get.theme.colorScheme.error,
              ),
              child: Text('delete'.tr),
            ),
          ],
        ),
      );
      
      if (confirmed == true) {
        await _storageService.removeDiagnosisFromHistory(index);
        await loadHistory();
        
        Get.snackbar(
          'success'.tr,
          'deleted_successfully'.tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.colorScheme.primary,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      debugPrint('❌ Error deleting entry: $e');
      Get.snackbar(
        'error'.tr,
        'Failed to delete entry',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
  
  Future<void> clearAllHistory() async {
    try {
      final confirmed = await Get.dialog<bool>(
        AlertDialog(
          title: Text('Clear All History?'),
          content: Text('This will permanently delete all diagnosis history. This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () => Get.back(result: false),
              child: Text('cancel'.tr),
            ),
            TextButton(
              onPressed: () => Get.back(result: true),
              style: TextButton.styleFrom(
                foregroundColor: Get.theme.colorScheme.error,
              ),
              child: Text('Clear All'),
            ),
          ],
        ),
      );
      
      if (confirmed == true) {
        await _storageService.clearHistory();
        await loadHistory();
        
        Get.snackbar(
          'success'.tr,
          'History cleared successfully',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      debugPrint('❌ Error clearing history: $e');
    }
  }
  
  String formatDate(String isoDate) {
    try {
      final date = DateTime.parse(isoDate);
      final now = DateTime.now();
      final difference = now.difference(date);
      
      if (difference.inDays == 0) {
        return 'Today ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
      } else if (difference.inDays == 1) {
        return 'Yesterday';
      } else if (difference.inDays < 7) {
        return '${difference.inDays} days ago';
      } else {
        return '${date.day}/${date.month}/${date.year}';
      }
    } catch (e) {
      return isoDate;
    }
  }
}