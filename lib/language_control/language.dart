class Language {
  final int id;
  final String flag;
  final String name;
  final String languageCode;
  const Language(this.id, this.flag, this.name, this.languageCode);

  static List<Language> languageList() {
    return <Language>[
      const Language(0, 'πΊπΈ', 'English', 'en'),
      const Language(1, 'π«π·', 'French', 'fr'),
    ];
  }
}
