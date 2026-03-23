class BookModel {
  final String id;
  final String title;
  final String author;
  final String content; // Default content
  final String category;
  final String deity;
  final String language;
  final Map<String, String> translations;
  final String? description;
  final String? coverImageUrl;

  BookModel({
    required this.id,
    required this.title,
    required this.author,
    required this.content,
    required this.category,
    required this.deity,
    required this.language,
    required this.translations,
    this.description,
    this.coverImageUrl,
  });

  factory BookModel.fromMap(Map<String, dynamic> map, String id) {
    return BookModel(
      id: id,
      title: map['title'] ?? '',
      author: map['author'] ?? '',
      content: map['content'] ?? '',
      category: map['category'] ?? '',
      deity: map['deity'] ?? '',
      language: map['language'] ?? 'Hindi',
      translations: Map<String, String>.from(map['translations'] ?? {}),
      description: map['description'],
      coverImageUrl: map['coverImageUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'author': author,
      'content': content,
      'category': category,
      'deity': deity,
      'language': language,
      'translations': translations,
      'description': description,
      'coverImageUrl': coverImageUrl,
    };
  }
}
