/// Converts Western digits to Arabic-Indic numerals (e.g. 285 → ٢٨٥).
String toArabicIndicNumerals(int number) {
  const digits = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
  return number
      .toString()
      .split('')
      .map((char) => digits[int.parse(char)])
      .join();
}
