import 'package:flutter/material.dart';
import 'package:patientinformation_app/screens/AddPage.dart';
import 'package:patientinformation_app/models/patient.dart';
import 'package:patientinformation_app/models/patient_type.dart';  // เพิ่ม import

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Patient> patients = [];

  void _navigateToAddPage() async {
    final newPatient = await Navigator.push<Patient>(
      context,
      MaterialPageRoute(builder: (context) => const AddPage()),
    );

    if (newPatient != null) {
      setState(() {
        patients.add(newPatient);
      });
    }
  }

  void _navigateToEditPage(int index) async {
    final updatedPatient = await Navigator.push<Patient>(
      context,
      MaterialPageRoute(
        builder: (context) => AddPage(patient: patients[index]),
      ),
    );

    if (updatedPatient != null) {
      setState(() {
        patients[index] = updatedPatient;
      });
    }
  }

  void _removePatient(int index) {
    setState(() {
      patients.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('ลบข้อมูลผู้ป่วยเรียบร้อยแล้ว')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ข้อมูลผู้ป่วย')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'ยินดีต้อนรับสู่ระบบข้อมูลผู้ป่วย\nคุณสามารถเพิ่มและจัดการข้อมูลผู้ป่วยได้ที่นี่',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),

          Expanded(
            child: patients.isEmpty
                ? const Center(child: Text('ไม่มีข้อมูลผู้ป่วย'))
                : ListView.builder(
                    itemCount: patients.length,
                    itemBuilder: (context, index) {
                      final patient = patients[index];

                      // แปลง category จาก string เป็น enum (เพราะเราเก็บเป็น String ใน patient.dart)
                      final patientType = PatientType.values.firstWhere(
                        (e) => e.toString() == patient.category,
                        orElse: () => PatientType.outpatient,  // fallback กรณีข้อมูลผิด
                      );

                      return Dismissible(
                        key: Key(patient.firstName + patient.lastName + index.toString()),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20.0),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        onDismissed: (direction) {
                          _removePatient(index);
                        },
                        child: Card(
                          child: ListTile(
                            title: Text('${patient.firstName} ${patient.lastName}'),
                            subtitle: Text(
                              'ประเภท: ${getPatientTypeName(patientType)}\nอาการ: ${patient.symptoms}',
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '${patient.admissionDate.day}/${patient.admissionDate.month}/${patient.admissionDate.year}',
                                ),
                                IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () => _navigateToEditPage(index),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddPage,
        child: const Icon(Icons.add),
      ),
    );
  }
}
