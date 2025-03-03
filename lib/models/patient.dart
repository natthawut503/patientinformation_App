class Patient {
  final String firstName;
  final String lastName;
  final int age;
  
  final DateTime admissionDate;
  final String category;   // ผู้ป่วยใน, ผู้ป่วยนอก, ผู้ป่วยฉุกเฉิน
  final String symptoms;

  Patient({
    required this.firstName,
    required this.lastName,
    required this.age,
    
    required this.admissionDate,
    required this.category,
    required this.symptoms,
  });

  // เพิ่มฟังก์ชันตรวจสอบประเภทผู้ป่วย
  static String getPatientTypeDescription(String category) {
    switch (category) {
      case 'inpatient':
        return 'ผู้ป่วยใน';
      case 'outpatient':
        return 'ผู้ป่วยนอก';
      case 'emergency':
        return 'ผู้ป่วยฉุกเฉิน';
      default:
        return 'ไม่ทราบประเภท';
    }
  }
}
