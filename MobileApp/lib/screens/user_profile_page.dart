import 'package:flutter/material.dart';
import '../widgets/tri_widgets.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  bool isEditing = false;

  // بيانات مبدئية (لاحقًا تجي من السيرفر/الـ DB)
  String fullName = 'Test User';
  String role = 'User';
  String accountId = 'EMP-1023';
  String email = 'testuser@triguard.com';
  String phone = '+966 5X XXX XXXX';

  late final TextEditingController nameController;
  late final TextEditingController emailController;
  late final TextEditingController phoneController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: fullName);
    emailController = TextEditingController(text: email);
    phoneController = TextEditingController(text: phone);
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  void _startEdit() {
    setState(() {
      isEditing = true;
      // نضمن إن الحقول تعكس آخر بيانات محفوظة
      nameController.text = fullName;
      emailController.text = email;
      phoneController.text = phone;
    });
  }

  void _cancelEdit() {
    setState(() {
      isEditing = false;
      nameController.text = fullName;
      emailController.text = email;
      phoneController.text = phone;
    });
  }

  void _saveEdit() {
    final newName = nameController.text.trim();
    final newEmail = emailController.text.trim();
    final newPhone = phoneController.text.trim();

    if (newName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الاسم مطلوب')),
      );
      return;
    }

    setState(() {
      fullName = newName;
      email = newEmail.isEmpty ? email : newEmail;
      phone = newPhone.isEmpty ? phone : newPhone;
      isEditing = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم حفظ البيانات بنجاح ✅')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Column(
        children: [
          const SizedBox(height: 18),
          Center(child: TriLogo(size: 70)),
          const SizedBox(height: 10),

          const Text(
            'الملف الشخصي',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 6),
          Text(
            'معلومات حسابك الأساسية وخيارات تعديل البيانات حسب الصلاحيات.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13.5, color: Colors.black.withOpacity(0.55)),
          ),
          const SizedBox(height: 16),

          // بطاقة الهوية الرئيسية
          _GlassHeaderCard(
            name: fullName,
            role: role,
            accountId: accountId,
          ),
          const SizedBox(height: 12),

          // بيانات الحساب (عرض/تعديل)
          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                _SectionTitle(title: 'بيانات الحساب'),

                const SizedBox(height: 10),

                _GlassInfoRow(
                  icon: Icons.badge_outlined,
                  title: 'ID الحساب',
                  value: accountId,
                  readOnly: true,
                ),

                const SizedBox(height: 10),

                _GlassInfoRow(
                  icon: Icons.verified_user_outlined,
                  title: 'الدور',
                  value: role,
                  readOnly: true,
                ),

                const SizedBox(height: 14),
                _SectionTitle(title: 'بيانات التواصل'),

                const SizedBox(height: 10),

                if (!isEditing) ...[
                  _GlassInfoRow(
                    icon: Icons.alternate_email_rounded,
                    title: 'البريد الإلكتروني',
                    value: email,
                    readOnly: true,
                  ),
                  const SizedBox(height: 10),
                  _GlassInfoRow(
                    icon: Icons.phone_rounded,
                    title: 'رقم الجوال',
                    value: phone,
                    readOnly: true,
                  ),
                ] else ...[
                  TriTextField(
                    hint: 'الاسم الكامل',
                    icon: Icons.person_outline_rounded,
                    controller: nameController,
                  ),
                  const SizedBox(height: 12),
                  TriTextField(
                    hint: 'البريد الإلكتروني',
                    icon: Icons.alternate_email_rounded,
                    controller: emailController,
                  ),
                  const SizedBox(height: 12),
                  TriTextField(
                    hint: 'رقم الجوال',
                    icon: Icons.phone_rounded,
                    controller: phoneController,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'ملاحظة: الدور و ID الحساب غير قابلة للتعديل للمستخدم.',
                    style: TextStyle(fontSize: 12, color: Colors.black.withOpacity(0.55)),
                  ),
                ],

                const SizedBox(height: 16),

                // أزرار التحكم
                if (!isEditing) ...[
                  GradientButton(
                    text: 'تعديل البيانات',
                    icon: Icons.edit_rounded,
                    onTap: _startEdit,
                    filled: true,
                  ),
                
                ] else ...[
                  GradientButton(
                    text: 'حفظ',
                    icon: Icons.check_circle_outline,
                    onTap: _saveEdit,
                    filled: true,
                  ),
                  const SizedBox(height: 10),
                  GradientButton(
                    text: 'إلغاء',
                    icon: Icons.close_rounded,
                    onTap: _cancelEdit,
                    filled: false,
                  ),
                ],

                const SizedBox(height: 14),
                const FooterPill(text: 'TriGuard | تنظيم معلومات الحساب بشكل واضح'),
                const SizedBox(height: 14),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Text(
        title,
        style: TextStyle(
          fontSize: 13.5,
          fontWeight: FontWeight.w900,
          color: Colors.black.withOpacity(0.70),
        ),
      ),
    );
  }
}

class _GlassHeaderCard extends StatelessWidget {
  final String name;
  final String role;
  final String accountId;

  const _GlassHeaderCard({
    required this.name,
    required this.role,
    required this.accountId,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.70),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.45)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              gradient: const LinearGradient(
                colors: [TriColors.c1, TriColors.c2, TriColors.c3],
              ),
            ),
            child: const Icon(Icons.person_rounded, color: Colors.white, size: 30),
          ),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
                const SizedBox(height: 4),
                Text(
                  'الدور: $role',
                  style: TextStyle(
                    fontSize: 12.8,
                    color: Colors.black.withOpacity(0.65),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'ID: $accountId',
                  style: TextStyle(
                    fontSize: 12.8,
                    color: Colors.black.withOpacity(0.65),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(999),
              color: const Color(0xFF16A34A).withOpacity(0.12),
            ),
            child: const Row(
              children: [
                Icon(Icons.verified_rounded, size: 16, color: Color(0xFF16A34A)),
                SizedBox(width: 6),
                Text(
                  'Verified',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Color(0xFF16A34A)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GlassInfoRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final bool readOnly;

  const _GlassInfoRow({
    required this.icon,
    required this.title,
    required this.value,
    required this.readOnly,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.70),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.45)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: TriColors.c2.withOpacity(0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: TriColors.c2),
          ),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w800)),
                const SizedBox(height: 4),
                Text(value, style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w900)),
              ],
            ),
          ),

          const SizedBox(width: 8),
          Icon(
            readOnly ? Icons.lock_outline_rounded : Icons.edit_rounded,
            size: 18,
            color: Colors.black.withOpacity(0.40),
          ),
        ],
      ),
    );
  }
} 