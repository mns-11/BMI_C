class Reciter {
  final String id;
  final String name;
  final String imageUrl;
  final String channelId;
  final String? language;

  const Reciter({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.channelId,
    this.language = 'ar',
  });
}

// List of popular Quran reciters with their YouTube channel IDs
final List<Reciter> quranReciters = [
  Reciter(
    id: 'mishary_rashid_alafasy',
    name: 'مشاري راشد العفاسي',
    imageUrl: 'https://i.ytimg.com/vi/7SQ1qSJ-3UU/maxresdefault.jpg',
    channelId: 'UCddiUEpeqJcYeBx3bgRLh-g',
  ),
  Reciter(
    id: 'abdur_rahman_al_ossi',
    name: 'عبدالرحمن مسعد',
    imageUrl: 'https://i.ytimg.com/vi/7SQ1qSJ-3UU/maxresdefault.jpg',
    channelId: 'UCddiUEpeqJcYeBx3bgRLh-g',
  ),
  Reciter(
    id: 'maher_al_muaiqly',
    name: 'ماهر المعيقلي',
    imageUrl: 'https://i.ytimg.com/vi/7SQ1qSJ-3UU/maxresdefault.jpg',
    channelId: 'UCddiUEpeqJcYeBx3bgRLh-g',
  ),
  Reciter(
    id: 'saad_al_ghamdi',
    name: 'سعد الغامدي',
    imageUrl: 'https://i.ytimg.com/vi/7SQ1qSJ-3UU/maxresdefault.jpg',
    channelId: 'UCddiUEpeqJcYeBx3bgRLh-g',
  ),
  Reciter(
    id: 'muhammad_siddeeq_al_minshawi',
    name: 'محمد صديق المنشاوي',
    imageUrl: 'https://i.ytimg.com/vi/7SQ1qSJ-3UU/maxresdefault.jpg',
    channelId: 'UCddiUEpeqJcYeBx3bgRLh-g',
  ),
];
