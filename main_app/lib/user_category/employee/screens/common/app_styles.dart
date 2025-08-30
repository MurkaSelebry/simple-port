import 'package:flutter/material.dart';

class AppStyles {
  // Цветовая схема
  static const Color primaryColor = Color(0xFF2196F3);
  static const Color secondaryColor = Color(0xFF1976D2);
  static const Color accentColor = Color(0xFF03A9F4);
  static const Color successColor = Color(0xFF4CAF50);
  static const Color warningColor = Color(0xFFFF9800);
  static const Color errorColor = Color(0xFFF44336);
  static const Color infoColor = Color(0xFF2196F3);

  // Градиенты
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryColor, secondaryColor],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient successGradient = LinearGradient(
    colors: [successColor, Color(0xFF66BB6A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient warningGradient = LinearGradient(
    colors: [warningColor, Color(0xFFFFB74D)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient errorGradient = LinearGradient(
    colors: [errorColor, Color(0xFFEF5350)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Тени
  static List<BoxShadow> get cardShadow => [
    BoxShadow(
      color: Colors.black.withOpacity(0.1),
      spreadRadius: 1,
      blurRadius: 4,
      offset: const Offset(0, 2),
    ),
  ];

  static List<BoxShadow> get elevatedShadow => [
    BoxShadow(
      color: Colors.black.withOpacity(0.15),
      spreadRadius: 2,
      blurRadius: 8,
      offset: const Offset(0, 4),
    ),
  ];

  // Скругления
  static const BorderRadius smallRadius = BorderRadius.all(Radius.circular(8));
  static const BorderRadius mediumRadius = BorderRadius.all(Radius.circular(12));
  static const BorderRadius largeRadius = BorderRadius.all(Radius.circular(16));
  static const BorderRadius extraLargeRadius = BorderRadius.all(Radius.circular(24));

  // Стили кнопок
  static ButtonStyle get primaryButtonStyle => ElevatedButton.styleFrom(
    backgroundColor: primaryColor,
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    shape: RoundedRectangleBorder(borderRadius: mediumRadius),
    elevation: 2,
  );

  static ButtonStyle get secondaryButtonStyle => OutlinedButton.styleFrom(
    foregroundColor: primaryColor,
    side: const BorderSide(color: primaryColor),
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    shape: RoundedRectangleBorder(borderRadius: mediumRadius),
  );

  static ButtonStyle get successButtonStyle => ElevatedButton.styleFrom(
    backgroundColor: successColor,
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    shape: RoundedRectangleBorder(borderRadius: mediumRadius),
    elevation: 2,
  );

  static ButtonStyle get warningButtonStyle => ElevatedButton.styleFrom(
    backgroundColor: warningColor,
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    shape: RoundedRectangleBorder(borderRadius: mediumRadius),
    elevation: 2,
  );

  static ButtonStyle get errorButtonStyle => ElevatedButton.styleFrom(
    backgroundColor: errorColor,
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    shape: RoundedRectangleBorder(borderRadius: mediumRadius),
    elevation: 2,
  );

  // Адаптивные стили кнопок для мобильных
  static ButtonStyle getMobilePrimaryButtonStyle(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    return ElevatedButton.styleFrom(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 24,
        vertical: isMobile ? 10 : 12,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(isMobile ? 8 : 12),
      ),
      elevation: 2,
    );
  }

  static ButtonStyle getMobileSecondaryButtonStyle(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    return OutlinedButton.styleFrom(
      foregroundColor: primaryColor,
      side: const BorderSide(color: primaryColor),
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 24,
        vertical: isMobile ? 10 : 12,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(isMobile ? 8 : 12),
      ),
    );
  }

  // Стили полей ввода
  static InputDecoration get primaryInputDecoration => InputDecoration(
    border: OutlineInputBorder(
      borderRadius: mediumRadius,
      borderSide: BorderSide(color: Colors.grey.shade300),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: mediumRadius,
      borderSide: BorderSide(color: Colors.grey.shade300),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: mediumRadius,
      borderSide: const BorderSide(color: primaryColor, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: mediumRadius,
      borderSide: const BorderSide(color: errorColor, width: 2),
    ),
    filled: true,
    fillColor: Colors.grey.shade50,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  );

  static InputDecoration get searchInputDecoration => InputDecoration(
    labelText: 'Поиск...',
    hintText: 'Введите текст для поиска',
    prefixIcon: const Icon(Icons.search),
    border: OutlineInputBorder(
      borderRadius: mediumRadius,
      borderSide: BorderSide(color: Colors.grey.shade300),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: mediumRadius,
      borderSide: BorderSide(color: Colors.grey.shade300),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: mediumRadius,
      borderSide: const BorderSide(color: primaryColor, width: 2),
    ),
    filled: true,
    fillColor: Colors.grey.shade50,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  );

  // Адаптивные стили полей ввода для мобильных
  static InputDecoration getMobileSearchInputDecoration(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    return InputDecoration(
      labelText: 'Поиск...',
      hintText: 'Введите текст для поиска',
      prefixIcon: Icon(Icons.search, size: isMobile ? 20 : 24),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(isMobile ? 8 : 12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(isMobile ? 8 : 12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(isMobile ? 8 : 12),
        borderSide: const BorderSide(color: primaryColor, width: 2),
      ),
      filled: true,
      fillColor: Colors.grey.shade50,
      contentPadding: EdgeInsets.symmetric(
        horizontal: isMobile ? 12 : 16,
        vertical: isMobile ? 10 : 12,
      ),
    );
  }

  // Стили карточек
  static BoxDecoration get cardDecoration => BoxDecoration(
    color: Colors.white,
    borderRadius: mediumRadius,
    boxShadow: cardShadow,
  );

  static BoxDecoration get elevatedCardDecoration => BoxDecoration(
    color: Colors.white,
    borderRadius: mediumRadius,
    boxShadow: elevatedShadow,
  );

  // Адаптивные стили карточек для мобильных
  static BoxDecoration getMobileCardDecoration(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(isMobile ? 8 : 12),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(isMobile ? 0.08 : 0.1),
          spreadRadius: 1,
          blurRadius: isMobile ? 3 : 4,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  // Стили чипов
  static BoxDecoration get statusChipDecoration => BoxDecoration(
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: Colors.grey.shade300),
  );

  static BoxDecoration get successChipDecoration => BoxDecoration(
    color: successColor.withOpacity(0.1),
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: successColor.withOpacity(0.3)),
  );

  static BoxDecoration get warningChipDecoration => BoxDecoration(
    color: warningColor.withOpacity(0.1),
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: warningColor.withOpacity(0.3)),
  );

  static BoxDecoration get errorChipDecoration => BoxDecoration(
    color: errorColor.withOpacity(0.1),
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: errorColor.withOpacity(0.3)),
  );

  // Стили текста
  static const TextStyle headingStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.black87,
  );

  static const TextStyle subheadingStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: Colors.black87,
  );

  static const TextStyle bodyStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: Colors.black87,
  );

  static const TextStyle captionStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: Colors.grey,
  );

  static const TextStyle buttonTextStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  // Адаптивные стили текста для мобильных
  static TextStyle getMobileHeadingStyle(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    return TextStyle(
      fontSize: isMobile ? 20 : 24,
      fontWeight: FontWeight.bold,
      color: Colors.black87,
    );
  }

  static TextStyle getMobileBodyStyle(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    return TextStyle(
      fontSize: isMobile ? 14 : 16,
      fontWeight: FontWeight.normal,
      color: Colors.black87,
    );
  }

  static TextStyle getMobileCaptionStyle(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    return TextStyle(
      fontSize: isMobile ? 12 : 14,
      fontWeight: FontWeight.normal,
      color: Colors.grey,
    );
  }

  // Анимации
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);

  // Отступы
  static const EdgeInsets smallPadding = EdgeInsets.all(8);
  static const EdgeInsets mediumPadding = EdgeInsets.all(16);
  static const EdgeInsets largePadding = EdgeInsets.all(24);

  static const EdgeInsets horizontalPadding = EdgeInsets.symmetric(horizontal: 16);
  static const EdgeInsets verticalPadding = EdgeInsets.symmetric(vertical: 16);

  // Адаптивные отступы для мобильных
  static EdgeInsets getMobilePadding(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    return EdgeInsets.all(isMobile ? 8 : 16);
  }

  static EdgeInsets getMobileHorizontalPadding(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    return EdgeInsets.symmetric(horizontal: isMobile ? 12 : 16);
  }

  static EdgeInsets getMobileVerticalPadding(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    return EdgeInsets.symmetric(vertical: isMobile ? 8 : 16);
  }

  // Размеры
  static const double iconSize = 24;
  static const double smallIconSize = 16;
  static const double largeIconSize = 32;

  // Методы для создания адаптивных размеров
  static double getResponsiveFontSize(BuildContext context, double baseSize) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 600) {
      return baseSize * 0.8;
    } else if (screenWidth < 900) {
      return baseSize;
    } else {
      return baseSize * 1.2;
    }
  }

  static EdgeInsets getResponsivePadding(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 600) {
      return smallPadding;
    } else if (screenWidth < 900) {
      return mediumPadding;
    } else {
      return largePadding;
    }
  }

  // Методы для создания статусных цветов
  static Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'активен':
      case 'да':
      case 'true':
      case 'в обработке':
        return successColor;
      case 'неактивен':
      case 'нет':
      case 'false':
      case 'отменен':
        return errorColor;
      case 'в процессе':
      case 'pending':
      case 'новый':
      case 'в план на отгрузку':
        return warningColor;
      case 'готов':
      case 'завершен':
        return successColor;
      default:
        return Colors.grey;
    }
  }

  static Color getStatusBackgroundColor(String status) {
    switch (status.toLowerCase()) {
      case 'активен':
      case 'да':
      case 'true':
      case 'в обработке':
        return successColor.withOpacity(0.1);
      case 'неактивен':
      case 'нет':
      case 'false':
      case 'отменен':
        return errorColor.withOpacity(0.1);
      case 'в процессе':
      case 'pending':
      case 'новый':
      case 'в план на отгрузку':
        return warningColor.withOpacity(0.1);
      case 'готов':
      case 'завершен':
        return successColor.withOpacity(0.1);
      default:
        return Colors.grey.withOpacity(0.1);
    }
  }

  // Стили для таблиц
  static const EdgeInsets chipPadding = EdgeInsets.symmetric(horizontal: 8, vertical: 4);
  
  static BoxDecoration getChipDecoration(Color color) => BoxDecoration(
    color: color.withOpacity(0.1),
    borderRadius: BorderRadius.circular(12),
    border: Border.all(color: color.withOpacity(0.3)),
  );

  static TextStyle getChipTextStyle(Color color) => TextStyle(
    color: color,
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle bodyTextStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: Colors.black87,
  );

  static const EdgeInsets cardMargin = EdgeInsets.all(8);
  static const EdgeInsets listPadding = EdgeInsets.all(16);
  static const EdgeInsets cardPadding = EdgeInsets.all(16);

  // Адаптивные отступы для мобильных таблиц
  static EdgeInsets getMobileCardMargin(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    return EdgeInsets.all(isMobile ? 4 : 8);
  }

  static EdgeInsets getMobileListPadding(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    return EdgeInsets.all(isMobile ? 8 : 16);
  }

  static EdgeInsets getMobileCardPadding(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    return EdgeInsets.all(isMobile ? 12 : 16);
  }

  static const TextStyle titleTextStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.black87,
  );

  static const TextStyle captionTextStyle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: Colors.grey,
  );

  static const TextStyle labelTextStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: Colors.black87,
  );

  // Адаптивные стили текста для мобильных таблиц
  static TextStyle getMobileTitleTextStyle(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    return TextStyle(
      fontSize: isMobile ? 14 : 16,
      fontWeight: FontWeight.w600,
      color: Colors.black87,
    );
  }

  static TextStyle getMobileLabelTextStyle(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    return TextStyle(
      fontSize: isMobile ? 12 : 14,
      fontWeight: FontWeight.w500,
      color: Colors.black87,
    );
  }

  static ButtonStyle get iconButtonStyle => IconButton.styleFrom(
    foregroundColor: primaryColor,
    backgroundColor: Colors.transparent,
    padding: const EdgeInsets.all(8),
  );

  // Адаптивные стили иконок для мобильных
  static ButtonStyle getMobileIconButtonStyle(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    return IconButton.styleFrom(
      foregroundColor: primaryColor,
      backgroundColor: Colors.transparent,
      padding: EdgeInsets.all(isMobile ? 6 : 8),
      iconSize: isMobile ? 16 : 20,
    );
  }

  static BoxDecoration get tableDecoration => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(8),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.1),
        spreadRadius: 1,
        blurRadius: 3,
        offset: const Offset(0, 1),
      ),
    ],
  );

  static const TextStyle headerTextStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: Colors.black87,
  );

  // Адаптивные стили заголовков для мобильных
  static TextStyle getMobileHeaderTextStyle(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    return TextStyle(
      fontSize: isMobile ? 12 : 14,
      fontWeight: FontWeight.bold,
      color: Colors.black87,
    );
  }
}
