//<<<<<<<<<<<<<< GlobalFunction >>>>>>>>>>>>>>>>>>>>>>>>>>>>>

class GlobalFunction {
  static phoneFormat(String enterPhoneNumber) {
    return enterPhoneNumber.replaceRange(3, 9, "****");
  }

  static emailFormat(String enterEmail) {
    return enterEmail.replaceRange(
        0, "example@gmail.com".indexOf("@") - 3, "****");
  }
}
