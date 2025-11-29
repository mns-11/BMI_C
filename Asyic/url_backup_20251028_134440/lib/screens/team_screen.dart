import 'package:flutter/material.dart';

class TeamScreen extends StatelessWidget {
  const TeamScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('فريق فينا الخير'),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFD5580F), // Primary Orange
                Color(0xFFB2DFDB), // Light Teal
                Color(0xFFFFE0B2), // Light Orange
                Color(0xFFB3E5FC), // Light Blue
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFF8F9FA),
              Color(0xFFE9ECEF),
              Color(0xFFF1F3F4),
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Team Header
              _buildTeamHeader(),
              const SizedBox(height: 24),

              // Our Mission
              _buildSectionCard(
                title: 'رسالتنا',
                icon: Icons.flag,
                content: 'فريق "فينا الخير" ملتزم بتطوير المحتوى الإسلامي والمساهمة في نشر المعرفة الدينية. نحن نؤمن بأن المعرفة الإسلامية حق للجميع ونسعى لتوفير محتوى متميز وموثوق للمسلمين في كل مكان.',
              ),

              const SizedBox(height: 16),

              // Our Goals
              _buildSectionCard(
                title: 'أهدافنا',
                icon: Icons.gps_fixed,
                content: '• تطوير تطبيقات إسلامية متميزة وسهلة الاستخدام\n• توفير محتوى إسلامي موثوق ومفيد للمسلمين\n• تعزيز الوعي الديني والثقافة الإسلامية\n• بناء جسور التواصل مع المطورين والمصممين\n• نشر المعرفة الإسلامية ودحض المعلومات المغلوطة',
              ),

              const SizedBox(height: 16),

              // Our Activities
              _buildSectionCard(
                title: 'أنشطتنا',
                icon: Icons.local_activity,
                content: '• تطوير منصات إعلامية إسلامية متميزة\n• توثيق التراث الإسلامي والمحتوى الديني\n• تنظيم حملات تعليمية وتوعوية إسلامية\n• مشاركة المحتوى الإسلامي المفيد\n• دعم المبادرات الإسلامية والتعليمية\n• بناء شبكات التواصل مع المطورين والمصممين الإسلاميين',
              ),

              const SizedBox(height: 16),

              // Join Us Section
              _buildJoinUsCard(context),

              const SizedBox(height: 24),

              // Contact Info
              _buildContactCard(),

              const SizedBox(height: 16),

              // Team Members
              _buildTeamMembersCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTeamHeader() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            colors: [
              Color(0xFFD5580F), // Primary Orange
              Color(0xFFB2DFDB), // Light Teal
              Color(0xFFFFE0B2), // Light Orange
              Color(0xFFB3E5FC), // Light Blue
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFFD5580F),
                    Color(0xFFB2DFDB),
                    Color(0xFFFFE0B2),
                    Color(0xFFB3E5FC),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                border: Border.all(
                  color: const Color(0xFFD5580F),
                  width: 4,
                ),
                image: const DecorationImage(
                  image: AssetImage('assets/images/team_logo.png'),
                  fit: BoxFit.cover,
                  onError: null, // Handle missing image gracefully
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.1),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'فريق فينا الخير',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: 'Amiri',
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'فريق التطوير والمحتوى الإسلامي',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.9),
                fontSize: 16,
                fontFamily: 'Roboto',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({required String title, required IconData icon, required String content}) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD5580F).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    color: const Color(0xFFD5580F),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1A1A),
                    fontFamily: 'Amiri',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              content,
              style: const TextStyle(
                fontSize: 14,
                height: 1.6,
                color: Color(0xFF333333),
                fontFamily: 'Roboto',
              ),
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildJoinUsCard(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: const LinearGradient(
            colors: [
              Color(0xFFD5580F),
              Color(0xFF10B981),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.person_add,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'انضم إلينا',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'Amiri',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              'هل تريد المشاركة في تطوير المحتوى الإسلامي ونشر المعرفة الدينية؟ نحن نرحب بكل من يريد المساهمة في تطوير التطبيق وإثراء المحتوى الإسلامي.',
              style: TextStyle(
                fontSize: 14,
                height: 1.6,
                color: Colors.white,
                fontFamily: 'Roboto',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('سيتم إضافة معلومات التواصل قريباً'),
                    backgroundColor: Color(0xFFD5580F),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFFD5580F),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('تواصل معنا'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactCard() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD5580F).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.contact_mail,
                    color: Color(0xFFD5580F),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'تواصل معنا',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1A1A),
                    fontFamily: 'Amiri',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Row(
              children: [
                Icon(Icons.email, size: 16, color: Colors.grey),
                SizedBox(width: 8),
                Text(
                  'info@feenaalkhair.com',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF333333),
                    fontFamily: 'Roboto',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Row(
              children: [
                Icon(Icons.language, size: 16, color: Colors.grey),
                SizedBox(width: 8),
                Text(
                  'www.feenaalkhair.com',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF333333),
                    fontFamily: 'Roboto',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamMember(String name, String role, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFFD5580F).withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFD5580F).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: const Color(0xFFD5580F),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1A1A),
                    fontFamily: 'Roboto',
                  ),
                ),
                Text(
                  role,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontFamily: 'Roboto',
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: Colors.grey[400],
          ),
        ],
      ),
    );
  }

  Widget _buildTeamMembersCard() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD5580F).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.group,
                    color: Color(0xFFD5580F),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'أعضاء الفريق',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1A1A),
                    fontFamily: 'Amiri',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Team members list
            _buildTeamMember('أحمد محمد', 'مطور التطبيقات', Icons.account_balance),
            const SizedBox(height: 12),
            _buildTeamMember('فاطمة أحمد', 'مصممة واجهات المستخدم', Icons.public),
            const SizedBox(height: 12),
            _buildTeamMember('محمد علي', 'محتوى وتوثيق', Icons.article),
            const SizedBox(height: 12),
            _buildTeamMember('سارة عبدالله', 'منسقة المشاريع', Icons.campaign),

            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFD5580F).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline, size: 16, color: Color(0xFFD5580F)),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'نرحب بكل من يريد الانضمام لفريقنا والمساهمة في تطوير المحتوى الإسلامي',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFFD5580F),
                        fontFamily: 'Roboto',
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
