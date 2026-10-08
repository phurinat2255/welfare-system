import 'package:flutter/material.dart';
import '../../theme.dart';

class DistributionPage extends StatefulWidget {
  const DistributionPage({super.key});

  @override
  State<DistributionPage> createState() => _DistributionPageState();
}

class _DistributionPageState extends State<DistributionPage> {
  String? selectedEmployee;
  String? selectedWelfare;
  DateTime? distributionDate;

  final quantityController = TextEditingController();

  final List<Map<String, String>> employees = [
    {
      'name': 'สมใจ ใจดี',
      'type': 'พนักงานประจำ',
    },
    {
      'name': 'สมหญิง รักงาน',
      'type': 'พนักงานจ้างเหมา',
    },
    {
      'name': 'มาลี ขยันทำ',
      'type': 'พนักงานประจำ',
    },
  ];

  final List<String> welfareTypes = [
    'วันลา',
    'ลาพักร้อน',
    'ประกันสังคม',
    'เสื้อทำงาน',
  ];

  final Map<String, int> welfareRights = {
    'วันลา': 5,
    'ลาพักร้อน': 10,
    'ประกันสังคม': 1,
    'เสื้อทำงาน': 2,
  };

  final List<Map<String, dynamic>> history = [
    {
      'date': '01/10/2026',
      'employee': 'สมใจ ใจดี',
      'employmentType': 'พนักงานประจำ',
      'welfare': 'เสื้อทำงาน',
      'quantity': 1,
      'remaining': 1,
      'status': 'มีสิทธิ',
    },
    {
      'date': '03/10/2026',
      'employee': 'มาลี ขยันทำ',
      'employmentType': 'พนักงานประจำ',
      'welfare': 'ลาพักร้อน',
      'quantity': 2,
      'remaining': 8,
      'status': 'มีสิทธิ',
    },
  ];

  Map<String, String>? get selectedEmployeeData {
    if (selectedEmployee == null) return null;

    return employees.firstWhere(
      (employee) => employee['name'] == selectedEmployee,
    );
  }

  bool get hasRight {
    if (selectedEmployee == null || selectedWelfare == null) {
      return false;
    }

    final employmentType = selectedEmployeeData?['type'];

    // Mock Rule:
    // ประกันสังคม → เฉพาะพนักงานประจำ
    if (selectedWelfare == 'ประกันสังคม') {
      return employmentType == 'พนักงานประจำ';
    }

    return true;
  }

  int get totalRight {
    if (selectedWelfare == null) return 0;
    return welfareRights[selectedWelfare] ?? 0;
  }

  int get usedRight {
    if (selectedEmployee == null || selectedWelfare == null) {
      return 0;
    }

    return history
        .where(
          (item) =>
              item['employee'] == selectedEmployee &&
              item['welfare'] == selectedWelfare,
        )
        .fold<int>(
          0,
          (sum, item) => sum + (item['quantity'] as int),
        );
  }

  int get remainingRight {
    return totalRight - usedRight;
  }

  Future<void> selectDate() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: distributionDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary500,
              onPrimary: Colors.white,
              surface: AppColors.surface,
              onSurface: AppColors.text,
            ),
          ),
          child: child!,
        );
      },
    );

    if (selectedDate != null) {
      setState(() {
        distributionDate = selectedDate;
      });
    }
  }

  String formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  void confirmDistribution() {
    if (selectedEmployee == null ||
        selectedWelfare == null ||
        distributionDate == null ||
        quantityController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('กรุณากรอกข้อมูลให้ครบถ้วน'),
          backgroundColor: AppColors.warning,
        ),
      );
      return;
    }

    if (!hasRight) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('ไม่มีสิทธิสำหรับประเภทการจ้างนี้'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final quantity = int.tryParse(quantityController.text);

    if (quantity == null || quantity <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('กรุณาระบุจำนวนให้ถูกต้อง'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    if (quantity > remainingRight) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'ไม่สามารถแจกเกินสิทธิได้ (เหลือ $remainingRight)',
          ),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          title: const Text(
            'ยืนยันการแจกจ่าย',
            style: TextStyle(
              color: AppColors.text,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'แม่บ้าน: $selectedEmployee\n'
            'ประเภทการจ้าง: ${selectedEmployeeData?['type']}\n'
            'สวัสดิการ: $selectedWelfare\n'
            'วันที่แจกจ่าย: ${formatDate(distributionDate!)}\n'
            'จำนวน: $quantity\n'
            'สิทธิที่เหลือ: ${remainingRight - quantity}\n\n'
            'ข้อมูลนี้เป็นข้อมูลจำลอง',
            style: const TextStyle(
              color: AppColors.textMuted,
              height: 1.6,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text(
                'ยกเลิก',
                style: TextStyle(
                  color: AppColors.textMuted,
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary500,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                setState(() {
                  history.insert(0, {
                    'date': formatDate(distributionDate!),
                    'employee': selectedEmployee!,
                    'employmentType': selectedEmployeeData?['type'] ?? '',
                    'welfare': selectedWelfare!,
                    'quantity': quantity,
                    'remaining': remainingRight - quantity,
                    'status': 'มีสิทธิ',
                  });

                  quantityController.clear();
                });

                Navigator.pop(dialogContext);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('บันทึกการแจกจ่ายสำเร็จ'),
                    backgroundColor: AppColors.success,
                  ),
                );
              },
              child: const Text('ยืนยัน'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.text,
        elevation: 0,
        title: const Text(
          'แจกจ่ายสวัสดิการ',
          style: TextStyle(
            color: AppColors.text,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'บันทึกการแจกจ่ายสวัสดิการ',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.text,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'บันทึกการได้รับสวัสดิการของพนักงาน',
              style: TextStyle(
                fontSize: 15,
                color: AppColors.textMuted,
              ),
            ),

            const SizedBox(height: 28),

            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.border,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'ข้อมูลการแจกจ่าย',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                      color: AppColors.text,
                    ),
                  ),

                  const SizedBox(height: 20),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          initialValue: selectedEmployee,
                          decoration: const InputDecoration(
                            labelText: 'เลือกแม่บ้าน',
                            prefixIcon: Icon(
                              Icons.person_outline,
                              color: AppColors.primary500,
                            ),
                          ),
                          dropdownColor: AppColors.surface,
                          items: employees.map((employee) {
                            return DropdownMenuItem<String>(
                              value: employee['name'],
                              child: Text(
                                '${employee['name']} — ${employee['type']}',
                                style: const TextStyle(
                                  color: AppColors.text,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedEmployee = value;
                              quantityController.clear();
                            });
                          },
                        ),
                      ),

                      const SizedBox(width: 20),

                      Expanded(
                        child: DropdownButtonFormField<String>(
                          initialValue: selectedWelfare,
                          decoration: const InputDecoration(
                            labelText: 'ประเภทสวัสดิการ',
                            prefixIcon: Icon(
                              Icons.card_giftcard_outlined,
                              color: AppColors.primary500,
                            ),
                          ),
                          dropdownColor: AppColors.surface,
                          items: welfareTypes.map((welfare) {
                            return DropdownMenuItem<String>(
                              value: welfare,
                              child: Text(
                                welfare,
                                style: const TextStyle(
                                  color: AppColors.text,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedWelfare = value;
                              quantityController.clear();
                            });
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: selectDate,
                          borderRadius: BorderRadius.circular(8),
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              labelText: 'วันที่แจกจ่าย',
                              prefixIcon: Icon(
                                Icons.calendar_today_outlined,
                                color: AppColors.primary500,
                              ),
                            ),
                            child: Text(
                              distributionDate == null
                                  ? 'เลือกวันที่'
                                  : formatDate(distributionDate!),
                              style: TextStyle(
                                color: distributionDate == null
                                    ? AppColors.textMuted
                                    : AppColors.text,
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 20),

                      Expanded(
                        child: TextField(
                          controller: quantityController,
                          enabled: hasRight,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'จำนวน',
                            prefixIcon: const Icon(
                              Icons.numbers,
                              color: AppColors.primary500,
                            ),
                            helperText: hasRight && selectedWelfare != null
                                ? 'สิทธิที่เหลือ $remainingRight'
                                : null,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            if (selectedEmployee != null && selectedWelfare != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: hasRight
                      ? AppColors.primary100
                      : const Color(0xFFFEE2E2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: hasRight
                        ? AppColors.primary500
                        : AppColors.error,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          hasRight
                              ? Icons.check_circle_outline
                              : Icons.cancel_outlined,
                          color: hasRight
                              ? AppColors.success
                              : AppColors.error,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'ตรวจสอบสิทธิ์',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: hasRight
                                ? AppColors.text
                                : AppColors.error,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 18),

                    _InfoRow(
                      label: 'ชื่อแม่บ้าน',
                      value: selectedEmployee!,
                    ),

                    _InfoRow(
                      label: 'ประเภทการจ้าง',
                      value: selectedEmployeeData?['type'] ?? '-',
                    ),

                    _InfoRow(
                      label: 'ประเภทสวัสดิการ',
                      value: selectedWelfare!,
                    ),

                    _InfoRow(
                      label: 'สิทธิที่มี',
                      value: '$totalRight',
                    ),

                    _InfoRow(
                      label: 'สิทธิที่เหลือ',
                      value: '$remainingRight',
                    ),

                    const SizedBox(height: 10),

                    Text(
                      hasRight
                          ? 'มีสิทธิสำหรับประเภทการจ้างนี้'
                          : 'ไม่มีสิทธิสำหรับประเภทการจ้างนี้',
                      style: TextStyle(
                        color: hasRight
                            ? AppColors.success
                            : AppColors.error,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 24),

            SizedBox(
              width: 240,
              height: 48,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary500,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: AppColors.disabled,
                  disabledForegroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: hasRight ? confirmDistribution : null,
                icon: const Icon(Icons.check),
                label: const Text(
                  'ยืนยันการแจกจ่าย',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),

            const Text(
              'ประวัติการแจกจ่ายสวัสดิการ',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.text,
              ),
            ),

            const SizedBox(height: 16),

            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.border,
                ),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  headingRowColor: WidgetStateProperty.all(
                    AppColors.primary100,
                  ),
                  headingTextStyle: const TextStyle(
                    color: AppColors.text,
                    fontWeight: FontWeight.bold,
                  ),
                  dataTextStyle: const TextStyle(
                    color: AppColors.text,
                  ),
                  columns: const [
                    DataColumn(label: Text('วันที่')),
                    DataColumn(label: Text('ชื่อแม่บ้าน')),
                    DataColumn(label: Text('ประเภทการจ้าง')),
                    DataColumn(label: Text('ประเภทสวัสดิการ')),
                    DataColumn(label: Text('จำนวนที่ได้รับ')),
                    DataColumn(label: Text('สิทธิที่เหลือ')),
                    DataColumn(label: Text('สถานะ')),
                  ],
                  rows: history.map((item) {
                    return DataRow(
                      cells: [
                        DataCell(Text(item['date'])),
                        DataCell(Text(item['employee'])),
                        DataCell(Text(item['employmentType'])),
                        DataCell(Text(item['welfare'])),
                        DataCell(
                          Text(item['quantity'].toString()),
                        ),
                        DataCell(
                          Text(item['remaining'].toString()),
                        ),
                        DataCell(
                          Text(
                            item['status'],
                            style: TextStyle(
                              color: item['status'] == 'มีสิทธิ'
                                  ? AppColors.success
                                  : AppColors.error,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: const TextStyle(
                color: AppColors.textMuted,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: AppColors.text,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

