import 'services/api_service.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const WelfareApp());
}

// ==================== DESIGN SYSTEM ====================

class AppColors {
  static const primary = Color(0xFF2563EB);
  static const primaryDark = Color(0xFF1D4ED8);
  static const primaryLight = Color(0xFFDBEAFE);
  static const teal = Color(0xFF0D9488);
  static const success = Color(0xFF16A34A);
  static const warning = Color(0xFFD97706);
  static const error = Color(0xFFDC2626);
  static const background = Color(0xFFF8FAFC);
  static const surface = Colors.white;
  static const border = Color(0xFFE2E8F0);
  static const text = Color(0xFF0F172A);
  static const muted = Color(0xFF64748B);
}

class WelfareApp extends StatelessWidget {
  const WelfareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Welfare Care',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
          surface: AppColors.surface,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.surface,
          foregroundColor: AppColors.text,
          elevation: 0,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.surface,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.border),
          ),
        ),
      ),
      home: const MainLayout(),
    );
  }
}

// ==================== MAIN LAYOUT ====================

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int selectedIndex = 0;

  final List<String> menuTitles = [
    'ภาพรวม',
    'ข้อมูลแม่บ้าน',
    'คำขอสวัสดิการ',
    'อนุมัติสวัสดิการ',
    'นโยบายสวัสดิการ',
    'จัดการสิทธิแม่บ้าน',
  ];

  final List<IconData> menuIcons = [
    Icons.dashboard_outlined,
    Icons.people_outline,
    Icons.description_outlined,
    Icons.fact_check_outlined,
    Icons.policy_outlined,
    Icons.card_membership_outlined,
  ];

  @override
  Widget build(BuildContext context) {
    final pages = [
      const DashboardPage(),
      const EmployeesPage(),
      const RequestsPage(),
      const ApprovalPage(),
      const PoliciesPage(),
      const RightsPage(),
    ];

    return Scaffold(
      body: Row(
        children: [
          // Sidebar แสดงเพียงครั้งเดียว
          Container(
            width: 245,
            color: AppColors.surface,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(22, 28, 16, 28),
                  child: Row(
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.volunteer_activism,
                          color: Colors.white,
                          size: 25,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Welfare Care',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.text,
                              ),
                            ),
                            Text(
                              'ระบบจัดการสวัสดิการ',
                              style: TextStyle(
                                fontSize: 11,
                                color: AppColors.muted,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'เมนูหลัก',
                    style: TextStyle(
                      color: AppColors.muted,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                ...List.generate(menuTitles.length, (index) {
                  final selected = selectedIndex == index;

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 3,
                    ),
                    child: Material(
                      color: selected
                          ? AppColors.primaryLight
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(8),
                        onTap: () {
                          setState(() {
                            selectedIndex = index;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 14,
                          ),
                          child: Row(
                            children: [
                              Icon(
                                menuIcons[index],
                                size: 21,
                                color: selected
                                    ? AppColors.primaryDark
                                    : AppColors.muted,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  menuTitles[index],
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: selected
                                        ? FontWeight.w600
                                        : FontWeight.normal,
                                    color: selected
                                        ? AppColors.primaryDark
                                        : AppColors.text,
                                  ),
                                ),
                              ),
                              if (selected)
                                Container(
                                  width: 4,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
                const Spacer(),
                const Divider(color: AppColors.border),
                const ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppColors.primaryLight,
                    child: Icon(
                      Icons.person_outline,
                      color: AppColors.primary,
                    ),
                  ),
                  title: Text(
                    'หัวหน้า',
                    style: TextStyle(
                      color: AppColors.text,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    'ผู้จัดการหอพัก',
                    style: TextStyle(
                      color: AppColors.muted,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),

          const VerticalDivider(
            width: 1,
            thickness: 1,
            color: AppColors.border,
          ),

          // พื้นที่แสดงเนื้อหา
          Expanded(
            child: Column(
              children: [
                Container(
                  height: 70,
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  color: AppColors.surface,
                  child: Row(
                    children: [
                      Text(
                        menuTitles[selectedIndex],
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.text,
                        ),
                      ),
                      const Spacer(),
                      const Icon(
                        Icons.notifications_none,
                        color: AppColors.muted,
                      ),
                      const SizedBox(width: 18),
                      const Text(
                        'หัวหน้า',
                        style: TextStyle(color: AppColors.text),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1, color: AppColors.border),
                Expanded(
                  child: IndexedStack(
                    index: selectedIndex,
                    children: pages,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ==================== SHARED WIDGETS ====================

class PageContainer extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;

  const PageContainer({
    super.key,
    required this.title,
    required this.subtitle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: AppColors.text,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: const TextStyle(color: AppColors.muted),
          ),
          const SizedBox(height: 24),
          child,
        ],
      ),
    );
  }
}

class Panel extends StatelessWidget {
  final Widget child;

  const Panel({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: child,
    );
  }
}

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final IconData? icon;

  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon ?? Icons.check),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 16,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}

class StatusBadge extends StatelessWidget {
  final String status;

  const StatusBadge(this.status, {super.key});

  @override
  Widget build(BuildContext context) {
    final Color color = status == 'อนุมัติ' ||
            status == 'มีสิทธิ' ||
            status == 'ใช้งาน'
        ? AppColors.success
        : status == 'ปฏิเสธ' || status == 'ไม่มีสิทธิ'
            ? AppColors.error
            : AppColors.warning;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

void showMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: AppColors.primaryDark,
    ),
  );
}

// ==================== PAGE 1: DASHBOARD ====================


class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  Map<String, dynamic>? dashboard;
  int policyCount = 0;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    loadDashboard();
  }

  Future<void> loadDashboard() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final results = await Future.wait([
        ApiService.getDashboard(),
        ApiService.getPolicies(),
      ]);

      if (!mounted) return;

      setState(() {
        dashboard = Map<String, dynamic>.from(
          results[0] as Map,
        );
        policyCount = (results[1] as List).length;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        errorMessage = 'โหลดข้อมูลภาพรวมไม่สำเร็จ\n$e';
        isLoading = false;
      });
    }
  }

  int numberValue(dynamic value) {
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    final summary = dashboard?['summary'] is Map
        ? Map<String, dynamic>.from(dashboard!['summary'] as Map)
        : <String, dynamic>{};

    final recentRequests =
        dashboard?['recentRequests'] is List
            ? dashboard!['recentRequests'] as List
            : <dynamic>[];

    final cards = [
      SummaryCard(
        title: 'แม่บ้านที่ปฏิบัติงาน',
        value: '${numberValue(summary['active_employees'])}',
        detail: 'รายชื่อที่ยังปฏิบัติงาน',
        icon: Icons.people_outline,
        color: AppColors.primary,
      ),
      SummaryCard(
        title: 'คำขอรอพิจารณา',
        value: '${numberValue(summary['pending_requests'])}',
        detail: 'รายการที่ยังไม่ดำเนินการ',
        icon: Icons.pending_actions,
        color: AppColors.warning,
      ),
      SummaryCard(
        title: 'อนุมัติแล้ว',
        value: '${numberValue(summary['approved_requests'])}',
        detail: 'คำขอที่ได้รับอนุมัติ',
        icon: Icons.check_circle_outline,
        color: AppColors.success,
      ),
      SummaryCard(
        title: 'นโยบายสวัสดิการ',
        value: '$policyCount',
        detail: 'ประเภทสวัสดิการในระบบ',
        icon: Icons.policy_outlined,
        color: AppColors.teal,
      ),
    ];

    return PageContainer(
      title: 'ภาพรวม',
      subtitle: 'สรุปข้อมูลการจัดการสวัสดิการของหอพัก',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isLoading)
            const LinearProgressIndicator(),

          if (errorMessage != null)
            Panel(
              child: Column(
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: AppColors.error,
                    size: 36,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    errorMessage!,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: loadDashboard,
                    icon: const Icon(Icons.refresh),
                    label: const Text('ลองอีกครั้ง'),
                  ),
                ],
              ),
            ),

          if (!isLoading && errorMessage == null) ...[
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: cards,
            ),
            const SizedBox(height: 24),
            Panel(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'รายการคำขอล่าสุด',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.text,
                    ),
                  ),
                  const SizedBox(height: 16),

                  if (recentRequests.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: Center(
                        child: Text('ยังไม่มีรายการคำขอสวัสดิการ'),
                      ),
                    )
                  else
                    ...recentRequests.map((item) {
                      final request =
                          Map<String, dynamic>.from(item as Map);

                      final name =
                          (request['full_name'] ?? '-').toString();
                      final policy =
                          (request['policy_name'] ?? '-').toString();
                      final status =
                          (request['status'] ?? '-').toString();
                      final amount =
                          request['requested_amount']?.toString() ?? '0';

                      return Column(
                        children: [
                          ListTile(
                            leading: const CircleAvatar(
                              backgroundColor: AppColors.primaryLight,
                              child: Icon(
                                Icons.person,
                                color: AppColors.primary,
                              ),
                            ),
                            title: Text(name),
                            subtitle: Text(
                              'ขอใช้สิทธิ: $policy\nจำนวน: $amount',
                            ),
                            isThreeLine: true,
                            trailing: StatusBadge(status),
                          ),
                          const Divider(color: AppColors.border),
                        ],
                      );
                    }),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final String detail;
  final IconData icon;
  final Color color;

  const SummaryCard({
    super.key,
    required this.title,
    required this.value,
    required this.detail,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 230,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 16),
          Text(title, style: const TextStyle(color: AppColors.muted)),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: AppColors.text,
            ),
          ),
          const SizedBox(height: 6),
          Text(detail, style: const TextStyle(fontSize: 12, color: AppColors.muted)),
        ],
      ),
    );
  }
}

// ==================== PAGE 2: EMPLOYEES ====================


class EmployeesPage extends StatefulWidget {
  const EmployeesPage({super.key});

  @override
  State<EmployeesPage> createState() => _EmployeesPageState();
}

class _EmployeesPageState extends State<EmployeesPage> {
  final searchController = TextEditingController();

  List<Map<String, dynamic>> employees = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    loadEmployees();
  }

  Future<void> loadEmployees() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final data = await ApiService.getEmployees();

      if (!mounted) return;

      setState(() {
        employees = data
            .map((item) => Map<String, dynamic>.from(item as Map))
            .toList();
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        errorMessage = 'โหลดข้อมูลแม่บ้านไม่สำเร็จ\n$e';
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keyword = searchController.text.trim().toLowerCase();

    final filtered = employees.where((e) {
      final name = (e['full_name'] ?? '').toString().toLowerCase();
      return name.contains(keyword);
    }).toList();

    return PageContainer(
      title: 'ข้อมูลแม่บ้าน',
      subtitle: 'ค้นหาและตรวจสอบข้อมูลพนักงาน',
      child: Column(
        children: [
          Panel(
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: 'ค้นหาชื่อแม่บ้าน',
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                ),
                const SizedBox(width: 16),
                PrimaryButton(
                  label: 'เพิ่มแม่บ้าน',
                  icon: Icons.person_add_outlined,
                  onPressed: () => showMessage(
                    context,
                    'ฟังก์ชันเพิ่มแม่บ้านยังไม่ได้เชื่อมต่อ API',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Panel(
            child: isLoading
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: CircularProgressIndicator(),
                    ),
                  )
                : errorMessage != null
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            children: [
                              const Icon(
                                Icons.error_outline,
                                color: AppColors.error,
                                size: 40,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                errorMessage!,
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 12),
                              ElevatedButton.icon(
                                onPressed: loadEmployees,
                                icon: const Icon(Icons.refresh),
                                label: const Text('ลองอีกครั้ง'),
                              ),
                            ],
                          ),
                        ),
                      )
                    : filtered.isEmpty
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.all(32),
                              child: Text(
                                employees.isEmpty
                                    ? 'ยังไม่มีข้อมูลแม่บ้าน'
                                    : 'ไม่พบชื่อแม่บ้านที่ค้นหา',
                              ),
                            ),
                          )
                        : SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              headingRowColor:
                                  const WidgetStatePropertyAll(
                                AppColors.primaryLight,
                              ),
                              columns: const [
                                DataColumn(
                                  label: Text('ชื่อ-นามสกุล'),
                                ),
                                DataColumn(
                                  label: Text('ประเภทการจ้าง'),
                                ),
                                DataColumn(
                                  label: Text('เบอร์โทรศัพท์'),
                                ),
                                DataColumn(
                                  label: Text('การดำเนินการ'),
                                ),
                              ],
                              rows: filtered.map((e) {
                                final name =
                                    (e['full_name'] ?? '').toString();
                                final type =
                                    (e['employment_type'] ?? '-').toString();
                                final phone =
                                    (e['phone'] ?? '-').toString();
                                final active = e['active'] == true;

                                return DataRow(
                                  cells: [
                                    DataCell(Text(name)),
                                    DataCell(Text(type)),
                                    DataCell(Text(phone)),
                                    DataCell(
                                      TextButton(
                                        onPressed: () => showDialog(
                                          context: context,
                                          builder: (dialogContext) =>
                                              AlertDialog(
                                            title: const Text(
                                              'รายละเอียดแม่บ้าน',
                                            ),
                                            content: Text(
                                              'ชื่อ: $name\n'
                                              'ประเภทการจ้าง: $type\n'
                                              'เบอร์โทรศัพท์: $phone\n'
                                              'สถานะ: ${active ? 'ปฏิบัติงาน' : 'ไม่ปฏิบัติงาน'}',
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.pop(
                                                  dialogContext,
                                                ),
                                                child: const Text('ปิด'),
                                              ),
                                            ],
                                          ),
                                        ),
                                        child: const Text('ดูรายละเอียด'),
                                      ),
                                    ),
                                  ],
                                );
                              }).toList(),
                            ),
                          ),
          ),
          const SizedBox(height: 12),
          if (!isLoading && errorMessage == null)
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                'ทั้งหมด ${employees.length} รายการ',
                style: const TextStyle(
                  color: AppColors.muted,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
// ==================== PAGE 3: WELFARE REQUESTS ====================

class RequestsPage extends StatelessWidget {
  const RequestsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final requests = [
      ['REQ-001', 'สมใจ ใจดี', 'ลาพักร้อน', 'รอพิจารณา'],
      ['REQ-002', 'มาลี ขยันทำ', 'เสื้อทำงาน', 'รอพิจารณา'],
      ['REQ-003', 'สายใจ ตั้งใจ', 'วันลา', 'อนุมัติ'],
      ['REQ-004', 'สมหญิง รักงาน', 'ประกันสังคม', 'รอพิจารณา'],
    ];

    return PageContainer(
      title: 'คำขอสวัสดิการ',
      subtitle: 'ตรวจสอบรายการคำขอและเอกสารประกอบ',
      child: Panel(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            headingRowColor: const WidgetStatePropertyAll(
              AppColors.primaryLight,
            ),
            columns: const [
              DataColumn(label: Text('เลขที่คำขอ')),
              DataColumn(label: Text('ชื่อแม่บ้าน')),
              DataColumn(label: Text('ประเภทสวัสดิการ')),
              DataColumn(label: Text('สถานะ')),
              DataColumn(label: Text('รายละเอียด')),
            ],
            rows: requests.map((r) {
              return DataRow(cells: [
                DataCell(Text(r[0])),
                DataCell(Text(r[1])),
                DataCell(Text(r[2])),
                DataCell(StatusBadge(r[3])),
                DataCell(
                  TextButton(
                    onPressed: () => showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text('รายละเอียด ${r[0]}'),
                        content: Text(
                          'ผู้ยื่นคำขอ: ${r[1]}\n'
                          'ประเภท: ${r[2]}\n'
                          'สถานะ: ${r[3]}\n\n'
                          'เอกสารประกอบ: ข้อมูลจำลอง',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('ปิด'),
                          ),
                        ],
                      ),
                    ),
                    child: const Text('ตรวจสอบ'),
                  ),
                ),
              ]);
            }).toList(),
          ),
        ),
      ),
    );
  }
}

// ==================== PAGE 4: APPROVAL ====================

class ApprovalPage extends StatefulWidget {
  const ApprovalPage({super.key});

  @override
  State<ApprovalPage> createState() => _ApprovalPageState();
}

class _ApprovalPageState extends State<ApprovalPage> {
  final reasonController = TextEditingController();

  final requests = <Map<String, String>>[
    {'id': 'REQ-001', 'name': 'สมใจ ใจดี', 'welfare': 'ลาพักร้อน', 'status': 'รอพิจารณา'},
    {'id': 'REQ-002', 'name': 'มาลี ขยันทำ', 'welfare': 'เสื้อทำงาน', 'status': 'รอพิจารณา'},
    {'id': 'REQ-003', 'name': 'สายใจ ตั้งใจ', 'welfare': 'วันลา', 'status': 'รอพิจารณา'},
  ];

  @override
  void dispose() {
    reasonController.dispose();
    super.dispose();
  }

  void decide(Map<String, String> request, bool approve) {
    if (!approve && reasonController.text.trim().isEmpty) {
      showMessage(context, 'กรุณาระบุเหตุผลในการปฏิเสธ');
      return;
    }

    setState(() {
      request['status'] = approve ? 'อนุมัติ' : 'ปฏิเสธ';
    });

    reasonController.clear();
    Navigator.pop(context);
    showMessage(context, 'บันทึกผลการพิจารณาแล้ว (Mock Data)');
  }

  @override
  Widget build(BuildContext context) {
    return PageContainer(
      title: 'อนุมัติสวัสดิการ',
      subtitle: 'พิจารณาอนุมัติหรือปฏิเสธคำขอของแม่บ้าน',
      child: Panel(
        child: Column(
          children: requests.map((r) {
            return ListTile(
              contentPadding: const EdgeInsets.symmetric(vertical: 8),
              leading: const CircleAvatar(
                backgroundColor: AppColors.primaryLight,
                child: Icon(Icons.description_outlined, color: AppColors.primary),
              ),
              title: Text('${r['id']} · ${r['name']}'),
              subtitle: Text('ประเภทสวัสดิการ: ${r['welfare']}'),
              trailing: Wrap(
                spacing: 8,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  StatusBadge(r['status']!),
                  if (r['status'] == 'รอพิจารณา')
                    OutlinedButton(
                      onPressed: () {
                        reasonController.clear();
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text('พิจารณาคำขอ'),
                            content: SizedBox(
                              width: 400,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('ผู้ยื่น: ${r['name']}'),
                                  Text('สวัสดิการ: ${r['welfare']}'),
                                  const SizedBox(height: 16),
                                  TextField(
                                    controller: reasonController,
                                    maxLines: 3,
                                    decoration: const InputDecoration(
                                      labelText: 'เหตุผล (กรณีปฏิเสธ)',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('ยกเลิก'),
                              ),
                              TextButton(
                                onPressed: () => decide(r, false),
                                child: const Text(
                                  'ปฏิเสธ',
                                  style: TextStyle(color: AppColors.error),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () => decide(r, true),
                                child: const Text('อนุมัติ'),
                              ),
                            ],
                          ),
                        );
                      },
                      child: const Text('พิจารณา'),
                    ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

// ==================== PAGE 5: POLICIES ====================

class PoliciesPage extends StatefulWidget {
  const PoliciesPage({super.key});

  @override
  State<PoliciesPage> createState() => _PoliciesPageState();
}

class _PoliciesPageState extends State<PoliciesPage> {
  final nameController = TextEditingController();
  final amountController = TextEditingController();

  final policies = <Map<String, String>>[
    {'name': 'วันลา', 'amount': '5 วัน', 'condition': 'ตามประเภทการจ้าง', 'status': 'ใช้งาน'},
    {'name': 'ลาพักร้อน', 'amount': '10 วัน', 'condition': 'ตามอายุงาน', 'status': 'ใช้งาน'},
    {'name': 'ประกันสังคม', 'amount': '1 สิทธิ', 'condition': 'เฉพาะพนักงานประจำ', 'status': 'ใช้งาน'},
    {'name': 'เสื้อทำงาน', 'amount': '2 ตัว', 'condition': 'ต่อรอบการแจกจ่าย', 'status': 'ใช้งาน'},
  ];

  @override
  void dispose() {
    nameController.dispose();
    amountController.dispose();
    super.dispose();
  }

  void openPolicyDialog({Map<String, String>? policy}) {
    nameController.text = policy?['name'] ?? '';
    amountController.text = policy?['amount'] ?? '';

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(policy == null ? 'เพิ่มนโยบาย' : 'แก้ไขนโยบาย'),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'ชื่อสวัสดิการ'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: amountController,
                decoration: const InputDecoration(labelText: 'จำนวนสิทธิ/เงื่อนไข'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('ยกเลิก'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.trim().isEmpty ||
                  amountController.text.trim().isEmpty) {
                showMessage(context, 'กรุณากรอกข้อมูลให้ครบ');
                return;
              }

              setState(() {
                if (policy == null) {
                  policies.add({
                    'name': nameController.text.trim(),
                    'amount': amountController.text.trim(),
                    'condition': 'กำหนดเงื่อนไขเพิ่มเติม',
                    'status': 'ใช้งาน',
                  });
                } else {
                  policy['name'] = nameController.text.trim();
                  policy['amount'] = amountController.text.trim();
                }
              });

              Navigator.pop(dialogContext);
              showMessage(context, 'บันทึกนโยบายแล้ว (Mock Data)');
            },
            child: const Text('บันทึก'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PageContainer(
      title: 'นโยบายสวัสดิการ',
      subtitle: 'จัดการประเภท จำนวนสิทธิ และเงื่อนไขสวัสดิการ',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          PrimaryButton(
            label: 'เพิ่มนโยบาย',
            icon: Icons.add,
            onPressed: () => openPolicyDialog(),
          ),
          const SizedBox(height: 16),
          Panel(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingRowColor: const WidgetStatePropertyAll(
                  AppColors.primaryLight,
                ),
                columns: const [
                  DataColumn(label: Text('ประเภทสวัสดิการ')),
                  DataColumn(label: Text('จำนวนสิทธิ')),
                  DataColumn(label: Text('เงื่อนไข')),
                  DataColumn(label: Text('สถานะ')),
                  DataColumn(label: Text('แก้ไข')),
                ],
                rows: policies.map((p) {
                  return DataRow(cells: [
                    DataCell(Text(p['name']!)),
                    DataCell(Text(p['amount']!)),
                    DataCell(Text(p['condition']!)),
                    DataCell(StatusBadge(p['status']!)),
                    DataCell(
                      IconButton(
                        tooltip: 'แก้ไข',
                        icon: const Icon(
                          Icons.edit_outlined,
                          color: AppColors.primary,
                        ),
                        onPressed: () => openPolicyDialog(policy: p),
                      ),
                    ),
                  ]);
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ==================== PAGE 6: EMPLOYEE RIGHTS ====================

class RightsPage extends StatefulWidget {
  const RightsPage({super.key});

  @override
  State<RightsPage> createState() => _RightsPageState();
}

class _RightsPageState extends State<RightsPage> {
  String? selectedEmployee;
  final amountController = TextEditingController();

  final employeeNames = ['สมใจ ใจดี', 'สมหญิง รักงาน', 'มาลี ขยันทำ'];

  final rights = <Map<String, String>>[
    {'employee': 'สมใจ ใจดี', 'welfare': 'วันลา', 'amount': '5 วัน', 'status': 'มีสิทธิ'},
    {'employee': 'สมใจ ใจดี', 'welfare': 'ลาพักร้อน', 'amount': '10 วัน', 'status': 'มีสิทธิ'},
    {'employee': 'สมหญิง รักงาน', 'welfare': 'เสื้อทำงาน', 'amount': '2 ตัว', 'status': 'มีสิทธิ'},
  ];

  @override
  void dispose() {
    amountController.dispose();
    super.dispose();
  }

  void addRight() {
    if (selectedEmployee == null || amountController.text.trim().isEmpty) {
      showMessage(context, 'กรุณาเลือกแม่บ้านและระบุจำนวนสิทธิ');
      return;
    }

    setState(() {
      rights.add({
        'employee': selectedEmployee!,
        'welfare': 'สิทธิที่กำหนดใหม่',
        'amount': amountController.text.trim(),
        'status': 'มีสิทธิ',
      });
      amountController.clear();
    });

    showMessage(context, 'เพิ่มข้อมูลสิทธิแล้ว (Mock Data)');
  }

  @override
  Widget build(BuildContext context) {
    return PageContainer(
      title: 'จัดการสิทธิแม่บ้าน',
      subtitle: 'กำหนดและตรวจสอบสิทธิสวัสดิการของแม่บ้าน',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Panel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'เพิ่มสิทธิแม่บ้าน',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.text,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        initialValue: selectedEmployee,
                        decoration: const InputDecoration(
                          labelText: 'เลือกแม่บ้าน',
                        ),
                        items: employeeNames.map((name) {
                          return DropdownMenuItem(
                            value: name,
                            child: Text(name),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() => selectedEmployee = value);
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextField(
                        controller: amountController,
                        decoration: const InputDecoration(
                          labelText: 'จำนวนสิทธิ',
                          hintText: 'เช่น 5 วัน',
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    PrimaryButton(
                      label: 'เพิ่มสิทธิ',
                      icon: Icons.add,
                      onPressed: addRight,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Panel(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingRowColor: const WidgetStatePropertyAll(
                  AppColors.primaryLight,
                ),
                columns: const [
                  DataColumn(label: Text('ชื่อแม่บ้าน')),
                  DataColumn(label: Text('ประเภทสวัสดิการ')),
                  DataColumn(label: Text('จำนวนสิทธิ')),
                  DataColumn(label: Text('สถานะ')),
                  DataColumn(label: Text('จัดการ')),
                ],
                rows: rights.map((r) {
                  return DataRow(cells: [
                    DataCell(Text(r['employee']!)),
                    DataCell(Text(r['welfare']!)),
                    DataCell(Text(r['amount']!)),
                    DataCell(StatusBadge(r['status']!)),
                    DataCell(
                      TextButton(
                        onPressed: () {
                          setState(() {
                            r['status'] =
                                r['status'] == 'มีสิทธิ' ? 'ยกเลิก' : 'มีสิทธิ';
                          });
                        },
                        child: Text(
                          r['status'] == 'มีสิทธิ' ? 'ยกเลิกสิทธิ' : 'คืนสิทธิ',
                          style: const TextStyle(color: AppColors.error),
                        ),
                      ),
                    ),
                  ]);
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

