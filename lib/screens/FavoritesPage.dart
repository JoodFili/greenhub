import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'AddFavorate.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  final Color greenColor = const Color(0xFF048372);
  final Color grayColor = const Color(0xFFF6F6F6);
  int currentIndex = 2;

  List<Map<String, dynamic>> favorites = [];
  bool isLoading = true;
  String? errorMessage;
  int? selectedIndex;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    final dio = Dio();
    final String apiUrl = 'http://192.168.0.128:8000/api/favorite-destinations';

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token'); // ✅ تأكد من الاسم

      if (token == null || token.isEmpty) {
        setState(() {
          isLoading = false;
          errorMessage = 'يجب تسجيل الدخول أولاً';
        });
        return;
      }

      final response = await dio.get(
        apiUrl,
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
          validateStatus: (status) => true,
        ),
      );

      if (response.statusCode == 200) {
        List<Map<String, dynamic>> loadedFavorites = [];

        if (response.data is List) {
          loadedFavorites = List<Map<String, dynamic>>.from(response.data);
        } else if (response.data is Map) {
          final data = response.data as Map<String, dynamic>;
          if (data.containsKey('data')) {
            loadedFavorites = List<Map<String, dynamic>>.from(data['data'] ?? []);
          } else if (data.containsKey('favorites')) {
            loadedFavorites = List<Map<String, dynamic>>.from(data['favorites'] ?? []);
          }
        }

        setState(() {
          favorites = loadedFavorites;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
          errorMessage = null;
        });
      }
    } on DioException catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'خطأ في الاتصال بالخادم: ${e.message}';
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'خطأ غير متوقع: $e';
      });
    }
  }

  void onBottomNavItemTapped(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text(
            'المفضلة',
            style: TextStyle(
              color: greenColor,
              fontFamily: 'Almarai',
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back_ios, color: greenColor),
          ),
          actions: [
            IconButton(
              onPressed: _loadFavorites,
              icon: Icon(Icons.refresh, color: greenColor),
            ),
          ],
        ),
        backgroundColor: grayColor,
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: onBottomNavItemTapped,
          selectedItemColor: greenColor,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'الرئيسية'),
            BottomNavigationBarItem(icon: Icon(Icons.inventory_2_outlined), label: 'طلباتي'),
            BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: 'المفضلة'),
            BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'حسابي'),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 16),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              final newFavorite = await Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const AddFavorite()),
                              );
                              if (newFavorite != null && newFavorite is Map<String, dynamic>) {
                                setState(() {
                                  favorites.insert(0, newFavorite);
                                  errorMessage = null;
                                });
                                // ❌ لا داعي لإعادة تحميل القائمة هنا
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: greenColor,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('إضافة وجهة مفضلة'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Expanded(
                        child: isLoading && favorites.isEmpty
                            ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(color: greenColor),
                              const SizedBox(height: 16),
                              const Text('جاري تحميل المفضلة...'),
                            ],
                          ),
                        )
                            : errorMessage != null
                            ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.error_outline, size: 64, color: Colors.red),
                              const SizedBox(height: 16),
                              Text(
                                errorMessage!,
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: Colors.red),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: _loadFavorites,
                                child: const Text('إعادة المحاولة'),
                              ),
                            ],
                          ),
                        )
                            : favorites.isEmpty
                            ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.favorite_border, size: 64, color: Colors.grey),
                              const SizedBox(height: 16),
                              const Text('لا توجد وجهات مفضلة'),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: _loadFavorites,
                                child: const Text('إعادة المحاولة'),
                              ),
                            ],
                          ),
                        )
                            : RefreshIndicator(
                          onRefresh: _loadFavorites,
                          child: ListView.builder(
                            itemCount: favorites.length,
                            itemBuilder: (context, index) {
                              final favorite = favorites[index];
                              final isSelected = selectedIndex == index;
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: _locationTile(
                                  favorite['destination']?.toString() ?? 'وجهة غير محددة',
                                  favorite['address']?.toString() ?? 'عنوان غير محدد',
                                  isSelected,
                                      () {
                                    setState(() {
                                      selectedIndex = index;
                                    });
                                  },
                                ),
                              );
                            },
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
      ),
    );
  }

  Widget _locationTile(String destination, String address, bool isSelected, VoidCallback onSelect) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        border: Border.all(color: greenColor, width: 2),
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(destination, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(address, style: const TextStyle(fontSize: 14, color: Colors.grey)),
              ],
            ),
          ),
          const SizedBox(width: 10),
          ElevatedButton(
            onPressed: onSelect,
            style: ElevatedButton.styleFrom(
              backgroundColor: isSelected ? Colors.grey[300] : Colors.white,
              side: BorderSide(color: greenColor, width: 1),
              foregroundColor: greenColor,
            ),
            child: Text(isSelected ? 'تم الاختيار' : 'اختيار'),
          ),
        ],
      ),
    );
  }
}

