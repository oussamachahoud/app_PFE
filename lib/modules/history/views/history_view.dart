import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/config/theme/app_colores.dart';
import '../../../app/routes/app_routes.dart';
import '../controllers/history_controller.dart';

class HistoryView extends GetView<HistoryController> {
  const HistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('history_title'.tr),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 1,
        surfaceTintColor: Colors.transparent,
        actions: [
          Obx(() => controller.history.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.delete_sweep_rounded,
                      color: AppColors.error),
                  tooltip: 'Clear All',
                  onPressed: controller.clearAllHistory,
                )
              : const SizedBox.shrink()),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        if (controller.history.isEmpty) {
          return _buildEmptyState();
        }

        return RefreshIndicator(
          color: AppColors.primary,
          onRefresh: controller.loadHistory,
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
            itemCount: controller.history.length,
            itemBuilder: (context, index) {
              // Show newest first
              final realIndex = controller.history.length - 1 - index;
              final entry = controller.history[realIndex];
              return _buildHistoryCard(entry, realIndex, index);
            },
          ),
        );
      }),

      // FAB to start new diagnosis
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.offAllNamed(AppRoutes.HOME),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_circle_outline_rounded),
        label: Text('new_diagnosis'.tr),
      ),
    );
  }

  // ──────────────────────────────────────────────────────────────
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: AppColors.surfaceElevated,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.history_rounded,
                size: 64,
                color: AppColors.primary.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 28),
            Text(
              'no_history'.tr,
              style: Get.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'no_history_desc'.tr,
              textAlign: TextAlign.center,
              style: Get.textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 36),
            ElevatedButton.icon(
              onPressed: () => Get.offAllNamed(AppRoutes.HOME),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                    horizontal: 28, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              icon: const Icon(Icons.camera_alt_rounded),
              label: Text('start_first_diagnosis'.tr),
            ),
          ],
        ),
      ),
    );
  }

  // ──────────────────────────────────────────────────────────────
  Widget _buildHistoryCard(
      Map<String, dynamic> entry, int realIndex, int displayIndex) {
    final diagnosis = entry['diagnosis'] as String? ?? 'UNKNOWN';
    final confidence = (entry['confidence'] as num?)?.toDouble() ?? 0.0;
    final riskLevel = entry['riskLevel'] as String? ?? 'MODERATE';
    final date = entry['date'] as String? ?? '';
    final imagePath = entry['imagePath'] as String?;

    final riskColor = _getRiskColor(riskLevel);
    final diagnosisLabel = _getDiagnosisLabel(diagnosis);

    return Dismissible(
      key: Key('history_$realIndex'),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: AppColors.error,
          borderRadius: BorderRadius.circular(20),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        child: const Icon(Icons.delete_rounded, color: Colors.white, size: 28),
      ),
      confirmDismiss: (_) async {
        final confirmed = await Get.dialog<bool>(
          AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20)),
            title: Text('delete_confirmation'.tr),
            content: Text('This action cannot be undone.'),
            actions: [
              TextButton(
                onPressed: () => Get.back(result: false),
                child: Text('cancel'.tr),
              ),
              TextButton(
                style:
                    TextButton.styleFrom(foregroundColor: AppColors.error),
                onPressed: () => Get.back(result: true),
                child: Text('delete'.tr),
              ),
            ],
          ),
        );
        return confirmed ?? false;
      },
      onDismissed: (_) => controller.deleteEntry(realIndex),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => _showDetailSheet(entry),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // ── Image or Placeholder ──────────────────────
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: SizedBox(
                    width: 70,
                    height: 70,
                    child: imagePath != null && File(imagePath).existsSync()
                        ? Image.file(
                            File(imagePath),
                            fit: BoxFit.cover,
                          )
                        : Container(
                            color: AppColors.surfaceElevated,
                            child: Icon(
                              Icons.image_not_supported_rounded,
                              color: AppColors.grey400,
                              size: 28,
                            ),
                          ),
                  ),
                ),

                const SizedBox(width: 14),

                // ── Diagnosis Info ────────────────────────────
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Diagnosis name + risk badge
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              diagnosisLabel,
                              style: Get.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: riskColor.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              riskLevel.toUpperCase(),
                              style: Get.textTheme.labelSmall?.copyWith(
                                color: riskColor,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.4,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 6),

                      // Confidence bar
                      Row(
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: confidence,
                                minHeight: 6,
                                backgroundColor: AppColors.grey200,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    riskColor),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${(confidence * 100).toStringAsFixed(0)}%',
                            style: Get.textTheme.labelSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: riskColor,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 6),

                      // Date
                      Row(
                        children: [
                          const Icon(Icons.schedule_rounded,
                              size: 13, color: AppColors.textHint),
                          const SizedBox(width: 4),
                          Text(
                            controller.formatDate(date),
                            style: Get.textTheme.labelSmall?.copyWith(
                              color: AppColors.textHint,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // ── Arrow ─────────────────────────────────────
                const SizedBox(width: 8),
                Icon(Icons.chevron_right_rounded,
                    color: AppColors.grey400, size: 22),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ──────────────────────────────────────────────────────────────
  void _showDetailSheet(Map<String, dynamic> entry) {
    final diagnosis = entry['diagnosis'] as String? ?? 'UNKNOWN';
    final confidence = (entry['confidence'] as num?)?.toDouble() ?? 0.0;
    final riskLevel = entry['riskLevel'] as String? ?? 'MODERATE';
    final date = entry['date'] as String? ?? '';
    final imagePath = entry['imagePath'] as String?;
    final probs =
        (entry['allProbabilities'] as Map?)?.cast<String, dynamic>() ?? {};
    final riskColor = _getRiskColor(riskLevel);

    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.grey300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Header row: image + diagnosis ────────
                    Row(
                      children: [
                        if (imagePath != null &&
                            File(imagePath).existsSync())
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(
                              File(imagePath),
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                            ),
                          ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _getDiagnosisLabel(diagnosis),
                                style: Get.textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: riskColor.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  riskLevel.toUpperCase(),
                                  style: Get.textTheme.labelMedium?.copyWith(
                                    color: riskColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                controller.formatDate(date),
                                style: Get.textTheme.bodySmall?.copyWith(
                                  color: AppColors.textHint,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),
                    const Divider(height: 1),
                    const SizedBox(height: 20),

                    // ── Confidence ────────────────────────────
                    Text(
                      'confidence'.tr,
                      style: Get.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: LinearProgressIndicator(
                              value: confidence,
                              minHeight: 10,
                              backgroundColor: AppColors.grey200,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.primary),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          '${(confidence * 100).toStringAsFixed(1)}%',
                          style: Get.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),

                    if (probs.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      Text(
                        'all_probabilities'.tr,
                        style: Get.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...(() {
                        final sorted = probs.entries
                            .map((e) => (
                                  label: e.key,
                                  value: (e.value as num).toDouble()
                                ))
                            .toList()
                          ..sort((a, b) => b.value.compareTo(a.value));
                        return sorted
                            .map((item) =>
                                _buildProbRow(item.label, item.value))
                            .toList();
                      })(),
                    ],

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
    );
  }

  Widget _buildProbRow(String label, double value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 50,
            child: Text(
              label,
              style: Get.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: value,
                minHeight: 7,
                backgroundColor: AppColors.grey200,
                valueColor:
                    const AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 44,
            child: Text(
              '${(value * 100).toStringAsFixed(1)}%',
              style: Get.textTheme.labelSmall?.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ──────────────────────────────────────────────────────────────
  Color _getRiskColor(String riskLevel) {
    switch (riskLevel.toUpperCase()) {
      case 'LOW':
      case 'FAIBLE':
        return AppColors.riskLow;
      case 'MODERATE':
      case 'MODÉRÉ':
        return AppColors.riskModerate;
      case 'HIGH':
      case 'ÉLEVÉ':
        return AppColors.riskHigh;
      default:
        return AppColors.grey500;
    }
  }

  String _getDiagnosisLabel(String code) {
    const labels = {
      'MEL': 'Melanoma',
      'BCC': 'Basal Cell Carcinoma',
      'SCC': 'Squamous Cell Carcinoma',
      'ACK': 'Actinic Keratosis',
      'NEV': 'Melanocytic Nevus',
      'SEK': 'Seborrheic Keratosis',
    };
    return labels[code] ?? code;
  }
}