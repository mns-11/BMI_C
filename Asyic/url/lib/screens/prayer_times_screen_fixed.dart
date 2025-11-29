import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart' as intl;

class PrayerTimesScreen extends StatefulWidget {
  const PrayerTimesScreen({super.key});

  @override
  _PrayerTimesScreenState createState() => _PrayerTimesScreenState();
}

class _PrayerTimesScreenState extends State<PrayerTimesScreen> {
  bool _loading = true;
  String _errorMessage = '';
  Map<String, String> _prayerTimes = {};
  DateTime? _currentDate;
  HijriCalendar? _hijriDate;
  String? _location;
  StreamSubscription<Position>? _positionStreamSubscription;

  @override
  void dispose() {
    _positionStreamSubscription?.cancel();
    super.dispose();
  }

  // Returns the appropriate icon for each prayer
  Widget _getPrayerIcon(String prayerName) {
    switch (prayerName) {
      case 'الفجر':
        return const Icon(Icons.nightlight_outlined, color: Colors.blue);
      case 'الشروق':
        return const Icon(Icons.wb_sunny, color: Colors.orange);
      case 'الظهر':
        return const Icon(Icons.wb_sunny, color: Colors.amber);
      case 'العصر':
        return const Icon(Icons.brightness_4, color: Colors.deepOrange);
      case 'المغرب':
        return const Icon(Icons.nightlight_round, color: Colors.purple);
      case 'العشاء':
        return const Icon(Icons.nightlight_outlined, color: Colors.indigo);
      default:
        return const Icon(Icons.access_time, color: Color(0xFF1A4D2E));
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<void> _getPrayerTimes() async {
    if (!mounted) return;
    
    setState(() {
      _loading = true;
      _errorMessage = '';
    });

    try {
      // Try to get current position
      Position position;
      try {
        position = await _determinePosition();
        
        // Get city and country from coordinates
        List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        ).timeout(const Duration(seconds: 5));

        if (placemarks.isNotEmpty) {
          final place = placemarks.first;
          final city = place.locality ?? place.subAdministrativeArea ?? 'الرياض';
          final country = place.country ?? 'السعودية';
          await _fetchPrayerTimes(city: city, country: country);
        } else {
          throw Exception('تعذر العثور على الموقع');
        }
      } on TimeoutException {
        if (mounted) {
          setState(() {
            _errorMessage = 'انتهت مهلة تحديد الموقع';
            _loading = false;
          });
        }
        await _loadFallbackPrayerTimes();
      } catch (e) {
        // If location fails, use Riyadh as fallback
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('سيتم استخدام مدينة الرياض كموقع افتراضي'),
              duration: Duration(seconds: 3),
            ),
          );
        }
        await _loadFallbackPrayerTimes();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'حدث خطأ: ${e.toString()}';
          _loading = false;
        });
      }
    }
  }

  Future<void> _fetchPrayerTimes({String city = 'الرياض', String country = 'السعودية'}) async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://api.aladhan.com/v1/timingsByCity?city=$city&country=$country&method=4',
        ),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        final timings = data['data']['timings'];

        if (mounted) {
          setState(() {
            _prayerTimes = {
              'الفجر': timings['Fajr'],
              'الشروق': timings['Sunrise'],
              'الظهر': timings['Dhuhr'],
              'العصر': timings['Asr'],
              'المغرب': timings['Maghrib'],
              'العشاء': timings['Isha'],
            };
            _currentDate = DateTime.parse(data['data']['date']['readable']);
            _hijriDate = HijriCalendar.fromDate(_currentDate!);
            _loading = false;
          });
        }
      } else {
        throw Exception('فشل في تحميل أوقات الصلاة');
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'حدث خطأ في جلب البيانات';
          _loading = false;
        });
      }
    }
  }

  Future<void> _loadFallbackPrayerTimes() async {
    await _fetchPrayerTimes();
  }

  @override
  void initState() {
    super.initState();
    _getPrayerTimes();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'أوقات الصلاة',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: const Color(0xFF1A4D2E),
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh, color: Colors.white),
              onPressed: _loading ? null : _getPrayerTimes,
              tooltip: 'تحديث',
            ),
          ],
        ),
        body: _loading
            ? const Center(child: CircularProgressIndicator())
            : _errorMessage.isNotEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            color: Colors.red,
                            size: 48,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _errorMessage,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: _getPrayerTimes,
                            icon: const Icon(Icons.refresh),
                            label: const Text('إعادة المحاولة'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1A4D2E),
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Location and date card
                        Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  color: Color(0xFF1A4D2E),
                                  size: 36,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  _location ?? 'الموقع غير معروف',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '${_hijriDate?.toFormat('dd MMMM yyyy') ?? ''} هـ',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                ),
                                Text(
                                  _currentDate != null
                                      ? intl.DateFormat('dd MMMM yyyy', 'ar').format(_currentDate!)
                                      : '',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        // Prayer times list
                        ..._prayerTimes.entries.map((entry) {
                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListTile(
                              leading: _getPrayerIcon(entry.key),
                              title: Text(
                                entry.key,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              trailing: Text(
                                entry.value,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF1A4D2E),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  ),
      ),
    );
  }
}
