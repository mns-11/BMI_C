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
  String _location = 'جاري التحميل...';
  Map<String, String> _prayerTimes = {};
  DateTime? _currentDate;
  HijriCalendar? _hijriDate;

  @override
  void initState() {
    super.initState();
    _getPrayerTimes();
  }

  Future<void> _getPrayerTimes() async {
    if (mounted) {
      setState(() {
        _loading = true;
        _errorMessage = '';
      });
    }

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
          // Use 'locality' (city) or 'subAdministrativeArea' as fallback, default to Riyadh
          final city =
              place.locality ?? place.subAdministrativeArea ?? 'الرياض';
          final country = place.country ?? 'السعودية';

          await _fetchPrayerTimes(city: city, country: country);
        } else {
          throw Exception('تعذر العثور على الموقع');
        }
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
      // Fallback to Riyadh if there's an error
      if (_prayerTimes.isEmpty) {
        // Prevent showing error screen if fallback loads
        await _loadFallbackPrayerTimes();
      }
    } finally {
      if (mounted && _prayerTimes.isNotEmpty) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  // Helper method to fetch prayer times from Aladhan API
  Future<void> _fetchPrayerTimes({
    String city = 'الرياض',
    String country = 'السعودية',
  }) async {
    try {
      final response = await http
          .get(
            Uri.parse(
              'https://api.aladhan.com/v1/timingsByCity?city=$city&country=$country&method=4',
            ),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        // Decode response to handle Arabic characters correctly
        final data = json.decode(utf8.decode(response.bodyBytes));
        final timings = data['data']['timings'];

        if (mounted) {
          setState(() {
            _location = '$city, $country';
            _prayerTimes = {
              'الفجر': timings['Fajr'],
              'الشروق': timings['Sunrise'],
              'الظهر': timings['Dhuhr'],
              'العصر': timings['Asr'],
              'المغرب': timings['Maghrib'],
              'العشاء': timings['Isha'],
            };
            _currentDate = DateTime.parse(data['data']['date']['readable']);
            // Check if _currentDate is not null before using it
            if (_currentDate != null) {
              _hijriDate = HijriCalendar.fromDate(_currentDate!);
            } else {
              _hijriDate = HijriCalendar.now();
            }
            _loading = false;
            _errorMessage = ''; // Clear error message on successful load
          });
        }
      } else {
        throw Exception(
          'فشل في تحميل أوقات الصلاة (الرمز ${response.statusCode})',
        );
      }
    } catch (e) {
      // Re-throw exception to be caught by _getPrayerTimes for error handling
      throw Exception('تعذر الاتصال بخادم أوقات الصلاة');
    }
  }

  // Fallback to Riyadh if location fails
  Future<void> _loadFallbackPrayerTimes() async {
    try {
      await _fetchPrayerTimes(city: 'الرياض', country: 'السعودية');
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage =
              'حدث خطأ في تحميل الأوقات الافتراضية: ${e.toString()}';
          _loading = false;
        });
      }
    }
  }

  // Determine user's current position
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Prompt user to enable location services
      throw Exception('خدمة الموقع غير مفعلة');
    }

    // Check location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('تم رفض إذن الموقع');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception(
        'تم رفض إذن الموقع بشكل دائم. يرجى تفعيله من إعدادات التطبيق',
      );
    }

    // Get current position with timeout
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    ).timeout(
      const Duration(seconds: 10),
      onTimeout: () => throw TimeoutException('انتهت مهلة تحديد الموقع'),
    );
  }

  // Get icon for each prayer time
  Widget _getPrayerIcon(String prayerName) {
    switch (prayerName) {
      case 'الفجر':
        return const Icon(Icons.nights_stay, color: Colors.blue);
      case 'الشروق':
        return const Icon(Icons.wb_sunny, color: Colors.orange);
      case 'الظهر':
        return const Icon(Icons.wb_sunny_outlined, color: Colors.amber);
      case 'العصر':
        return const Icon(Icons.brightness_5, color: Colors.deepOrange);
      case 'المغرب':
        return const Icon(Icons.nightlight_round, color: Colors.purple);
      case 'العشاء':
        return const Icon(Icons.nightlight_outlined, color: Colors.indigo);
      default:
        return const Icon(Icons.access_time, color: Color(0xFF1A4D2E));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      // Using Flutter's TextDirection for RTL
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
            : _errorMessage.isNotEmpty &&
                  _prayerTimes
                      .isEmpty // Show error screen only if no data loaded (initial error)
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
                            const SizedBox(height: 12),
                            Text(
                              _location,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            if (_currentDate != null) ...[
                              Text(
                                // Use 'ar' locale for correct Arabic formatting
                                intl.DateFormat(
                                  'EEEE, d MMMM y',
                                  'ar',
                                ).format(_currentDate!),
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black54,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _hijriDate?.toFormat('dd MMMM yyyy') ?? '',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF1A4D2E),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
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
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          leading: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1A4D2E).withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: _getPrayerIcon(entry.key),
                          ),
                          title: Text(
                            entry.key,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          trailing: Text(
                            entry.value,
                            style: const TextStyle(
                              fontSize: 18,
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
