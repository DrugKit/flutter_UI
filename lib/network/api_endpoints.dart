class ApiUrl {
  static const baseUrl = "https://drugkit.runasp.net/api/";
  static const login = "Authentication/login";
  static const signup = "Authentication/register";
  static const verify = "Authentication/verify-registration-code";
  static const resend = "Authentication/resend-verification-code";
  static const foregt = "Authentication/forget-password";
  static const verifyforget = "/Authentication/check-reset-code";
  static const newpass = "Authentication/reset-password";
  static const getstudent = "Parent/";
  static const addstudent = "Parent/add-student-to-parent";
  static const editprofile = "Parent/edit-parent-name";
  static const editphone = "Parent/edit-parent-phone";
  static const updatepassword = "Authentication/update-password";
  static const addchild = "Parent/AddChild";
  static const updatechild = "Parent/UpdateChild";
  static const addnewstudent = "Parent/add-student-to-parent";

  // ✨ New for Search
  static const searchDrugs = "Drug/AutoComplete";
}
