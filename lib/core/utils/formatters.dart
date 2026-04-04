class Formatters {
  static String formatDate(String? dateStr) {
    if (dateStr == null || dateStr.length < 10) return '—';
    final parts = dateStr.substring(0, 10).split('-');
    if (parts.length != 3) return dateStr;
    const months = {
      '01': 'Jan',
      '02': 'Feb',
      '03': 'Mar',
      '04': 'Apr',
      '05': 'May',
      '06': 'Jun',
      '07': 'Jul',
      '08': 'Aug',
      '09': 'Sep',
      '10': 'Oct',
      '11': 'Nov',
      '12': 'Dec',
    };
    return '${months[parts[1]] ?? parts[1]} ${parts[2]}';
  }

  static String capitalise(String s) =>
      s.isEmpty ? s : '${s[0].toUpperCase()}${s.substring(1)}';
}
