// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appTitle => 'Qareeb';

  @override
  String get homeTitle => 'Qareeb Ana Sayfası';

  @override
  String get skip => 'Atlamak';

  @override
  String get next => 'Sonraki';

  @override
  String get getStarted => 'Başlayın';

  @override
  String get onboardingSlide1Title => 'Yolculuğunuza Kur\'an\'la Başlayın';

  @override
  String get onboardingSlide1Description =>
      'Niyetinizi belirleyin ve günlük okuma alışkanlığını geliştirin; her seferinde bir adım atarak Allah\'a daha da yaklaşın.';

  @override
  String get onboardingSlide2Title => 'Her Ayeti Anlayın';

  @override
  String get onboardingSlide2Description =>
      'Her ayetin kalbinize ve zihninize hitap etmesi için açık anlamları ve tefsirleri keşfedin.';

  @override
  String get onboardingSlide3Title => 'Bağlı Kalın, Yakın Kalın';

  @override
  String get onboardingSlide3Description =>
      'Hatırlatmalar, ilerleme ve nazik teşvik; yolda sebat etmenize yardımcı oluyoruz.';

  @override
  String get languageEnglish => 'İngilizce';

  @override
  String get languageArabic => 'Arapça';

  @override
  String get languageTurkish => 'Türkçe';

  @override
  String get quranSyncTitle => 'Kur\'an-ı Kerim\'in Hazırlanması';

  @override
  String get quranSyncDescription =>
      'Çevrimdışı okumak için sureler ve ayetler indiriliyor. Bu birkaç dakika sürebilir.';

  @override
  String quranSyncProgressPercent(int percent) {
    return '%$percent';
  }

  @override
  String get quranSyncRetry => 'Yeniden dene';

  @override
  String get quranSyncConnectionErrorTitle => 'Bağlantınızı kontrol edin';

  @override
  String get quranSyncConnectionErrorMessage =>
      'Kuran indirilemedi. Lütfen internet bağlantınızı kontrol edip tekrar deneyin.';

  @override
  String get surahListError => 'Sureler yüklenemedi';

  @override
  String get surahListTitle => 'Sureler';

  @override
  String get surahListSearchHint => 'Sureleri isme veya numaraya göre arayın…';

  @override
  String get surahListSearchTooltip => 'Sureleri ara';

  @override
  String get surahListNoResults => 'Aramanızla eşleşen sure yok.';

  @override
  String get surahRevelationMakki => 'Makki';

  @override
  String get surahRevelationMadani => 'Medeni';

  @override
  String readProgressLabel(int read, int total) {
    return '$read/$total okuma';
  }

  @override
  String get markSurahAsRead => 'Sureyi okundu olarak işaretle';

  @override
  String get readAyahHint =>
      'Okundu olarak işaretlemek için bir ayete uzun basın. Sesi çalmak için bir ayete iki kez dokunun.';

  @override
  String mushafPageNumber(int page) {
    return 'Sayfa $page';
  }

  @override
  String get goToFlaggedAyah => 'İşaretli ayete git';

  @override
  String ayahInsightAyahLabel(int number) {
    return 'Ayah $number';
  }

  @override
  String get ayahInsightMeaning => 'Anlam';

  @override
  String get ayahInsightError => 'Ayah anlamı yüklenemedi';

  @override
  String get ayahInsightPlayAudio => 'Ayah sesini çal';

  @override
  String get ayahInsightStory => 'Hikaye';

  @override
  String get ayahInsightStoryLoading => 'Hikaye yükleniyor...';

  @override
  String get ayahInsightStoryAiHint =>
      'Vahyin sebebini, nasıl indiğini ve ayetteki mucizeyi kapsayan açıklama.';

  @override
  String get ayahInsightStoryRevelationReason => 'Vahiy nedeni';

  @override
  String get ayahInsightStoryHowRevealed => 'Peygamber\'e nasıl indiği';

  @override
  String get ayahInsightStoryMiracle => 'Ayette geçen mucize';

  @override
  String get ayahInsightStoryError => 'Ayah hikayesi yüklenemedi';

  @override
  String get ayahCountLabel => 'ayetler';

  @override
  String get playSurah => 'Sureyi çal';

  @override
  String get pauseAudio => 'Duraklat';

  @override
  String get stopAudio => 'Durmak';

  @override
  String audioAyahProgress(int current, int total) {
    return '$total ayetinin $current ayeti';
  }

  @override
  String get previousAyah => 'Önceki ayet';

  @override
  String get nextAyah => 'Sonraki ayet';

  @override
  String get dismiss => 'Azletmek';

  @override
  String get drawerAdhan => 'Ezan';

  @override
  String get drawerSurahs => 'Sureler';

  @override
  String get drawerJuz => 'Cüz';

  @override
  String get juzListTitle => 'Cüz';

  @override
  String juzSurahCountLabel(int count) {
    return '$count sureler';
  }

  @override
  String get drawerSettings => 'Ayarlar';

  @override
  String get drawerQibla => 'Kıble';

  @override
  String get drawerNearbyMosques => 'Yakındaki Camiler';

  @override
  String get drawerNearbyMosquesLaunchError => 'Haritalar açılamadı.';

  @override
  String get nearbyMosquesTitle => 'Yakındaki Camiler';

  @override
  String get nearbyMosquesLoading => 'Yakındaki camileri bulma…';

  @override
  String get nearbyMosquesError => 'Yakındaki camiler yüklenemedi.';

  @override
  String get nearbyMosquesRetry => 'Yeniden dene';

  @override
  String get nearbyMosquesEmpty => 'Yakınlarda cami bulunamadı.';

  @override
  String nearbyMosquesDistanceMeters(int meters) {
    return '$meters m uzakta';
  }

  @override
  String nearbyMosquesDistanceKm(String kilometers) {
    return '$kilometers km uzakta';
  }

  @override
  String nearbyMosquesRouteTo(String mosque) {
    return 'Route to $mosque';
  }

  @override
  String get nearbyMosquesRouteHint =>
      'Follow the blue route line on the map to reach the mosque.';

  @override
  String get nearbyMosquesRouteFallbackHint =>
      'Showing direct path. Turn-by-turn route is currently unavailable.';

  @override
  String get nearbyMosquesRouteDurationUnknown => 'ETA unavailable';

  @override
  String nearbyMosquesRouteDurationMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String get drawerAsmaUlHusna => 'Allah\'ın 99 İsmi';

  @override
  String get drawerSelectReciter => 'Kuran okuyucusu';

  @override
  String get drawerRecitersLoadError =>
      'Okuyucular yüklenemedi. Bağlantınızı kontrol edip tekrar deneyin.';

  @override
  String get asmaUlHusnaTitle => 'Allah\'ın 99 İsmi';

  @override
  String get asmaUlHusnaSearchHint => 'Ada veya anlama göre arayın…';

  @override
  String get asmaUlHusnaError => 'Allah\'ın isimleri yüklenemedi.';

  @override
  String get asmaUlHusnaNoResults => 'Aramanızla eşleşen ad yok.';

  @override
  String get asmaUlHusnaMeaningLabel => 'Anlam';

  @override
  String asmaUlHusnaNameNumber(int number) {
    return 'Ad $number / 99';
  }

  @override
  String get drawerDuaa => 'dua';

  @override
  String get drawerHadith => 'Hadis';

  @override
  String get drawerTagline => 'Kur\'an ve ibadet arkadaşınız';

  @override
  String get drawerSectionQuran => 'Kuran';

  @override
  String get drawerSectionWorship => 'Tapmak';

  @override
  String get drawerSectionKnowledge => 'Bilgi';

  @override
  String get hadithTitle => 'Hadis';

  @override
  String get hadithSearchHint => 'Tüm koleksiyonları arayın…';

  @override
  String get hadithSectionsTitle => 'Bölümler';

  @override
  String get hadithBooksTitle => 'Kitaplar';

  @override
  String get hadithFilterCategoryHint => 'Bu bölümde filtreleyin…';

  @override
  String get hadithSearchCollectionHint => 'Bu koleksiyonda arayın…';

  @override
  String get hadithError =>
      'Hadis yüklenemedi. Bağlantınızı kontrol edip tekrar deneyin.';

  @override
  String get hadithNoResults => 'Aramanızla eşleşen sonuç yok.';

  @override
  String hadithCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hadis',
      one: '1 hadis',
    );
    return '$_temp0';
  }

  @override
  String hadithNumberLabel(int number) {
    return 'Hadis $number';
  }

  @override
  String get hadithSourceLabel => 'Kaynak';

  @override
  String hadithSourceReference(String collection, int number) {
    return '$collection, $number';
  }

  @override
  String get hadithOpenDetailHint => 'Açık hadis';

  @override
  String get duaaTitle => 'dua';

  @override
  String get duaaSearchCategoriesHint => 'Kategorileri ara…';

  @override
  String get duaaSearchDuasHint => 'Duaları ara…';

  @override
  String get duaaError =>
      'Dualar yüklenemedi. Bağlantınızı kontrol edip tekrar deneyin.';

  @override
  String get duaaNoResults => 'Aramanızla eşleşen sonuç yok.';

  @override
  String duaaCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dua',
      one: '1 dua',
    );
    return '$_temp0';
  }

  @override
  String get duaaSourceLabel => 'Kaynak';

  @override
  String duaaRepeatLabel(int count) {
    return '$count kez tekrarla';
  }

  @override
  String get qiblaTitle => 'Kıble';

  @override
  String get qiblaDescription => 'Namazın yönü Kabe\'ye doğrudur.';

  @override
  String get qiblaLoading => 'Yönünüzü bulmak…';

  @override
  String get qiblaError => 'Kıble yönü belirlenemedi.';

  @override
  String get qiblaNoCompass => 'Cihazınızda pusula sensörü bulunmamaktadır.';

  @override
  String get qiblaCompassPluginUnavailable =>
      'Canlı pusula henüz hazır değil. Uygulamayı tamamen durdurun, ardından IDE\'nizden veya terminalinizden tekrar çalıştırın (pusula desteği eklendikten sonra sıcak yeniden yükleme yeterli değildir).';

  @override
  String get qiblaStaticDirectionHint =>
      'Ok kuzeyden kıble yönünü gösterir. Canlı rehberlik için pusulalı bir telefon kullanın.';

  @override
  String qiblaBearing(String degrees) {
    return '$degrees° kuzeyden';
  }

  @override
  String get qiblaAligned => 'Kıbleye dönüksün';

  @override
  String qiblaOffset(String degrees) {
    return 'Kıble\'den $degrees°';
  }

  @override
  String qiblaDirection(String direction) {
    return 'Yön: $direction';
  }

  @override
  String qiblaDistance(String distance) {
    return 'Mekke\'ye $distance km';
  }

  @override
  String get qiblaHint =>
      'Telefonunuzu düz tutun ve ok yukarıyı gösterene kadar döndürün.';

  @override
  String get compassNorth => 'Kuzey';

  @override
  String get compassNortheast => 'Kuzeydoğu';

  @override
  String get compassEast => 'Doğu';

  @override
  String get compassSoutheast => 'Güneydoğu';

  @override
  String get compassSouth => 'Güney';

  @override
  String get compassSouthwest => 'Güneybatı';

  @override
  String get compassWest => 'Batı';

  @override
  String get compassNorthwest => 'Kuzeybatı';

  @override
  String get adhanTitle => 'Ezan';

  @override
  String get adhanLoading => 'Namaz vakitleri yükleniyor…';

  @override
  String get adhanError => 'Namaz vakitleri yüklenemedi.';

  @override
  String get adhanRetry => 'Yeniden dene';

  @override
  String get adhanOpenSettings => 'Ayarları aç';

  @override
  String get adhanLocationDenied =>
      'Bulunduğunuz şehrin namaz vakitlerini göstermek için konum izni gereklidir.';

  @override
  String get adhanLocationUnavailable =>
      'Konum hizmetleri devre dışı. Şehriniz için namaz vakitlerini göstermelerini sağlayın.';

  @override
  String get adhanLocationPluginUnavailable =>
      'Konum henüz hazır değil. Uygulamayı tamamen durdurun, ardından IDE\'nizden veya terminalinizden tekrar çalıştırın (konum desteği eklendikten sonra çalışırken yeniden yükleme yeterli değildir).';

  @override
  String get adhanLocationTimeout =>
      'Konumunuz zamanında tespit edilemedi. Açık bir alana gidin, GPS\'i etkinleştirin veya emülatörde sahte bir konum ayarlayıp tekrar deneyin.';

  @override
  String get adhanToday => 'Bugün';

  @override
  String get adhanChangeCity => 'Değiştirmek';

  @override
  String get adhanSearchCityTitle => 'Şehir ara';

  @override
  String get adhanSearchCityHint => 'Şehir veya şehir, ülke';

  @override
  String get adhanSearchCityEmpty =>
      'Hiçbir şehir bulunamadı. Farklı bir ad deneyin.';

  @override
  String get adhanUseMyLocation => 'Mevcut konumumu kullan';

  @override
  String get prayerFajr => 'Sabah';

  @override
  String get prayerSunrise => 'Gündoğumu';

  @override
  String get prayerDhuhr => 'Öğle yemeği';

  @override
  String get prayerAsr => 'İkindi';

  @override
  String get prayerMaghrib => 'Akşam';

  @override
  String get prayerIsha => 'Yatsı';

  @override
  String adhanAlertSettingsTitle(String prayer) {
    return '$prayer hatırlatıcı';
  }

  @override
  String get adhanAlertTimingSection => 'Ne zaman bildirimde bulunulmalı?';

  @override
  String get adhanAlertOff => 'Kapalı';

  @override
  String get adhanAlertBefore => 'Önce';

  @override
  String get adhanAlertAtAdhan => 'ezanda';

  @override
  String get adhanAlertAfter => 'Sonrasında';

  @override
  String get adhanAlertMinutesSection => 'Ne kadardır';

  @override
  String adhanAlertMinutesLabel(int minutes) {
    return '$minutes dk.';
  }

  @override
  String adhanAlertMaxBeforeHint(int minutes, String prayer) {
    return '$prayer saatinden $minutes dakika öncesine kadar (önceki namazdan önce değil)';
  }

  @override
  String adhanAlertMaxAfterHint(int minutes, String prayer) {
    return '$prayer saatinden $minutes dakikaya kadar (bir sonraki namazdan sonra değil)';
  }

  @override
  String get adhanAlertDeliverySection => 'Uyarı stili';

  @override
  String get adhanAlertSound => 'Ses';

  @override
  String get adhanAlertVibrate => 'Titreşim';

  @override
  String get adhanAlertSave => 'Kaydetmek';

  @override
  String adhanNotificationTitle(String prayer) {
    return '$prayer';
  }

  @override
  String adhanNotificationBodyBefore(int minutes, String prayer) {
    return '$prayer saatine $minutes dakika kaldı';
  }

  @override
  String adhanNotificationBodyAt(String prayer) {
    return '$prayer zamanı geldi';
  }

  @override
  String adhanNotificationBodyAfter(int minutes, String prayer) {
    return '$prayer tarihinden itibaren $minutes dakika';
  }

  @override
  String get adhanNotificationPermissionDenied =>
      'Namaz hatırlatmaları için bildirim izni gerekmektedir.';

  @override
  String get settingsTitle => 'Ayarlar';

  @override
  String get settingsLanguageSection => 'Dil';

  @override
  String get settingsThemeSection => 'Dış görünüş';

  @override
  String get settingsThemeLight => 'Işık';

  @override
  String get settingsThemeDark => 'Karanlık';

  @override
  String get settingsDarkMode => 'Karanlık mod';

  @override
  String get settingsSelectLanguage => 'Dil seçin';

  @override
  String get settingsFontSizeSection => 'Metin boyutu';

  @override
  String get settingsFontSize => 'Yazı tipi boyutu';

  @override
  String settingsFontSizeValue(int percent) {
    return '%$percent';
  }

  @override
  String get settingsNotificationsSection => 'Bildirimler';

  @override
  String get settingsNotificationsEnabled => 'Bildirimleri etkinleştir';

  @override
  String get settingsContactSection => 'Destek';

  @override
  String get settingsReportBug => 'Hata bildir';

  @override
  String get settingsReportBugDescription =>
      'Sorunu açıklayın ve ekranı işaretleyin. Raporunuz ekibimize iletilir.';

  @override
  String get settingsReportBugSuccess =>
      'Teşekkür ederiz — raporunuz gönderildi.';

  @override
  String get settingsReportBugError =>
      'Raporunuz gönderilemedi. Lütfen tekrar deneyin.';

  @override
  String get settingsReportBugEmptyMessage =>
      'Lütfen göndermeden önce sorunu açıklayın.';

  @override
  String get settingsContactUs => 'Bize Ulaşın';

  @override
  String get settingsContactUsError => 'İletişim sayfası açılamadı';

  @override
  String get settingsStorageSection => 'Depolamak';

  @override
  String get settingsClearCache => 'Ses önbelleğini temizle';

  @override
  String get settingsClearCacheDescription =>
      'İndirilen okuma sesini kaldırın. Oynattığınızda dosyalar tekrar indirilecektir.';

  @override
  String get settingsClearCacheConfirmTitle => 'Ses önbelleği temizlensin mi?';

  @override
  String get settingsClearCacheConfirmMessage =>
      'İndirilen okuma sesi bu cihazdan kaldırılacak.';

  @override
  String get settingsClearCacheConfirmAction => 'Temizlemek';

  @override
  String get settingsClearCacheCancel => 'İptal etmek';

  @override
  String get settingsClearCacheSuccess => 'Ses önbelleği temizlendi.';

  @override
  String get settingsClearCacheError =>
      'Ses önbelleği temizlenemedi. Lütfen tekrar deneyin.';
}
