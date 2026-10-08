import 'package:flutter/material.dart';
import '../../theme.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  String? reportType;
  DateTime? startDate;
  DateTime? endDate;

  void createReport() {
    if (reportType == null || startDate == null || endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('กรุณากำหนดข้อมูลให้ครบถ้วน'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    if (startDate!.isAfter(endDate!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('กรุณากำหนดช่วงวันที่ให้ถูกต้อง'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('รายงานสวัสดิการ'),
          content: const Text(
            'สร้างรายงานสำเร็จ\n\n'
            'ข้อมูลนี้เป็นข้อมูลจำลองสำหรับการออกแบบระบบ',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('ตกลง'),
            ),
          ],
        );
      },
    );
  }

  Future<void> selectDate(bool isStart) async {
    final date = await showDatePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      initialDate: DateTime.now(),
    );

    if (date == null) return;

    setState(() {
      if (isStart) {
        startDate = date;
      } else {
        endDate = date;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('รายงานสวัสดิการ'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'รายงานสวัสดิการ',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.text,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'กำหนดเงื่อนไขเพื่อสร้างรายงาน',
              style: TextStyle(
                color: AppColors.textMuted,
              ),
            ),

            const SizedBox(height: 32),

            SizedBox(
              width: 400,
              child: DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'ประเภทของรายงาน',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'distribution',
                    child: Text('รายงานการแจกจ่ายสวัสดิการ'),
                  ),
                  DropdownMenuItem(
                    value: 'employee',
                    child: Text('รายงานสิทธิพนักงาน'),
                  ),
                  DropdownMenuItem(
                    value: 'welfare',
                    child: Text('รายงานการใช้สวัสดิการ'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    reportType = value;
                  });
                },
              ),
            ),

            const SizedBox(height: 24),

            Row(
              children: [
                SizedBox(
                  width: 190,
                  child: OutlinedButton(
                    onPressed: () => selectDate(true),
                    child: Text(
                      startDate == null
                          ? 'เลือกวันที่เริ่มต้น'
                          : '${startDate!.day}/${startDate!.month}/${startDate!.year}',
                    ),
                  ),
                ),

                const SizedBox(width: 16),

                SizedBox(
                  width: 190,
                  child: OutlinedButton(
                    onPressed: () => selectDate(false),
                    child: Text(
                      endDate == null
                          ? 'เลือกวันที่สิ้นสุด'
                          : '${endDate!.day}/${endDate!.month}/${endDate!.year}',
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            SizedBox(
              width: 200,
              height: 48,
              child: ElevatedButton(
                onPressed: createReport,
                child: const Text('สร้างรายงาน'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}