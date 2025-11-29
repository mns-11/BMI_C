import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:http/http.dart' as http;
import 'package:intl/date_symbol_data_local.dart';
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
  void initState() {
    super.initState();
    // Initialize date formatting for Arabic locale
    initializeDateFormatting('ar_SA', null).then((_) {
      if (mounted) {
        _getPrayerTimes();
      }
    });
  }

  @override
  void dispose() {
    _positionStreamSubscription?.cancel();
    super.dispose();
  }

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

    setState(() {
      _loading = true;
      _errorMessage = '';
    });

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (mounted) {
        setState(() {
          _errorMessage = 'تفعيل خدمة الموقع لتحديد موقعك الحالي';
          _loading = false;
        });
      }
      return Future.error('Location services are disabled');
    }

    // Check location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (mounted) {
          setState(() {
            _errorMessage = 'يجب منح إذن الوصول للموقع';
            _loading = false;
          });
        }
        return Future.error('Location permissions are denied');
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      if (mounted) {
        setState(() {
          _errorMessage = 'تم رفض إذن الموقع بشكل دائم. يرجى تمكينه من إعدادات التطبيق';
          _loading = false;
        });
      }
      return Future.error('Location permissions are permanently denied');
    }

    // Get current position with better accuracy
    try {
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'تعذر تحديد الموقع. جارٍ استخدام الموقع الافتراضي';
          _loading = false;
        });
      }
      return Future.error(e.toString());
    }
  }

  // Get location name in Arabic
  Future<String> _getLocationName(double lat, double lng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        // Try to get the most specific location name available
        String city = place.locality ?? place.subAdministrativeArea ?? '';
        String country = place.country ?? '';
        
        // If we couldn't get city, try to get any available location info
        if (city.isEmpty) {
          city = place.administrativeArea ?? place.subLocality ?? place.thoroughfare ?? '';
        }
        
        if (city.isNotEmpty && country.isNotEmpty) {
          return '$city، $country';
        } else if (city.isNotEmpty) {
          return city;
        } else if (country.isNotEmpty) {
          return country;
        }
      }
      return 'موقع غير معروف';
    } catch (e) {
      debugPrint('Error getting location name: $e');
      return 'موقع غير معروف';
    }
  }

  Future<void> _loadFallbackPrayerTimes() async {
    try {
      await _fetchPrayerTimes(
        city: 'الرياض', 
        country: 'السعودية',
        displayLocation: 'الرياض، السعودية',
      );
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'تعذر تحميل أوقات الصلاة. يرجى المحاولة لاحقاً.';
          _loading = false;
        });
      }
    }
  }

  Future<void> _getPrayerTimes() async {
    if (!mounted) return;

    setState(() {
      _loading = true;
      _errorMessage = 'جاري تحديث الموقع وأوقات الصلاة...';
    });

    try {
      // Get current position
      Position position = await _determinePosition();
      
      // Get location name in Arabic
      final locationName = await _getLocationName(position.latitude, position.longitude);
      
      // Get place details for city and country
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      ).timeout(const Duration(seconds: 5));

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        final city = place.locality ?? place.subAdministrativeArea ?? 'الرياض';
        final country = place.country ?? 'السعودية';
        
        // Update location name with more specific details if available
        final displayLocation = locationName == 'موقع غير معروف' 
            ? '$city، $country' 
            : locationName;
            
        await _fetchPrayerTimes(
          city: city, 
          country: country,
          displayLocation: displayLocation,
        );
      } else {
        // If we can't get place details, still try with the coordinates
        await _fetchPrayerTimes(
          lat: position.latitude,
          lng: position.longitude,
          displayLocation: locationName,
        );
      }
    } on TimeoutException {
      if (mounted) {
        setState(() {
          _errorMessage = 'انتهت مهلة تحديد الموقع. جارٍ استخدام آخر موقع معروف';
          _loading = false;
        });
      }
      await _loadFallbackPrayerTimes();
    } catch (e) {
      debugPrint('Error getting prayer times: $e');
      if (mounted) {
        setState(() {
          _errorMessage = 'سيتم استخدام مدينة الرياض كموقع افتراضي';
          _loading = false;
        });
      }
      await _loadFallbackPrayerTimes();
    }
  }

  Future<void> _fetchPrayerTimes({
    String? city,
    String? country,
    double? lat,
    double? lng,
    String displayLocation = 'الرياض، السعودية',
  }) async {
    try {
      setState(() {
        _loading = true;
        _errorMessage = '';
      });

      // Build the API URL based on available parameters
      final String apiUrl;
      if (lat != null && lng != null) {
        // Use coordinates if available
        apiUrl = 'https://api.aladhan.com/v1/timings?latitude=$lat&longitude=$lng&method=4';
      } else if (city != null && country != null) {
        // Fall back to city/country if coordinates not available
        final encodedCity = Uri.encodeComponent(city);
        final encodedCountry = Uri.encodeComponent(country);
        apiUrl = 'https://api.aladhan.com/v1/timingsByCity?city=$encodedCity&country=$encodedCountry&method=4';
      } else {
        // Default to Riyadh if no location data is available
        apiUrl = 'https://api.aladhan.com/v1/timingsByCity?city=الرياض&country=السعودية&method=4';
      }

      final response = await http
          .get(Uri.parse(apiUrl))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final data = json.decode(responseBody);
        
        if (data != null && data['data'] != null && data['data']['timings'] != null) {
          final timings = data['data']['timings'];
          
          // Safely parse the date
          DateTime? parsedDate;
          try {
            final dateStr = data['data']['date']['readable'];
            if (dateStr != null) {
              parsedDate = DateTime.tryParse(dateStr);
            }
          } catch (e) {
            debugPrint('Error parsing date: $e');
          }

          if (mounted) {
            setState(() {
              _prayerTimes = {
                'الفجر': timings['Fajr']?.toString() ?? '--:--',
                'الشروق': timings['Sunrise']?.toString() ?? '--:--',
                'الظهر': timings['Dhuhr']?.toString() ?? '--:--',
                'العصر': timings['Asr']?.toString() ?? '--:--',
                'المغرب': timings['Maghrib']?.toString() ?? '--:--',
                'العشاء': timings['Isha']?.toString() ?? '--:--',
              };
              
              _currentDate = parsedDate ?? DateTime.now();
              _hijriDate = HijriCalendar.fromDate(_currentDate!);
              _location = displayLocation;
              _loading = false;
            });
          }
        } else {
          throw Exception('بيانات غير صالحة من الخادم');
        }
      } else {
        throw Exception('فشل في تحميل أوقات الصلاة (${response.statusCode}): ${response.body}');
      }
    } on TimeoutException {
      if (mounted) {
        setState(() {
          _errorMessage = 'انتهت مهلة الاتصال بالخادم';
          _loading = false;
        });
      }
    } on SocketException {
      if (mounted) {
        setState(() {
          _errorMessage = 'لا يوجد اتصال بالإنترنت';
          _loading = false;
        });
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
                            const SizedBox(height: 12),
                            Text(
                              _location ?? 'الموقع غير معروف',
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
                                intl.DateFormat(
                                  'EEEE, d MMMM y',
                                  'ar_SA',
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
