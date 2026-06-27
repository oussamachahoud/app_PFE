import 'package:get/get.dart';
import '../controllers/clinical_form_controller.dart';

class ClinicalFormBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ClinicalFormController>(() => ClinicalFormController());
  }
}