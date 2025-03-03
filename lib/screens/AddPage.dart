import 'package:flutter/material.dart';
import 'package:patientinformation_app/models/patient.dart';
import 'package:patientinformation_app/models/patient_type.dart';

class AddPage extends StatefulWidget {
  final Patient? patient;  // รับข้อมูลเดิมกรณีแก้ไข

  const AddPage({super.key, this.patient});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _symptomsController = TextEditingController();
  DateTime? _selectedDate;
  PatientType? _selectedPatientType;

  @override
  void initState() {
    super.initState();
    if (widget.patient != null) {
      _firstNameController.text = widget.patient!.firstName;
      _lastNameController.text = widget.patient!.lastName;
      _ageController.text = widget.patient!.age.toString();
      _symptomsController.text = widget.patient!.symptoms;
      _selectedDate = widget.patient!.admissionDate;
      _selectedPatientType = PatientType.values.firstWhere(
        (e) => e.toString() == widget.patient!.category,
        orElse: () => PatientType.outpatient, // fallback เผื่อข้อมูลเก่า
      );
    }
  }

  void _savePatient() {
    if (_formKey.currentState!.validate()) {
      if (_selectedDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('กรุณาเลือกวันที่เข้ารับการรักษา')),
        );
        return;
      }

      if (_selectedPatientType == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('กรุณาเลือกประเภทผู้ป่วย')),
        );
        return;
      }

     final newPatient = Patient(
  firstName: _firstNameController.text,
  lastName: _lastNameController.text,
  age: int.parse(_ageController.text),
  
  admissionDate: _selectedDate!,
  category: _selectedPatientType.toString(),
  symptoms: _symptomsController.text,
);


      Navigator.pop(context, newPatient);  // ส่งกลับไป HomePage
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),  // จำกัดแค่วันปัจจุบันหรือย้อนหลัง
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.patient == null ? 'เพิ่มข้อมูลผู้ป่วย' : 'แก้ไขข้อมูลผู้ป่วย'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _firstNameController,
                decoration: const InputDecoration(labelText: 'ชื่อ'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'กรุณากรอกชื่อ';
                  }
                  if (!RegExp(r'^[a-zA-Zก-๙\s]+$').hasMatch(value)) {
                    return 'กรุณากรอกเฉพาะตัวอักษร';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _lastNameController,
                decoration: const InputDecoration(labelText: 'นามสกุล'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'กรุณากรอกนามสกุล';
                  }
                  if (!RegExp(r'^[a-zA-Zก-๙\s]+$').hasMatch(value)) {
                    return 'กรุณากรอกเฉพาะตัวอักษร';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _ageController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'อายุ'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'กรุณากรอกอายุ';
                  }
                  if (int.tryParse(value) == null) {
                    return 'กรุณากรอกตัวเลขเท่านั้น';
                  }
                  return null;
                },
              ),
              ListTile(
                title: Text(
                  'วันที่เข้ารับการรักษา: ${_selectedDate != null ? "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}" : 'กรุณาเลือกวันที่เข้ารับการรักษา'}',
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: _selectDate,
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<PatientType>(
                value: _selectedPatientType,
                decoration: const InputDecoration(labelText: 'ประเภทผู้ป่วย'),
                items: PatientType.values.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(getPatientTypeName(type)),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedPatientType = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'กรุณาเลือกประเภทผู้ป่วย';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _symptomsController,
                decoration: const InputDecoration(labelText: 'อาการเบื้องต้น'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'กรุณากรอกอาการเบื้องต้น';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _savePatient,
                child: const Text('บันทึกข้อมูล'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
