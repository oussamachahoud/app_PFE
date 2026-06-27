import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/config/theme/app_colores.dart';
import '../../../data/models/prediction_response.dart';
import '../controllers/result_controller.dart';

class ResultView extends GetView<ResultController> {
  const ResultView({super.key});

  @override
  Widget build(BuildContext context) {
    if (controller.result == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    
    final result = controller.result!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text('result_title'.tr),
        leading: IconButton(
          icon: const Icon(Icons.home),
          onPressed: controller.startNewDiagnosis,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf_outlined),
            tooltip: 'Export Medical Report',
            onPressed: controller.exportPdfReport,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Image Preview
            if (controller.imagePath != null)
              Container(
                height: 250,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: FileImage(File(controller.imagePath!)),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDiagnosisCard(result),
                  const SizedBox(height: 20),
                  _buildConfidenceCard(result),
                  const SizedBox(height: 20),
                  _buildRiskLevelCard(result),
                  const SizedBox(height: 20),
                  _buildProbabilitiesCard(result),
                  const SizedBox(height: 20),
                  _buildRecommendationsCard(result),
                  const SizedBox(height: 20),
                  _buildDisclaimerCard(),
                  const SizedBox(height: 20),
                  _buildActionButtons(),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildDiagnosisCard(PredictionResponse result) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.medical_information_rounded,
                color: AppColors.primary,
                size: 32,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'diagnosis'.tr,
                    style: Get.textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          result.predictedClass.tr,
                          style: Get.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.help_outline, color: AppColors.secondary),
                        tooltip: 'What is this?',
                        onPressed: () => _showMedicalDictionary(result.predictedClass),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildConfidenceCard(PredictionResponse result) {
    final confidence = result.confidence;
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'confidence'.tr,
                  style: Get.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  result.getConfidencePercentage(),
                  style: Get.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: confidence,
                minHeight: 12,
                backgroundColor: AppColors.grey200,
                valueColor: AlwaysStoppedAnimation<Color>(
                  _getConfidenceColor(confidence),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.timer, size: 16, color: AppColors.textSecondary),
                const SizedBox(width: 8),
                Text(
                  '${'inference_time'.tr}: ${result.inferenceTimeMs.toStringAsFixed(1)} ms',
                  style: Get.textTheme.bodySmall,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildRiskLevelCard(PredictionResponse result) {
    final riskColor = result.getRiskLevelColor();
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: riskColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _getRiskIcon(result.riskLevel),
                color: riskColor,
                size: 32,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'risk_level'.tr,
                    style: Get.textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _getRiskLevelTranslation(result.riskLevel),
                    style: Get.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: riskColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildProbabilitiesCard(PredictionResponse result) {
    return Card(
      child: Column(
        children: [
          InkWell(
            onTap: controller.toggleProbabilities,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'all_probabilities'.tr,
                    style: Get.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Obx(() => Icon(
                    controller.showProbabilities.value
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                  )),
                ],
              ),
            ),
          ),
          Obx(() {
            if (!controller.showProbabilities.value) return const SizedBox.shrink();
            
            final sortedProbs = result.getSortedProbabilities();
            
            return Column(
              children: [
                const Divider(height: 1),
                ...sortedProbs.map((entry) => _buildProbabilityItem(
                  entry.key,
                  entry.value,
                )),
              ],
            );
          }),
        ],
      ),
    );
  }
  
  Widget _buildProbabilityItem(String diagnosis, double probability) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              diagnosis.tr,
              style: Get.textTheme.bodyMedium,
            ),
          ),
          Expanded(
            flex: 3,
            child: Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: probability,
                      minHeight: 8,
                      backgroundColor: AppColors.grey200,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        AppColors.primary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  width: 50,
                  child: Text(
                    '${(probability * 100).toStringAsFixed(1)}%',
                    style: Get.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildRecommendationsCard(PredictionResponse result) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.lightbulb_outline, color: AppColors.warning),
                const SizedBox(width: 12),
                Text(
                  'recommendations'.tr,
                  style: Get.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...result.recommendations.map((rec) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.check_circle,
                    color: AppColors.success,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      rec.tr,
                      style: Get.textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
  
  Widget _buildDisclaimerCard() {
    return InkWell(
      onTap: controller.showDisclaimer,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.warning.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.warning.withOpacity(0.3),
          ),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.info_outline,
              color: AppColors.warning,
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'disclaimer_text'.tr,
                style: Get.textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildActionButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: controller.saveResult,
            icon: const Icon(Icons.save),
            label: Text('save_result'.tr),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: controller.exportPdfReport,
            icon: const Icon(Icons.picture_as_pdf_rounded),
            label: const Text('Export Medical Report (PDF)'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: AppColors.accent,
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: controller.startNewDiagnosis,
            icon: const Icon(Icons.add),
            label: Text('new_diagnosis'.tr),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),
      ],
    );
  }
  
  // Helper methods
  Color _getConfidenceColor(double confidence) {
    if (confidence >= 0.8) return AppColors.success;
    if (confidence >= 0.6) return AppColors.warning;
    return AppColors.error;
  }
  
  IconData _getRiskIcon(String riskLevel) {
    final level = riskLevel.toUpperCase();
    if (level.contains('LOW') || level.contains('FAIBLE')) {
      return Icons.check_circle;
    } else if (level.contains('MODERATE') || level.contains('MODÉRÉ')) {
      return Icons.warning;
    } else {
      return Icons.error;
    }
  }
  
  String _getRiskLevelTranslation(String riskLevel) {
    final level = riskLevel.toUpperCase();
    if (level.contains('LOW') || level.contains('FAIBLE')) {
      return 'risk_low'.tr;
    } else if (level.contains('MODERATE') || level.contains('MODÉRÉ')) {
      return 'risk_moderate'.tr;
    } else {
      return 'risk_high'.tr;
    }
  }

  void _showMedicalDictionary(String diagnosisClass) {
    Map<String, String> titleMap = {
      'MEL': 'Melanoma',
      'BCC': 'Basal Cell Carcinoma',
      'SCC': 'Squamous Cell Carcinoma',
      'ACK': 'Actinic Keratosis',
      'NEV': 'Melanocytic Nevus',
      'SEK': 'Seborrheic Keratosis'
    };

    Map<String, String> descMap = {
      'MEL': 'A serious form of skin cancer that begins in cells known as melanocytes. While it is less common than other skin cancers, it is more dangerous because it\'s much more likely to spread to other parts of the body if not caught early.',
      'BCC': 'The most common type of skin cancer. It rarely spreads to other parts of the body but can be disfiguring if allowed to grow. Usually caused by sun exposure.',
      'SCC': 'The second most common form of skin cancer. It can grow rapidly and spread to other parts of the body if left untreated.',
      'ACK': 'Also known as solar keratosis. A pre-cancerous scaly patch on the skin caused by years of sun exposure. If left untreated, it can turn into squamous cell carcinoma.',
      'NEV': 'A common, non-cancerous (benign) mole. They are typically harmless and very common, but any mole that changes size, shape, or color should be evaluated.',
      'SEK': 'A very common non-cancerous skin growth that usually appears in older adults. It looks waxy, scaly, and slightly raised. It is harmless and not contagious.'
    };

    final title = titleMap[diagnosisClass] ?? diagnosisClass;
    final isCancerous = ['MEL', 'BCC', 'SCC'].contains(diagnosisClass);
    final isPreCancerous = diagnosisClass == 'ACK';
    
    Color badgeColor = AppColors.success;
    String badgeText = 'Benign (Non-Cancerous)';

    if (isCancerous) {
      badgeColor = AppColors.error;
      badgeText = 'Malignant (Cancerous)';
    } else if (isPreCancerous) {
      badgeColor = AppColors.warning;
      badgeText = 'Pre-Cancerous';
    }

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: AppColors.grey300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Row(
              children: [
                const Icon(Icons.menu_book_rounded, color: AppColors.primary, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Medical Dictionary',
                    style: Get.textTheme.titleMedium?.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: Get.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: badgeColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                badgeText,
                style: Get.textTheme.labelMedium?.copyWith(
                  color: badgeColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              descMap[diagnosisClass] ?? 'No further details available for this diagnosis.',
              style: Get.textTheme.bodyMedium?.copyWith(
                color: AppColors.textPrimary,
                height: 1.6,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Get.back(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Understand'),
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }
}