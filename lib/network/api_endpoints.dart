class ApiUrl {
  static const baseUrl = "https://drugkit.runasp.net/api/";
  static const login = "Authentication/login";
  static const signup = "Authentication/register";
  static const verify = "Authentication/verify-registration-code";
  static const resend = "Authentication/resend-verification-code";
  static const foregt = "Authentication/forget-password";
  static const verifyforget = "/Authentication/check-reset-code";
  static const newpass = "Authentication/reset-password";
  static const getcategorydrugs = "Drug/GetCategoryDrugs";

  // ✨ New for Search
  static const searchDrugs = "Drug/AutoComplete";
  static const drugDetailsByName = "Drug/GetDrugsDetailsByName";
static const drugRecommendation = "Drug/GetDrugsRecomendationByDrugName";

}
