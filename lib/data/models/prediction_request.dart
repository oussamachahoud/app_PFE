import 'patient_metadata.dart';

class PredictionRequest {
  final String imageBase64;
  final PatientMetadata metadata;
  
  PredictionRequest({
    required this.imageBase64,
    required this.metadata,
  });
  
  // Convert to JSON for API request
  Map<String, dynamic> toJson() {
    return {
      'image_base64': imageBase64,
      'age': metadata.age,
      'sex': metadata.sex,
      'region': metadata.region,
      'grew': metadata.grew,
      'bleed': metadata.bleed,
      'diameter_1': metadata.diameter,
      'skin_cancer_history': metadata.skinCancerHistory,
    };
  }
  
  @override
  String toString() {
    return 'PredictionRequest(imageBase64: ${imageBase64.length} chars, metadata: $metadata)';
  }
}