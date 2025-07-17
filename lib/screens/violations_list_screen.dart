import 'package:flutter/material.dart';
import '../models/violation.dart';
import '../services/api_service.dart';
import 'violation_details_screen.dart';
import 'advanced_filter_screen.dart';

class ViolationsListScreen extends StatefulWidget {
  final String userId;

  const ViolationsListScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _ViolationsListScreenState createState() => _ViolationsListScreenState();
}

class _ViolationsListScreenState extends State<ViolationsListScreen> {
  final ApiService _apiService = ApiService();
  List<Violation> _violations = [];
  List<Violation> _filteredViolations = [];
  bool _isLoading = true;
  String _selectedFilter = 'الكل';
  Map<String, dynamic> _advancedFilters = {};
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadViolations();
  }

  Future<void> _loadViolations() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final violations = await _apiService.getViolationsForCitizen(widget.userId);
      setState(() {
        _violations = violations;
        _filteredViolations = violations;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطأ في تحميل المخالفات: $e')),
      );
    }
  }

  void _filterViolations(String filter) {
    setState(() {
      _selectedFilter = filter;
      _applyAllFilters();
    });
  }

  void _applyAllFilters() {
    List<Violation> filtered = _violations;

    // تطبيق التصفية الأساسية
    if (_selectedFilter == 'مدفوعة') {
      filtered = filtered.where((v) => v.isPaid).toList();
    } else if (_selectedFilter == 'غير مدفوعة') {
      filtered = filtered.where((v) => !v.isPaid).toList();
    }

    // تطبيق التصفية المتقدمة
    if (_advancedFilters.isNotEmpty) {
      // تصفية حسب نوع المخالفة
      if (_advancedFilters['violationType'] != null && 
          _advancedFilters['violationType'] != 'الكل') {
        filtered = filtered.where((v) => 
            v.type == _advancedFilters['violationType']).toList();
      }

      // تصفية حسب حالة السداد
      if (_advancedFilters['paymentStatus'] != null && 
          _advancedFilters['paymentStatus'] != 'الكل') {
        if (_advancedFilters['paymentStatus'] == 'مدفوعة') {
          filtered = filtered.where((v) => v.isPaid).toList();
        } else if (_advancedFilters['paymentStatus'] == 'غير مدفوعة') {
          filtered = filtered.where((v) => !v.isPaid).toList();
        }
      }

      // تصفية حسب التاريخ
      if (_advancedFilters['fromDate'] != null) {
        filtered = filtered.where((v) => 
            v.timestamp.isAfter(_advancedFilters['fromDate'])).toList();
      }
      if (_advancedFilters['toDate'] != null) {
        filtered = filtered.where((v) => 
            v.timestamp.isBefore(_advancedFilters['toDate'].add(Duration(days: 1)))).toList();
      }

      // تصفية حسب المكان
      if (_advancedFilters['location'] != null && 
          _advancedFilters['location'].isNotEmpty) {
        filtered = filtered.where((v) => 
            v.location.toLowerCase().contains(_advancedFilters['location'].toLowerCase())).toList();
      }
    }

    // تطبيق البحث النصي
    if (_searchController.text.isNotEmpty) {
      filtered = filtered.where((v) => 
          v.type.toLowerCase().contains(_searchController.text.toLowerCase()) ||
          v.location.toLowerCase().contains(_searchController.text.toLowerCase()) ||
          v.id.toLowerCase().contains(_searchController.text.toLowerCase())).toList();
    }

    setState(() {
      _filteredViolations = filtered;
    });
  }

  void _openAdvancedFilter() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AdvancedFilterScreen(currentFilters: _advancedFilters),
      ),
    );
    if (result != null) {
      setState(() {
        _advancedFilters = result;
        _applyAllFilters();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('المخالفات المرورية'),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // شريط البحث
          Container(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'البحث في المخالفات...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _applyAllFilters();
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (value) => _applyAllFilters(),
            ),
          ),
          // شريط التصفية
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                const Text('تصفية سريعة: ', style: TextStyle(fontSize: 16)),
                const SizedBox(width: 10),
                Expanded(
                  child: DropdownButton<String>(
                    value: _selectedFilter,
                    isExpanded: true,
                    items: ['الكل', 'مدفوعة', 'غير مدفوعة']
                        .map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        _filterViolations(newValue);
                      }
                    },
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  onPressed: _openAdvancedFilter,
                  icon: const Icon(Icons.filter_list, size: 18),
                  label: const Text('تصفية متقدمة'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[800],
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // قائمة المخالفات
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredViolations.isEmpty
                    ? const Center(
                        child: Text(
                          'لا توجد مخالفات',
                          style: TextStyle(fontSize: 18),
                        ),
                      )
                    : ListView.builder(
                        itemCount: _filteredViolations.length,
                        itemBuilder: (context, index) {
                          final violation = _filteredViolations[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: ListTile(
                              leading: Icon(
                                violation.isPaid
                                    ? Icons.check_circle
                                    : Icons.warning,
                                color: violation.isPaid
                                    ? Colors.green
                                    : Colors.red,
                                size: 30,
                              ),
                              title: Text(
                                violation.type,
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('المكان: ${violation.location}'),
                                  Text(
                                      'التاريخ: ${violation.timestamp.day}/${violation.timestamp.month}/${violation.timestamp.year}'),
                                  Text(
                                    'الحالة: ${violation.isPaid ? 'مدفوعة' : 'غير مدفوعة'}',
                                    style: TextStyle(
                                      color: violation.isPaid
                                          ? Colors.green
                                          : Colors.red,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              trailing: const Icon(Icons.arrow_forward_ios),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ViolationDetailsScreen(
                                        violationId: violation.id),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _loadViolations,
        child: const Icon(Icons.refresh),
        backgroundColor: Colors.blue[800],
      ),
    );
  }
}


