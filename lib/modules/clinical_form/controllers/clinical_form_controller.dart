import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/routes/app_routes.dart';
import '../../../data/models/patient_metadata.dart';

class ClinicalFormController extends GetxController {
  // Get image path from previous screen
  String? imagePath;
  
  // Form fields
  final age = 30.0.obs;
  final sex = 'M'.obs;
  final region = ''.obs;
  final grew = false.obs;
  final bleed = false.obs;
  final diameter = 5.0.obs;
  final skinCancerHistory = false.obs;
  
  // Form validation
  final formKey = GlobalKey<FormState>();
  final isFormValid = false.obs;
  
  // Regions list
  final List<String> regions = [
    'location_head',
    'location_neck',
    'location_chest',
    'location_back',
    'location_arm_left',
    'location_arm_right',
    'location_hand_left',
    'location_hand_right',
    'location_abdomen',
    'location_leg_left',
    'location_leg_right',
    'location_foot_left',
    'location_foot_right',
  ];
  
  @override
  void onInit() {
    super.onInit();
    
    // Get image path from arguments
    final args = Get.arguments;
    if (args != null && args is Map<String, dynamic>) {
      imagePath = args['imagePath'];
    }
    
    if (imagePath == null) {
      debugPrint('❌ No image path provided');
      Get.back();
      return;
    }
    
    debugPrint('✅ Image path received: $imagePath');
    
    // Listen to form changes
    ever(age, (_) => validateForm());
    ever(sex, (_) => validateForm());
    ever(region, (_) => validateForm());
    ever(diameter, (_) => validateForm());
  }
  
  void validateForm() {
    isFormValid.value = region.value.isNotEmpty && 
                        age.value > 0 && 
                        diameter.value > 0;
  }
  
  void setSex(String value) {
    sex.value = value;
  }
  
  void setRegion(String value) {
    region.value = value;
  }
  
  void setGrew(bool? value) {
    grew.value = value ?? false;
  }
  
  void setBleed(bool? value) {
    bleed.value = value ?? false;
  }
  
  void setSkinCancerHistory(bool? value) {
    skinCancerHistory.value = value ?? false;
  }
  
  Future<void> submitForm() async {
    if (!isFormValid.value) {
      Get.snackbar(
        'error'.tr,
        'form_incomplete'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
      return;
    }
    
    try {
      // Create patient metadata
      final metadata = PatientMetadata(
        age: age.value,
        sex: sex.value,
        region: region.value,
        grew: grew.value,
        bleed: bleed.value,
        diameter: diameter.value,
        skinCancerHistory: skinCancerHistory.value,
      );
      
      debugPrint('✅ Form submitted with metadata: $metadata');
      
      // Navigate to Analysis screen
      Get.toNamed(
        AppRoutes.ANALYSIS,
        arguments: {
          'imagePath': imagePath,
          'metadata': metadata,
        },
      );
    } catch (e) {
      debugPrint('❌ Error submitting form: $e');
      Get.snackbar(
        'error'.tr,
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}