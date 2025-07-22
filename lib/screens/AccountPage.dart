import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'HomePage.dart';
// import 'PresentOrder.dart';
// import 'FavoritesPage.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final Color greenColor = const Color(0xFF048372);
  final Color grayColor = const Color(0xFFF6F6F6);

  //   النموذج للتحقق من صحة الحقول
  final _formKey = GlobalKey<FormState>();
  //  المتحكمات لحقول النص
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  String? _selectedCity; // لتخزين القيمة المختارة من القائمة المنسدلة
  int currentIndex = 3;

  void onBottomNavItemTapped(int index) {
    setState(() {
      currentIndex = index;
    });
    // مثال:
    // if (index == 0) {
    //   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage()));
    // } else if (index == 1) { // طلباتي
    //   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const NewOrder())); // أو PresentOrder أو PastOrder
    // } else if (index == 2) { // المفضلة
    //   // لا شيء، لأن هذه الصفحة هي المفضلة
    // } else if (index == 3) { // حسابي
    //   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AccountPage()));
    // }
  }

////////////////////////////////////////////////////////////////////////////////////////
  @override
  void initState() {
    super.initState();
    //  تعيين قيم افتراضية للمتحكمات عند تهيئة الصفحة
    _usernameController.text = 'اسم المستخدم الحالي';
    _phoneController.text = '05xxxxxxxx';
    _emailController.text = 'example@email.com';
    _selectedCity = null; // لا يوجد اختيار افتراضي للمدينة
  }

  @override
  void dispose() {
    //  التخلص من المتحكمات عند إغلاق الصفحة لتجنب تسرب الذاكرة
    _usernameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

///////////////////////////////////////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        ////////////////////////////////////////
        backgroundColor: grayColor,
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text(
            'حسابي',
            style: TextStyle(
              color: greenColor,
              fontFamily: 'Almarai',
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios, color: greenColor),
          ),
        ),
        ////////////////////////////////////////

//nav bar////////////////////////////////////////////////////////////////////////////
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: onBottomNavItemTapped,
          selectedItemColor: greenColor,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'الرئيسية'),
            BottomNavigationBarItem(
                icon: Icon(Icons.inventory_2_outlined), label: 'طلباتي'),
            BottomNavigationBarItem(
                icon: Icon(Icons.favorite_border), label: 'المفضلة'),
            BottomNavigationBarItem(
                icon: Icon(Icons.person_outline), label: 'حسابي'),
          ],
        ),
///////////////////////////////////////////////////////////////////////////////////////


        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _formKey, // تعيين المفتاح للنموذج
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildTextFormField(
                          label: 'اسم المستخدم',
                          controller: _usernameController,
                          hintText: 'أدخل اسم المستخدم',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'الرجاء إدخال اسم المستخدم';
                            }
                            return null;
                          },
                          //  إضافة inputFormatters للسماح بالعربية والإنجليزية والأرقام والمسافات
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'[\u0600-\u06FFa-zA-Z0-9\s]')),
                          ],
                        ),
                        _buildTextFormField(
                          label: 'رقم الجوال',
                          controller: _phoneController,
                          hintText: '05xxxxxxxx',
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'الرجاء إدخال رقم الجوال';
                            }
                            if (!value.startsWith('05') ||
                                value.length != 10 ||
                                !RegExp(r'^[0-9]+$').hasMatch(value)) {
                              return 'الرجاء إدخال رقم جوال سعودي صحيح (يبدأ بـ 05 و10 أرقام)';
                            }
                            return null;
                          },
                        ),
                        _buildTextFormField(
                          label: 'البريد الإلكتروني',
                          controller: _emailController,
                          hintText: 'example@email.com',
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'الرجاء إدخال البريد الإلكتروني';
                            }
                            if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                .hasMatch(value)) {
                              return 'الرجاء إدخال بريد إلكتروني صحيح';
                            }
                            return null;
                          },
                        ),
                        _buildDropdownFormField(
                          label: 'المدينة',
                          value: _selectedCity,
                          hintText: 'اختر المدينة',
                          items: const ['جدة', 'الرياض', 'مكة'],
                          onChanged: (newValue) {
                            setState(() {
                              _selectedCity = newValue;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'الرجاء اختيار المدينة';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        //  زر حفظ التعديلات
                        Align(
                          alignment: Alignment.centerLeft,
                          child: SizedBox(
                            width: 150,
                            child: ElevatedButton(
                              onPressed: () {
                                //  تشغيل التحقق عند الضغط على الزر
                                if (_formKey.currentState!.validate()) {
                                  // إذا كانت جميع الحقول صحيحة
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('تم حفظ التعديلات بنجاح!'),
                                      backgroundColor: greenColor,
                                    ),
                                  );
                                  // هنا يمكنك حفظ البيانات (مثلاً إرسالها إلى API)
                                  print(
                                      'اسم المستخدم: ${_usernameController.text}');
                                  print('رقم الجوال: ${_phoneController.text}');
                                  print(
                                      'البريد الإلكتروني: ${_emailController.text}');
                                  print('المدينة: $_selectedCity');
                                } else {
                                  // إذا كانت هناك أخطاء في التحقق
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          'الرجاء تصحيح الأخطاء في النموذج.'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: greenColor,
                                padding:
                                const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text(
                                'حفظ التعديلات',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'Almarai',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //  دالة بناء حقول النص مع التحقق
  Widget _buildTextFormField({
    required String label,
    required TextEditingController controller,
    String? hintText,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'Almarai',
              fontSize: 16,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: greenColor),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 12), // تعديل المسافة الداخلية
            child: TextFormField(
              //  استخدام TextFormField
              controller: controller,
              keyboardType: keyboardType,
              validator: validator, //  إضافة validator
              style: const TextStyle(fontFamily: 'Almarai'),
              inputFormatters: inputFormatters, //  استخدام المعامل الجديد هنا
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle:
                TextStyle(color: Colors.grey[400], fontFamily: 'Almarai'),
                border: InputBorder
                    .none, // إزالة الحدود الافتراضية لـ TextFormField
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 14), // ضبط المسافة الرأسية
              ),
            ),
          ),
        ),
      ],
    );
  }

  //  دالة بناء القائمة المنسدلة مع التحقق
  Widget _buildDropdownFormField({
    required String label,
    required String? value,
    required String hintText,
    required List<String> items,
    required void Function(String?) onChanged,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'Almarai',
              fontSize: 16,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: greenColor),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: DropdownButtonFormField<String>(
              //  استخدام DropdownButtonFormField
              value: value,
              hint: Text(hintText,
                  style: TextStyle(
                      fontFamily: 'Almarai', color: Colors.grey[400])),
              items: items
                  .map((item) => DropdownMenuItem(
                  value: item,
                  child: Text(item,
                      style: const TextStyle(fontFamily: 'Almarai'))))
                  .toList(),
              onChanged: onChanged,
              validator: validator, //validator
              decoration: const InputDecoration(
                border: InputBorder.none, // إزالة الحدود الافتراضية
                contentPadding:
                EdgeInsets.symmetric(vertical: 8), // ضبط المسافة الرأسية
              ),
            ),
          ),
        ),
      ],
    );
  }
}
