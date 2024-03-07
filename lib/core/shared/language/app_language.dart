enum LANG { en, vi }

class AppLanguage {
  AppLanguage._();

  static LANG lang = LANG.en;

  static String getLanguage() {
    switch (lang) {
      case LANG.en:
        return 'en';
      case LANG.vi:
        return 'vi';
    }
  }
}
