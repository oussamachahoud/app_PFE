import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/config/theme/app_colores.dart';
import '../controllers/settings_controller.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('settings'.tr),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // API Configuration
            _buildSectionHeader(Icons.cloud_sync, 'API Configuration'),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: _cardDecoration(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Backend Server API URL', style: Get.textTheme.labelLarge),
                  const SizedBox(height: 8),
                  TextField(
                    controller: controller.apiController,
                    decoration: InputDecoration(
                      hintText: 'http://192.168.1.X:8000/api/v1',
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.save, color: AppColors.primary),
                        onPressed: controller.saveApiUrl,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Used to communicate with the FastAPI backend.',
                    style: Get.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Language
            _buildSectionHeader(Icons.language, 'Language'),
            Container(
              decoration: _cardDecoration(),
              child: Column(
                children: [
                  Obx(() => RadioListTile<String>(
                    title: const Text('English'),
                    value: 'en',
                    groupValue: controller.currentLanguage.value,
                    onChanged: (val) => controller.changeLanguage(val!),
                  )),
                  const Divider(height: 1),
                  Obx(() => RadioListTile<String>(
                    title: const Text('العربية'),
                    value: 'ar',
                    groupValue: controller.currentLanguage.value,
                    onChanged: (val) => controller.changeLanguage(val!),
                  )),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Data Management
            _buildSectionHeader(Icons.storage, 'Data Management'),
            Container(
              decoration: _cardDecoration(),
              child: ListTile(
                leading: const Icon(Icons.delete_forever, color: AppColors.error),
                title: const Text('Clear All Local Data', style: TextStyle(color: AppColors.error)),
                subtitle: const Text('Deletes all history and preferences'),
                onTap: controller.clearAllData,
              ),
            ),

            const SizedBox(height: 40),
            
            // About
            Center(
              child: Column(
                children: [
                  Text('app_name'.tr, style: Get.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text('Version 1.0.0', style: Get.textTheme.bodySmall),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary),
          const SizedBox(width: 8),
          Text(title, style: Get.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: AppColors.border),
      boxShadow: [
        BoxShadow(
          color: AppColors.shadow,
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }
}
