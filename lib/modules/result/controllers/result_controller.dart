import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../app/config/theme/app_colores.dart';
import '../../../app/routes/app_routes.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/services/pdf_service.dart';
import '../../../data/models/patient_metadata.dart';
import '../../../data/models/prediction_response.dart';

class ResultController extends GetxController {
  final StorageService _storageService = Get.find<StorageService>();
  final PdfService _pdfService = Get.find<PdfService>();
  
  String? imagePath;
  PatientMetadata? metadata;
  PredictionResponse? result;
  
  final showProbabilities = false.obs;
  
  @override
  void onInit() {
    super.onInit();
    
    // Get data from arguments
    final args = Get.arguments;
    if (args != null && args is Map<String, dynamic>) {
      imagePath = args['imagePath'];
      metadata = args['metadata'];
      result = args['result'];
    }
    
    if (result == null) {
      debugPrint('❌ No result data');
      Get.back();
      return;
    }
    
    debugPrint('✅ Result loaded: ${result!.predictedClass}');
  }
  
  void toggleProbabilities() {
    showProbabilities.value = !showProbabilities.value;
  }
  
  Future<void> saveResult() async {
    try {
      // Create history entry
      final historyEntry = {
        'date': DateTime.now().toIso8601String(),
        'imagePath': imagePath,
        'diagnosis': result!.predictedClass,
        'confidence': result!.confidence,
        'riskLevel': result!.riskLevel,
        'metadata': metadata!.toJson(),
        'allProbabilities': result!.allProbabilities,
      };
      
      // Save to storage
      await _storageService.addDiagnosisToHistory(historyEntry);
      
      debugPrint('✅ Result saved to history');
      
      Get.snackbar(
        'success'.tr,
        'Result saved successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.primary,
        colorText: Colors.white,
        icon: const Icon(Icons.check_circle, color: Colors.white),
      );
    } catch (e) {
      debugPrint('❌ Error saving result: $e');
      Get.snackbar(
        'error'.tr,
        'Failed to save result',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
  
  Future<void> exportPdfReport() async {
    if (result == null || metadata == null) {
      Get.snackbar('error'.tr, 'Missing data to generate report', snackPosition: SnackPosition.BOTTOM);
      return;
    }

    try {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      await _pdfService.generateAndShareReport(
        result: result!,
        metadata: metadata!,
        imagePath: imagePath,
      );

      Get.back(); // Close loading dialog
    } catch (e) {
      Get.back(); // Close loading dialog
      debugPrint('❌ Error generating PDF: $e');
      Get.snackbar(
        'error'.tr,
        'Failed to generate PDF report',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
  
  void startNewDiagnosis() {
    // Go back to home and clear all previous screens
    Get.offAllNamed(AppRoutes.HOME);
  }
  
  void showDisclaimer() {
    Get.dialog(
      AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.info_outline, color: AppColors.warning),
            const SizedBox(width: 12),
            Text('disclaimer_title'.tr),
          ],
        ),
        content: SingleChildScrollView(
          child: Text(
            'disclaimer_text'.tr,
            style: Get.textTheme.bodyMedium,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('disclaimer_understand'.tr),
          ),
        ],
      ),
    );
  }
}