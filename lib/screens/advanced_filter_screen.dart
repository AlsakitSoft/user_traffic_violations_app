import 'package:flutter/material.dart';

class AdvancedFilterScreen extends StatefulWidget {
  final Map<String, dynamic> currentFilters;

  const AdvancedFilterScreen({Key? key, required this.currentFilters})
      : super(key: key);

  @override
  _AdvancedFilterScreenState createState() => _AdvancedFilterScreenState();
}

class _AdvancedFilterScreenState extends State<AdvancedFilterScreen> {
  late Map<String, dynamic> _filters;

  final List<String> _violationTypes = [
    'الكل',
    'تجاوز السرعة',
    'وقوف خاطئ',
    'عدم ربط حزام الأمان',
    'استخدام الجوال أثناء القيادة',
    'تجاوز الإشارة الحمراء',
    'عدم إعطاء الأولوية',
  ];

  final List<String> _paymentStatus = [
    'الكل',
    'مدفوعة',
    'غير مدفوعة',
  ];

  @override
  void initState() {
    super.initState();
    _filters = Map<String, dynamic>.from(widget.currentFilters);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تصفية متقدمة'),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
        actions: [
          TextButton(
            onPressed: _resetFilters,
            child: const Text(
              'إعادة تعيين',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // تصفية حسب نوع المخالفة
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'نوع المخالفة',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: _filters['violationType'] ?? 'الكل',
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                      ),
                      items: _violationTypes.map((String type) {
                        return DropdownMenuItem<String>(
                          value: type,
                          child: Text(type),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _filters['violationType'] = newValue;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // تصفية حسب حالة السداد
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'حالة السداد',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: _filters['paymentStatus'] ?? 'الكل',
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                      ),
                      items: _paymentStatus.map((String status) {
                        return DropdownMenuItem<String>(
                          value: status,
                          child: Text(status),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _filters['paymentStatus'] = newValue;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // تصفية حسب التاريخ
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'فترة التاريخ',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('من تاريخ:'),
                              const SizedBox(height: 8),
                              InkWell(
                                onTap: () => _selectDate(context, 'fromDate'),
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.calendar_today),
                                      const SizedBox(width: 8),
                                      Text(
                                        _filters['fromDate'] != null
                                            ? '${_filters['fromDate'].day}/${_filters['fromDate'].month}/${_filters['fromDate'].year}'
                                            : 'اختر التاريخ',
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('إلى تاريخ:'),
                              const SizedBox(height: 8),
                              InkWell(
                                onTap: () => _selectDate(context, 'toDate'),
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.calendar_today),
                                      const SizedBox(width: 8),
                                      Text(
                                        _filters['toDate'] != null
                                            ? '${_filters['toDate'].day}/${_filters['toDate'].month}/${_filters['toDate'].year}'
                                            : 'اختر التاريخ',
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // تصفية حسب المكان
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'البحث في المكان',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      initialValue: _filters['location'] ?? '',
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'ادخل اسم الشارع أو المنطقة',
                        prefixIcon: Icon(Icons.search),
                      ),
                      onChanged: (value) {
                        _filters['location'] = value;
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('إلغاء'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context, _filters),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[800],
                  foregroundColor: Colors.white,
                ),
                child: const Text('تطبيق التصفية'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, String filterKey) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _filters[filterKey] ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _filters[filterKey] = picked;
      });
    }
  }

  void _resetFilters() {
    setState(() {
      _filters = {
        'violationType': 'الكل',
        'paymentStatus': 'الكل',
        'fromDate': null,
        'toDate': null,
        'location': '',
      };
    });
  }
}

