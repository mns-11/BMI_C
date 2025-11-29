class QuranCollectionModel {
  String name;
  List<int> pages;
  List<int> completedPages;

  QuranCollectionModel({
    required this.name,
    List<int>? pages,
    List<int>? completedPages,
  }) : this.pages = pages ?? [],
       this.completedPages = completedPages ?? [];

  int get totalPages => pages.length;
  int get studiedPages => completedPages.length;

  double get completionPercent {
    if (totalPages == 0) return 0.0;
    return studiedPages / totalPages;
  }
}
