enum PatientType {
  inpatient,      // ผู้ป่วยใน
  outpatient,     // ผู้ป่วยนอก
  emergency,      // ผู้ป่วยฉุกเฉิน
}

String getPatientTypeName(PatientType type) {
  switch (type) {
    case PatientType.inpatient:
      return 'ผู้ป่วยใน';
    case PatientType.outpatient:
      return 'ผู้ป่วยนอก';
    case PatientType.emergency:
      return 'ผู้ป่วยฉุกเฉิน';
    default:
      return '';
  }
}
