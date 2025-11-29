import 'package:flutter/material.dart';

class PageAppBar extends StatelessWidget implements PreferredSizeWidget {
  final int currentPage;
  final int totalPages;
  final Function(int) onPageSelected;

  const PageAppBar({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onPageSelected,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        'المصحف الشريف - الصفحة $currentPage',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 18,
          fontFamily: 'Amiri',
          shadows: [
            Shadow(
              color: Colors.black26,
              offset: Offset(1, 1),
              blurRadius: 3,
            ),
          ],
        ),
      ),
      centerTitle: true,
      backgroundColor: const Color(0xFFB8860B),
      foregroundColor: Colors.white,
      elevation: 8,
      shadowColor: const Color(0xFFB8860B).withValues(alpha: 0.3),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.of(context).pop(),
        tooltip: 'رجوع',
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () => _showPageDialog(context),
          tooltip: 'البحث عن صفحة',
        ),
        IconButton(
          icon: const Icon(Icons.bookmark_border),
          onPressed: () => _showBookmarkDialog(context),
          tooltip: 'إشارة مرجعية',
        ),
      ],
    );
  }

  void _showPageDialog(BuildContext context) {
    final TextEditingController pageController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'الانتقال إلى صفحة',
          style: TextStyle(
            fontFamily: 'Amiri',
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.right,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: pageController,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
              decoration: InputDecoration(
                hintText: 'أدخل رقم الصفحة (1 - $totalPages)',
                border: const OutlineInputBorder(),
                contentPadding: const EdgeInsets.all(16),
              ),
              style: const TextStyle(fontFamily: 'Amiri'),
            ),
            const SizedBox(height: 16),
            Text(
              'الصفحة الحالية: $currentPage من $totalPages',
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
                fontFamily: 'Amiri',
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'إلغاء',
              style: TextStyle(
                color: Color(0xFFB8860B),
                fontFamily: 'Amiri',
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              final pageNum = int.tryParse(pageController.text);
              if (pageNum != null && pageNum >= 1 && pageNum <= totalPages) {
                onPageSelected(pageNum);
                Navigator.of(context).pop();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('يرجى إدخال رقم صفحة صحيح'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFB8860B),
              foregroundColor: Colors.white,
            ),
            child: const Text(
              'انتقال',
              style: TextStyle(fontFamily: 'Amiri'),
            ),
          ),
        ],
      ),
    );
  }

  void _showBookmarkDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'إشارات مرجعية',
          style: TextStyle(
            fontFamily: 'Amiri',
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.right,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text(
                'الصفحة الحالية',
                style: TextStyle(fontFamily: 'Amiri'),
                textAlign: TextAlign.right,
              ),
              subtitle: Text(
                'الصفحة $currentPage',
                textAlign: TextAlign.right,
              ),
              trailing: IconButton(
                icon: const Icon(Icons.bookmark),
                color: const Color(0xFFB8860B),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('تم حفظ الصفحة $currentPage كإشارة مرجعية'),
                      backgroundColor: const Color(0xFFB8860B),
                    ),
                  );
                  Navigator.of(context).pop();
                },
              ),
            ),
            const Divider(),
            const Text(
              'الصفحات المحفوظة',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
                fontFamily: 'Amiri',
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'إغلاق',
              style: TextStyle(
                color: Color(0xFFB8860B),
                fontFamily: 'Amiri',
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
