class Article {
  Article({
    this.name,
    this.id,
    this.author,
    required this.title,
    required this.description,
    required this.url,
    required this.imageUrl,
    required this.publishedAt,
    this.content,
  });

  String? name;
  String? id;
  String? author;
  final String title;
  final String description;
  final String url;
  final String imageUrl;
  final String publishedAt;
  String? content;
}
