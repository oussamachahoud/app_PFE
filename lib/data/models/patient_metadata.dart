class PatientMetadata {
  final double age;
  final String sex; // 'M' or 'F'
  final String region;
  final bool grew;
  final bool bleed;
  final double diameter;
  final bool skinCancerHistory;
  
  PatientMetadata({
    required this.age,
    required this.sex,
    required this.region,
    required this.grew,
    required this.bleed,
    required this.diameter,
    required this.skinCancerHistory,
  });
  
  // Convert to JSON for API request
  Map<String, dynamic> toJson() {
    return {
      'age': age,
      'sex': sex,
      'region': region,
      'grew': grew,
      'bleed': bleed,
      'diameter_1': diameter,
      'skin_cancer_history': skinCancerHistory,
    };
  }
  
  // Create from JSON
  factory PatientMetadata.fromJson(Map<String, dynamic> json) {
    return PatientMetadata(
      age: json['age'].toDouble(),
      sex: json['sex'],
      region: json['region'],
      grew: json['grew'],
      bleed: json['bleed'],
      diameter: json['diameter_1'].toDouble(),
      skinCancerHistory: json['skin_cancer_history'],
    );
  }
  
  // Copy with
  PatientMetadata copyWith({
    double? age,
    String? sex,
    String? region,
    bool? grew,
    bool? bleed,
    double? diameter,
    bool? skinCancerHistory,
  }) {
    return PatientMetadata(
      age: age ?? this.age,
      sex: sex ?? this.sex,
      region: region ?? this.region,
      grew: grew ?? this.grew,
      bleed: bleed ?? this.bleed,
      diameter: diameter ?? this.diameter,
      skinCancerHistory: skinCancerHistory ?? this.skinCancerHistory,
    );
  }
  
  // Validate
  bool isValid() {
    return age > 0 && 
           age <= 120 &&
           (sex == 'M' || sex == 'F') &&
           region.isNotEmpty &&
           diameter > 0;
  }
  
  @override
  String toString() {
    return 'PatientMetadata(age: $age, sex: $sex, region: $region, grew: $grew, bleed: $bleed, diameter: $diameter, skinCancerHistory: $skinCancerHistory)';
  }
}