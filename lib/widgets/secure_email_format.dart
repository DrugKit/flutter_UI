String secureEmailFormat(String email) {
  List<String> parts = email.split('@'); // تقسيم الاسم عن النطاق
  if (parts.length != 2) return email; // لو مش بريد صحيح، رجّعه كما هو

  String username = parts[0];
  String domain = parts[1];

  if (username.length <= 5) {
    return '${username[0]}***@$domain'; // لو الاسم قصير جدًا، نخفيه جزئيًا
  }

  // إظهار أول 3 حروف وآخر حرفين وإخفاء الباقي
  String visibleStart = username.substring(0, 3);
  String hiddenPart = '*' * (username.length - 5);
  String visibleEnd = username.substring(username.length - 2);

  return '$visibleStart$hiddenPart$visibleEnd@$domain';
}
