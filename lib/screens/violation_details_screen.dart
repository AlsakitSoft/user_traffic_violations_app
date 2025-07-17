import 'package:flutter/material.dart';
import '../models/violation.dart';
import '../services/api_service.dart';

class ViolationDetailsScreen extends StatefulWidget {
  final String violationId;

  const ViolationDetailsScreen({Key? key, required this.violationId})
      : super(key: key);

  @override
  _ViolationDetailsScreenState createState() => _ViolationDetailsScreenState();
}

class _ViolationDetailsScreenState extends State<ViolationDetailsScreen> {
  final ApiService _apiService = ApiService();
  Violation? _violation;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadViolationDetails();
  }

  Future<void> _loadViolationDetails() async {
    try {
      final violation = await _apiService.getViolationDetails(widget.violationId);
      setState(() {
        _violation = violation;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطأ في تحميل تفاصيل المخالفة: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تفاصيل المخالفة'),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _violation == null
              ? const Center(
                  child: Text(
                    'لم يتم العثور على المخالفة',
                    style: TextStyle(fontSize: 18),
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // بطاقة معلومات المخالفة الأساسية
                      Card(
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    _violation!.isPaid
                                        ? Icons.check_circle
                                        : Icons.warning,
                                    color: _violation!.isPaid
                                        ? Colors.green
                                        : Colors.red,
                                    size: 40,
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          _violation!.type,
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: _violation!.isPaid
                                                ? Colors.green
                                                : Colors.red,
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: Text(
                                            _violation!.isPaid
                                                ? 'مدفوعة'
                                                : 'غير مدفوعة',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
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
                      // بطاقة تفاصيل المخالفة
                      Card(
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'تفاصيل المخالفة',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),
                              _buildDetailRow('رقم المخالفة', _violation!.id),
                              _buildDetailRow('نوع المخالفة', _violation!.type),
                              if (_violation!.description != null && _violation!.description!.isNotEmpty)
                                _buildDetailRow('الوصف', _violation!.description!),
                              _buildDetailRow('المكان', _violation!.location),
                              _buildDetailRow(
                                'التاريخ والوقت',
                                '${_violation!.timestamp.day}/${_violation!.timestamp.month}/${_violation!.timestamp.year} - ${_violation!.timestamp.hour}:${_violation!.timestamp.minute.toString().padLeft(2, '0')}',
                              ),
                              _buildDetailRow('المبلغ', '${_violation!.fineAmount.toStringAsFixed(2)} ريال'),
                              _buildDetailRow('الحالة', _violation!.status),
                              if (_violation!.paymentDate != null)
                                _buildDetailRow('تاريخ الدفع', '${_violation!.paymentDate!.day}/${_violation!.paymentDate!.month}/${_violation!.paymentDate!.year}'),
                              _buildDetailRow('رقم المركبة', _violation!.vehicle?.plateNumber ?? 'غير متوفر'),
                              _buildDetailRow('اسم رجل المرور', _violation!.officer?.name ?? 'غير متوفر'),
                              if (_violation!.evidenceImageUrl != null && _violation!.evidenceImageUrl!.isNotEmpty)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 8),
                                    const Text(
                                      'صورة الدليل:',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Image.network(_violation!.evidenceImageUrl!),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // بطاقة الإجراءات
                      if (!_violation!.isPaid)
                        Card(
                          elevation: 4,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'الإجراءات المتاحة',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton.icon(
                                    onPressed: () async {
                                      // هنا يمكن إضافة وظيفة الدفع
                                      try {
                                        await _apiService.updateViolationStatus(_violation!.id, 'Paid');
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('تم دفع المخالفة بنجاح!')), 
                                        );
                                        _loadViolationDetails(); // Reload details to reflect change
                                      } catch (e) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('فشل دفع المخالفة: $e')), 
                                        );
                                      }
                                    },
                                    icon: const Icon(Icons.payment),
                                    label: const Text('دفع المخالفة'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                SizedBox(
                                  width: double.infinity,
                                  child: OutlinedButton.icon(
                                    onPressed: () {
                                      // هنا يمكن إضافة وظيفة الاعتراض
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('سيتم توجيهك لصفحة الاعتراض'),
                                        ),
                                      );
                                    },
                                    icon: const Icon(Icons.gavel),
                                    label: const Text('الاعتراض على المخالفة'),
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: Colors.orange,
                                      side: const BorderSide(color: Colors.orange),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}


