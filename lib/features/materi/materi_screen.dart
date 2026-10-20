import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../data/dummy_data.dart';
import '../../models/app_models.dart';
import '../../shared/widgets/default_avatar.dart';

class MateriScreen extends StatefulWidget {
  const MateriScreen({super.key});

  @override
  State<MateriScreen> createState() => _MateriScreenState();
}

class _MateriScreenState extends State<MateriScreen> {
  final DummyDataStore _dataStore = DummyDataStore.instance;
  final TextEditingController _searchController = TextEditingController();

  String _selectedCategory = 'Semua';
  String _searchQuery = '';

  final List<String> _categories = [
    'Semua',
    'Tilawah',
    'Hafalan',
    'Doa',
    'Pegon',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<MateriModel> get _filteredMateri {
    return _dataStore.materiList.where((m) {
      final matchesCategory =
          _selectedCategory == 'Semua' ||
          m.category.toLowerCase() == _selectedCategory.toLowerCase();
      final matchesQuery =
          _searchQuery.isEmpty ||
          m.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          m.summary.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesQuery;
    }).toList();
  }

  void _showMateriDetail(MateriModel item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.lightGreenBadge,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    item.category,
                    style: const TextStyle(
                      color: AppColors.primaryGreen,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => Navigator.pop(ctx),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              item.title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: AppColors.primaryText,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              item.summary,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.secondaryText,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Panduan & Rincian Pembelajaran',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryText,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF6F8F7),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE5EDE8)),
              ),
              child: Text(
                item.detail,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  color: AppColors.primaryText,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Progres Pemahaman:',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(
                  '${item.progress}%',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryGreen,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: item.progress / 100,
                minHeight: 8,
                backgroundColor: Colors.grey.shade200,
                valueColor: const AlwaysStoppedAnimation<Color>(
                  AppColors.primaryGreen,
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final list = _filteredMateri;

    return Scaffold(
      backgroundColor: const Color(0xFFE8E8E8),
      body: Column(
        children: [
          // Header curved container
          Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 8,
              left: 20,
              right: 20,
              bottom: 24,
            ),
            decoration: const BoxDecoration(
              color: AppColors.primaryGreen,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
            ),
            child: Column(
              children: [
                // Top Bar: Avatar left, Title center, Notification right
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const DefaultAvatar(size: 44),
                    const Column(
                      children: [
                        Text(
                          'SIAP-GENERUS',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Materi',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.notifications_none_rounded,
                        color: Colors.white,
                        size: 28,
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Tidak ada pemberitahuan materi baru',
                            ),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 18),

                // Search Bar pill
                Container(
                  height: 46,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(28),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      const Icon(Icons.search, color: Colors.grey, size: 22),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          onChanged: (val) {
                            setState(() {
                              _searchQuery = val.trim();
                            });
                          },
                          decoration: const InputDecoration(
                            hintText: 'Search',
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                              fontStyle: FontStyle.italic,
                            ),
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            filled: false,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ),
                      if (_searchQuery.isNotEmpty)
                        GestureDetector(
                          onTap: () {
                            _searchController.clear();
                            setState(() {
                              _searchQuery = '';
                            });
                          },
                          child: const Icon(
                            Icons.clear,
                            size: 18,
                            color: Colors.grey,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // Horizontal Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: _categories.map((cat) {
                final isSelected = _selectedCategory == cat;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedCategory = cat;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primaryGreen
                            : Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primaryGreen
                              : const Color(0xFF1B1B1B),
                          width: 1.2,
                        ),
                      ),
                      child: Text(
                        cat,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: isSelected
                              ? Colors.white
                              : const Color(0xFF1B1B1B),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 12),

          // Cards list
          Expanded(
            child: list.isEmpty
                ? const Center(
                    child: Text(
                      'Tidak ada materi yang sesuai',
                      style: TextStyle(color: AppColors.secondaryText),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4,
                    ),
                    itemCount: list.length,
                    itemBuilder: (ctx, index) {
                      final item = list[index];
                      return GestureDetector(
                        onTap: () => _showMateriDetail(item),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 14),
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(22),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.04),
                                blurRadius: 10,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.lightGreenBadge,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      item.category,
                                      style: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primaryGreen,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    '${item.progress}% Selesai',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.secondaryGreen,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                item.title,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.primaryText,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                item.summary,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: AppColors.secondaryText,
                                  height: 1.3,
                                ),
                              ),
                              const SizedBox(height: 12),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: LinearProgressIndicator(
                                  value: item.progress / 100,
                                  minHeight: 6,
                                  backgroundColor: const Color(0xFFE8EDE9),
                                  valueColor:
                                      const AlwaysStoppedAnimation<Color>(
                                        AppColors.primaryGreen,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
