import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/config/theme/app_colores.dart';
import '../controllers/clinical_form_controller.dart';

class ClinicalFormView extends GetView<ClinicalFormController> {
  const ClinicalFormView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('clinical_form_title'.tr),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Image Preview
            if (controller.imagePath != null)
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.grey100,
                  image: DecorationImage(
                    image: FileImage(File(controller.imagePath!)),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            
            // Form
            Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: controller.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Subtitle
                    Text(
                      'clinical_form_subtitle'.tr,
                      style: Get.textTheme.bodyLarge?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Age Slider
                    _buildSectionTitle('patient_age'.tr),
                    const SizedBox(height: 12),
                    Obx(() => Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${controller.age.value.toInt()} ${'years'.tr}',
                              style: Get.textTheme.titleLarge?.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Slider(
                          value: controller.age.value,
                          min: 0,
                          max: 120,
                          divisions: 120,
                          label: controller.age.value.toInt().toString(),
                          onChanged: (value) => controller.age.value = value,
                        ),
                      ],
                    )),
                    
                    const SizedBox(height: 24),
                    
                    // Sex Selection
                    _buildSectionTitle('patient_sex'.tr),
                    const SizedBox(height: 12),
                    Obx(() => Row(
                      children: [
                        Expanded(
                          child: _buildChoiceChip(
                            label: 'male'.tr,
                            icon: Icons.male,
                            isSelected: controller.sex.value == 'M',
                            onSelected: (_) => controller.setSex('M'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildChoiceChip(
                            label: 'female'.tr,
                            icon: Icons.female,
                            isSelected: controller.sex.value == 'F',
                            onSelected: (_) => controller.setSex('F'),
                          ),
                        ),
                      ],
                    )),
                    
                    const SizedBox(height: 24),
                    
                    // Region Dropdown
                    _buildSectionTitle('lesion_location'.tr),
                    const SizedBox(height: 12),
                    Obx(() => DropdownButtonFormField<String>(
                      value: controller.region.value.isEmpty ? null : controller.region.value,
                      decoration: InputDecoration(
                        hintText: 'select_location'.tr,
                        prefixIcon: const Icon(Icons.place),
                      ),
                      items: controller.regions.map((region) {
                        return DropdownMenuItem(
                          value: region,
                          child: Text(region.tr),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          controller.setRegion(value);
                        }
                      },
                    )),
                    
                    const SizedBox(height: 24),
                    
                    // Diameter Input
                    _buildSectionTitle('lesion_diameter'.tr),
                    const SizedBox(height: 12),
                    Obx(() => Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${controller.diameter.value.toStringAsFixed(1)} mm',
                              style: Get.textTheme.titleLarge?.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Slider(
                          value: controller.diameter.value,
                          min: 1,
                          max: 50,
                          divisions: 49,
                          label: controller.diameter.value.toStringAsFixed(1),
                          onChanged: (value) => controller.diameter.value = value,
                        ),
                      ],
                    )),
                    
                    const SizedBox(height: 24),
                    
                    // Growth Question
                    _buildSectionTitle('lesion_growth'.tr),
                    const SizedBox(height: 12),
                    Obx(() => _buildYesNoSelector(
                      value: controller.grew.value,
                      onChanged: controller.setGrew,
                    )),
                    
                    const SizedBox(height: 24),
                    
                    // Bleeding Question
                    _buildSectionTitle('lesion_bleeding'.tr),
                    const SizedBox(height: 12),
                    Obx(() => _buildYesNoSelector(
                      value: controller.bleed.value,
                      onChanged: controller.setBleed,
                    )),
                    
                    const SizedBox(height: 24),
                    
                    // Cancer History Question
                    _buildSectionTitle('cancer_history'.tr),
                    const SizedBox(height: 12),
                    Obx(() => _buildYesNoSelector(
                      value: controller.skinCancerHistory.value,
                      onChanged: controller.setSkinCancerHistory,
                    )),
                    
                    const SizedBox(height: 32),
                    
                    // Submit Button
                    Obx(() => SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: controller.isFormValid.value
                            ? controller.submitForm
                            : null,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: Text(
                          'submit'.tr,
                          style: Get.textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )),
                    
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: Get.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.bold,
      ),
    );
  }
  
  Widget _buildChoiceChip({
    required String label,
    required IconData icon,
    required bool isSelected,
    required ValueChanged<bool> onSelected,
  }) {
    return InkWell(
      onTap: () => onSelected(true),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: 2,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : AppColors.textSecondary,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: Get.textTheme.titleMedium?.copyWith(
                color: isSelected ? Colors.white : AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildYesNoSelector({
    required bool value,
    required ValueChanged<bool?> onChanged,
  }) {
    return Row(
      children: [
        Expanded(
          child: _buildOptionButton(
            label: 'yes'.tr,
            isSelected: value == true,
            onTap: () => onChanged(true),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildOptionButton(
            label: 'no'.tr,
            isSelected: value == false,
            onTap: () => onChanged(false),
          ),
        ),
      ],
    );
  }
  
  Widget _buildOptionButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: 2,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: Get.textTheme.titleMedium?.copyWith(
              color: isSelected ? Colors.white : AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}