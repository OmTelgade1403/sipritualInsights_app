import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/app_providers.dart';
import '../../config/theme.dart';

class BookReaderScreen extends ConsumerStatefulWidget {
  final String bookId;

  const BookReaderScreen({super.key, required this.bookId});

  @override
  ConsumerState<BookReaderScreen> createState() => _BookReaderScreenState();
}

class _BookReaderScreenState extends ConsumerState<BookReaderScreen> {
  double _fontSize = 18.0;
  String? _selectedLanguage;

  @override
  Widget build(BuildContext context) {
    final booksAsync = ref.watch(booksProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF5E6CA), // Parchment background
      appBar: AppBar(
        backgroundColor: const Color(0xFFE8D4B4), // Slightly darker parchment for appbar
        elevation: 2,
        shadowColor: Colors.black26,
        title: booksAsync.when(
          data: (books) {
            final book = books.firstWhere((b) => b.id == widget.bookId);
            return Text(
              book.title,
              style: GoogleFonts.cinzel(fontWeight: FontWeight.w700, color: const Color(0xFF3E2723)),
            );
          },
          loading: () => const Text('Loading...'),
          error: (_, __) => const Text('Error'),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF3E2723)),
        actions: [
          booksAsync.when(
            data: (books) {
              final book = books.firstWhere((b) => b.id == widget.bookId);
              if (book.translations.length <= 1) return const SizedBox.shrink();
              
              return PopupMenuButton<String>(
                icon: const Icon(Icons.language_rounded),
                onSelected: (lang) {
                  setState(() => _selectedLanguage = lang);
                },
                itemBuilder: (context) => book.translations.keys.map((lang) {
                  return PopupMenuItem(
                    value: lang,
                    child: Text(lang, style: GoogleFonts.outfit()),
                  );
                }).toList(),
              );
            },
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
          IconButton(
            icon: const Icon(Icons.text_fields_rounded),
            onPressed: () {
              _showFontSizeDialog();
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const NetworkImage('https://www.transparenttextures.com/patterns/paper-fibers.png'),
            repeat: ImageRepeat.repeat,
            opacity: 0.1,
          ),
        ),
        child: booksAsync.when(
          data: (books) {
            final book = books.firstWhere((b) => b.id == widget.bookId);
            _selectedLanguage ??= book.language;
            
            final displayContent = book.translations[_selectedLanguage] ?? book.content;
            
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   // Ornate corner-like decoration (conceptual)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.auto_awesome, size: 24, color: AppColors.gold.withOpacity(0.5)),
                      Icon(Icons.auto_awesome, size: 24, color: AppColors.gold.withOpacity(0.5)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: Column(
                      children: [
                        Text(
                          book.title,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.cinzel(
                            fontSize: 32,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF2B1B17),
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          height: 2,
                          width: 100,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.transparent, AppColors.gold, Colors.transparent],
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '— ${book.author} —',
                          style: GoogleFonts.ebGaramond(
                            fontSize: 20,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF5D4037),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 48),
                  Text(
                    displayContent,
                    style: GoogleFonts.ebGaramond(
                      fontSize: _fontSize,
                      height: 1.6,
                      color: const Color(0xFF2D1E12),
                    ),
                  ),
                  const SizedBox(height: 40),
                   Center(
                    child: Icon(Icons.park_rounded, size: 32, color: AppColors.gold.withOpacity(0.3)),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, s) => Center(child: Text('Error: $e')),
        ),
      ),
    );
  }

  void _showFontSizeDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Adjust Font Size',
                    style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    children: [
                      const Icon(Icons.text_fields_rounded, size: 20),
                      Expanded(
                        child: Slider(
                          value: _fontSize,
                          min: 14,
                          max: 32,
                          divisions: 18,
                          label: _fontSize.round().toString(),
                          onChanged: (value) {
                            setState(() {
                              _fontSize = value;
                            });
                            setModalState(() {});
                          },
                        ),
                      ),
                      const Icon(Icons.text_fields_rounded, size: 32),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
