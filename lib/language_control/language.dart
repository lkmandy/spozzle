class Language {
  final int id;
  final String flag;
  final String name;
  final String languageCode;
  const Language(this.id, this.flag, this.name, this.languageCode);

  static List<Language> languageList() {
    return <Language>[
      const Language(0, '🇺🇸', 'English', 'en'),
      const Language(1, '🇫🇷', 'French', 'fr'),
    ];
  }
}
