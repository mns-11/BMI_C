// import 'package:flutter/material.dart';
// import '../models/bukhari_hadith_model.dart';
// import '../services/bukhari_service.dart';

// class BukhariHadithsScreen extends StatefulWidget {
//   static const routeName = '/bukhari-hadiths';

//   const BukhariHadithsScreen({Key? key}) : super(key: key);

//   @override
//   _BukhariHadithsScreenState createState() => _BukhariHadithsScreenState();
// }

// class _BukhariHadithsScreenState extends State<BukhariHadithsScreen> {
//   late Future<Map<String, List<BukhariHadith>>> _hadithsFuture;
//   final TextEditingController _searchController = TextEditingController();
//   String _searchQuery = '';

//   @override
//   void initState() {
//     super.initState();
//     _hadithsFuture = BukhariService.getHadithsByBook();
//   }

//   @override
//   void dispose() {
//     _searchController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.green[800],
//         title: const Text('صحيح البخاري'),
//         centerTitle: true,
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: TextField(
//               controller: _searchController,
//               decoration: InputDecoration(
//                 hintText: 'ابحث عن حديث...',
//                 prefixIcon: const Icon(Icons.search),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10.0),
//                 ),
//                 filled: true,
//                 fillColor: Colors.grey[200],
//               ),
//               textAlign: TextAlign.right,
//               onChanged: (value) {
//                 setState(() {
//                   _searchQuery = value;
//                 });
//               },
//             ),
//           ),
//           Expanded(
//             child: FutureBuilder<Map<String, List<BukhariHadith>>>(
//               future: _hadithsFuture,
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(child: CircularProgressIndicator());
//                 }

//                 if (snapshot.hasError) {
//                   return Center(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         const Text('حدث خطأ في تحميل الأحاديث'),
//                         const SizedBox(height: 10),
//                         ElevatedButton(
//                           onPressed: () {
//                             setState(() {
//                               _hadithsFuture =
//                                   BukhariService.getHadithsByBook();
//                             });
//                           },
//                           child: const Text('إعادة المحاولة'),
//                         ),
//                       ],
//                     ),
//                   );
//                 }

//                 if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                   return const Center(child: Text('لا توجد أحاديث متاحة'));
//                 }

//                 final books = snapshot.data!;
//                 final filteredBooks = books.map((bookName, hadiths) {
//                   if (_searchQuery.isEmpty) {
//                     return MapEntry(bookName, hadiths);
//                   }
//                   final filtered = hadiths
//                       .where(
//                         (hadith) =>
//                             hadith.arabic.contains(_searchQuery) ||
//                             hadith.reference.contains(_searchQuery),
//                       )
//                       .toList();
//                   return MapEntry(bookName, filtered);
//                 })..removeWhere((key, value) => value.isEmpty);

//                 return ListView.builder(
//                   itemCount: filteredBooks.length,
//                   itemBuilder: (context, index) {
//                     final bookName = filteredBooks.keys.elementAt(index);
//                     final hadiths = filteredBooks[bookName]!;

//                     return ExpansionTile(
//                       title: Text(
//                         bookName,
//                         style: const TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16,
//                         ),
//                         textAlign: TextAlign.right,
//                       ),
//                       children: hadiths
//                           .map((hadith) => _buildHadithItem(hadith))
//                           .toList(),
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildHadithItem(BukhariHadith hadith) {
//     return Card(
//       margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//       child: Padding(
//         padding: const EdgeInsets.all(12.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Text(
//               hadith.arabic,
//               style: const TextStyle(
//                 fontSize: 18,
//                 fontFamily: 'Traditional Arabic',
//                 height: 1.8,
//               ),
//               textAlign: TextAlign.right,
//               textDirection: TextDirection.rtl,
//             ),
//             const SizedBox(height: 8),
//             Text(
//               hadith.reference,
//               style: TextStyle(color: Colors.grey[600], fontSize: 12),
//               textAlign: TextAlign.left,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
