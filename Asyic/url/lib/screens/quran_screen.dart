import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quran/quran.dart' as quran;
import '../../models/quran/quran_page_model.dart';
import '../../models/quran/search_result.dart';
import '../utils/page_helpers.dart';
import 'quran_screen/widgets/besmallah_widget.dart';
import 'quran_screen/widgets/header_corner_wdget.dart';
import 'quran_screen/widgets/page_menu_button.dart';
import 'quran_screen/widgets/page_number_widget.dart';
import 'quran_screen/widgets/surah_alfatiha_widget.dart';
import 'quran_screen/widgets/surah_heading_widget.dart';

class QuranScreen extends StatefulWidget {
  const QuranScreen({super.key});

  @override
  State<QuranScreen> createState() => _QuranScreenState();
}

class _QuranScreenState extends State<QuranScreen> {
  List<SearchResult> searchResults = [];
  OverlayEntry? _overlayEntry;
  bool _showOverLay = false;
  late final TextEditingController searchController;
  late final PageController pageController;

  search(String string) {
    if (string.isEmpty) {
      searchResults.clear();
    } else if (string.contains(' ') && string.length > 3) {
      searchResults.clear();
      // Since searchNew is not available, we'll implement a simple search
      // This is a placeholder implementation
      for (int surahNumber = 1; surahNumber <= 114; surahNumber++) {
        try {
          final surahName = quran.getSurahNameArabic(surahNumber);
          if (surahName.contains(string)) {
            searchResults.add(SearchResult.surahNumber(surahNumber));
          }
        } catch (e) {
          // Continue with next surah
        }
      }
    } else {
      searchResults.clear();
      // Since searchSurahs is not available, we'll implement a simple search
      // This is a placeholder implementation
      for (int surahNumber = 1; surahNumber <= 114; surahNumber++) {
        try {
          final surahName = quran.getSurahNameArabic(surahNumber);
          if (surahName.contains(string)) {
            searchResults.add(SearchResult.surahNumber(surahNumber));
          }
        } catch (e) {
          // Continue with next surah
        }
      }
    }
    if (!_showOverLay && string.isNotEmpty) {
      showOverLay();
      _showOverLay = true;
    } else {
      _overlayEntry?.markNeedsBuild();
    }
    setState(() {});
  }

  showOverLay() {
    _showOverLay = true;
    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Positioned(
          top: 50,
          left: 0,
          right: 0,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: searchResults.length,
            itemBuilder: (context, index) {
              final item = searchResults[index];

              return GestureDetector(
                onTap: () {
                  pageController.animateToPage(
                    item.pageNumber - 1,
                    duration: Duration(milliseconds: 300),
                    curve: Curves.fastEaseInToSlowEaseOut,
                  );
                  hideOverLay();
                },
                child: Card(
                  child: ListTile(
                    title: Text(
                      'سورة : ${quran.getSurahNameArabic(item.surahNumber)}',
                    ),
                    subtitle: Text(
                      // Using a simple verse text since getVerseQCF might not be available
                      'آية ${item.verseNumber}',
                      style: TextStyle(
                        // fontFamily: 'QCF_P${getPageNumber(item.pageNumber)}',
                        fontFamily:
                            'QCF_P${item.pageNumber.toString().padLeft(3, '0')}',
                      ),
                    ),
                    trailing: Text('ص\n${item.pageNumber}'),
                  ),
                ),
              );
            },
          ),
        );
      },
    );

    final overlay = Overlay.of(context);

    overlay.insert(_overlayEntry!);
  }

  hideOverLay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    _showOverLay = false;
  }

  @override
  void initState() {
    searchController = TextEditingController();
    pageController = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    _overlayEntry?.dispose();
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Expanded(
              child: TextField(
                controller: searchController,
                onTapOutside: (event) => searchResults.clear(),
                onChanged: (value) async {
                  hideOverLay();
                  int? number = int.tryParse(value);
                  if (value.removeAllWhitespace == '') {
                    hideOverLay();
                  } else if (number != null && number > 0 && number < 605) {
                    pageController.animateToPage(
                      number - 1,
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOutCubic,
                    );
                  } else if (number == null) {
                    search(value);
                  } else {
                    hideOverLay();
                  }
                },

                style: GoogleFonts.reemKufi(
                  fontSize: Get.textTheme.bodyLarge!.fontSize,
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  alignLabelWithHint: true,
                  counterStyle: GoogleFonts.reemKufi(
                    fontSize: Get.textTheme.headlineSmall!.fontSize,
                    color: Colors.black,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    applyTextScaling: true,
                    color: Colors.white,
                  ),
                  label: Text(
                    'إبـــــحث',
                    style: GoogleFonts.amiri(
                      fontSize: Get.textTheme.headlineSmall!.fontSize,
                      color: Colors.black,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(
                      color: Colors.orange,
                      style: BorderStyle.solid,
                      width: 1,
                    ),
                  ),

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(
                      color: Colors.black12,
                      style: BorderStyle.solid,
                      width: 10,
                    ),
                  ),
                ),
              ),
            ),
            PageMenuButton(),
          ],
        ),
      ),
      body: PageView.builder(
        physics: PageScrollPhysics(),
        itemCount: 604,
        padEnds: true,
        scrollBehavior: MaterialScrollBehavior(),

        controller: pageController,
        itemBuilder: (context, index) {
          // return pages[index];
          return buildPageWidget(index + 1);
        },
        scrollDirection: Axis.horizontal,
      ),
    );
  }

  static Widget? buildPageWidget(int pageNumber) {
    return pageNumber > 604
        ? throw IndexError.withLength(pageNumber, 604)
        : pageNumber < 1
        ? throw IndexError.withLength(pageNumber, 604)
        : FutureBuilder(
            future: QuranPageModel.formPageNumber(pageNumber),

            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!.surahs.first.number == 1) {
                  return SurahAlfatihaWidget(snapshot.data!.surahs.first);
                } else {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        // mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          HeaderCornerWidget(
                            text: 'الجزء ${snapshot.data!.juzuNumber}',
                            width: 150,
                          ),
                          HeaderCornerWidget(
                            text: snapshot.data!.surahs.first.name.arabic,
                            width: 150,
                          ),
                        ],
                      ),
                      ...snapshot.data!.surahs.map((surah) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            if (surah.startVerse == 1)
                              SurahHeadingWidget(surah: surah, fontSize: 25.sp),
                            if (surah.startVerse == 1 && pageNumber != 187)
                              BesmallahWidget(
                                fontSize: PageHelpers.getFontSize(pageNumber),
                              ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15.0,
                              ),
                              child: Text(
                                surah.versesAsString,
                                softWrap: true,
                                textDirection: TextDirection.rtl,
                                textAlign: PageHelpers.isCenter(pageNumber)
                                    ? TextAlign.center
                                    : TextAlign.right,
                                style: TextStyle(
                                  fontSize: PageHelpers.getFontSize(pageNumber),

                                  color: Colors.black,
                                  fontFamily:
                                      'QCF_P${snapshot.data!.pageNumber.toString().padLeft(3, '0')}',
                                  height: 1.3.h,
                                  wordSpacing: 0,
                                  letterSpacing: 0.w,
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                      Spacer(flex: 1),
                      PageNumberWidget(snapshot.data!.pageNumber),
                    ],
                  );
                }
              } else if (snapshot.hasError) {
                return Center(child: Text('Error occur'));
              } else {
                return CircularProgressIndicator.adaptive();
              }
            },
          );
  }
}
