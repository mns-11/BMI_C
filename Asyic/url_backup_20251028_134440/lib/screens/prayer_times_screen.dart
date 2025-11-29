import 'dart:async';
import 'package:adhan/adhan.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';

class PrayerTimesScreen extends StatefulWidget {
  const PrayerTimesScreen({super.key});

  @override
  State<PrayerTimesScreen> createState() => _PrayerTimesScreenState();
}

class _PrayerTimesScreenState extends State<PrayerTimesScreen> {
  bool _loading = true;
  String? _fallbackMessage;
  DateTime? _now;
  HijriCalendar? _hijriNow;
  late Map<String, DateTime> _prayerTimes;
  String _locationLabel = 'جارٍ تحديد الموقع...';
  bool _inRamadan = false;
  int _ramadanCountdownDays = 0;

  @override
  void initState() {
    super.initState();
    _prayerTimes = <String, DateTime>{};
    HijriCalendar.setLocal('ar');
    _loadPrayerTimes();
  }

  Future<void> _loadPrayerTimes() async {
    setState(() {
      _loading = true;
      _fallbackMessage = null;
    });

    final DateTime now = DateTime.now();
    Coordinates coordinates;
    String locationLabel = 'الرياض، المملكة العربية السعودية';
    String? fallbackMessage;

    try {
      final Position position = await _determinePosition();
      if (!mounted) {
        return;
      }
      coordinates = Coordinates(position.latitude, position.longitude);

      final List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
        localeIdentifier: 'ar',
      ).timeout(const Duration(seconds: 8));

      if (placemarks.isNotEmpty) {
        final Placemark place = placemarks.first;
        final String locality = (place.locality?.isNotEmpty ?? false)
            ? place.locality!
            : (place.subAdministrativeArea?.isNotEmpty ?? false)
            ? place.subAdministrativeArea!
            : (place.administrativeArea ?? '');
        final String country = (place.country?.isNotEmpty ?? false)
            ? place.country!
            : 'المملكة العربية السعودية';
        locationLabel = <String>[
          locality,
          country,
        ].where((String part) => part.isNotEmpty).join('، ');
      }
    } catch (error) {
      coordinates = Coordinates(24.7136, 46.6753); // Riyadh fallback
      fallbackMessage =
          'لم يتمكّن التطبيق من تحديد موقعك. تم عرض أوقات الرياض افتراضياً.';
    }

    final DateComponents dateComponents = DateComponents.from(now);
    final CalculationParameters params = CalculationMethod.umm_al_qura
        .getParameters();
    params.madhab = Madhab.shafi;

    final PrayerTimes prayerTimes = PrayerTimes(
      coordinates,
      dateComponents,
      params,
    );

    await initializeDateFormatting('ar', null);

    final HijriCalendar hijriNow = HijriCalendar.now();
    final bool inRamadan = hijriNow.hMonth == 9;
    final int ramadanCountdown;
    if (inRamadan) {
      ramadanCountdown = (30 - hijriNow.hDay).clamp(0, 30).toInt();
    } else {
      final int targetYear = hijriNow.hMonth < 9
          ? hijriNow.hYear
          : hijriNow.hYear + 1;
      final DateTime ramadanStart = HijriCalendar().hijriToGregorian(
        targetYear,
        9,
        1,
      );
      final int diff = ramadanStart.difference(now).inDays;
      ramadanCountdown = diff < 0 ? 0 : diff;
    }

    setState(() {
      _now = now;
      _hijriNow = hijriNow;
      _inRamadan = inRamadan;
      _ramadanCountdownDays = ramadanCountdown;
      _locationLabel = locationLabel;
      _fallbackMessage = fallbackMessage;
      _prayerTimes = <String, DateTime>{
        'الفجر': prayerTimes.fajr,
        'الشروق': prayerTimes.sunrise,
        'الظهر': prayerTimes.dhuhr,
        'العصر': prayerTimes.asr,
        'المغرب': prayerTimes.maghrib,
        'العشاء': prayerTimes.isha,
      };
      _loading = false;
    });
  }

  Future<Position> _determinePosition() async {
    final bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('خدمة تحديد الموقع غير مفعّلة.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('تم رفض إذن الموقع.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('إذن الموقع مرفوض بشكل دائم.');
    }

    try {
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );
    } on TimeoutException {
      final Position? lastKnown = await Geolocator.getLastKnownPosition();
      if (lastKnown != null) {
        return lastKnown;
      }
      throw Exception('انتهت مهلة تحديد الموقع.');
    } catch (error) {
      final Position? lastKnown = await Geolocator.getLastKnownPosition();
      if (lastKnown != null) {
        return lastKnown;
      }
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('أوقات الصلاة'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(gradient: AppTheme.appBarGradient),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadPrayerTimes,
              child: ListView(
                padding: const EdgeInsets.all(24),
                children: <Widget>[
                  if (_fallbackMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Text(
                        _fallbackMessage!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.orange.shade700,
                        ),
                      ),
                    ),
                  if (_now != null && _hijriNow != null)
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'الموقع الحالي',
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _locationLabel,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            const Divider(height: 24),
                            Text(
                              'اليوم والتاريخ',
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              DateFormat(
                                'EEEE، d MMMM yyyy',
                                'ar',
                              ).format(_now!),
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${_hijriNow!.hDay} ${_hijriNow!.getLongMonthName()} ${_hijriNow!.hYear} هـ',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'رمضان المبارك',
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              _inRamadan
                                  ? 'متبقي $_ramadanCountdownDays يوم على نهاية شهر رمضان المبارك.'
                                  : 'متبقي $_ramadanCountdownDays يوم على دخول شهر رمضان المبارك.',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ),
                  const SizedBox(height: 16),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'أوقات الصلاة لليوم',
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          const SizedBox(height: 12),
                          ..._prayerTimes.entries.map(
                            (MapEntry<String, DateTime> entry) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    entry.key,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodyLarge,
                                  ),
                                  Text(
                                    DateFormat(
                                      'HH:mm',
                                      'ar',
                                    ).format(entry.value.toLocal()),
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodyLarge,
                                  ),
                                ],
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
    );
  }
}
