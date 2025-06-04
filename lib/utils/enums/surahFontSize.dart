enum FontSize { small, medium, large }

const Map<FontSize, double> fontMapping = {
  FontSize.small: 20,
  FontSize.medium: 33,
  FontSize.large: 40,
};

const Map<FontSize, double> translationFontMapping = {
  FontSize.small: 15,
  FontSize.medium: 18,
  FontSize.large: 23,
};

const Map<FontSize, String> fontMappingText = {
  FontSize.small: 'Small',
  FontSize.medium: 'Medium',
  FontSize.large: 'Large',
};

const Map<FontSize, double> buttonFontMapping = {
  FontSize.small: 13,
  FontSize.medium: 15,
  FontSize.large: 20,
};

const FontSize defaultFontSize = FontSize.medium;

extension SurahFontSize on FontSize {
  double get size => fontMapping[this] ?? defaultFontSize.size;
}

extension TranslationFontSize on FontSize {
  double get translationSize =>
      translationFontMapping[this] ?? defaultFontSize.translationSize;
}

extension SurahFontSizeText on FontSize {
  String get text => fontMappingText[this] ?? defaultFontSize.text;
}

extension SurahFontButton on FontSize {
  double get btnSize => buttonFontMapping[this] ?? defaultFontSize.btnSize;
}
