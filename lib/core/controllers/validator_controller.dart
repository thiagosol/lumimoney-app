class ValidatorController {
  ValidatorController();

  String? emptyValidator(String? value, String msg) {
    return value?.isEmpty ?? true ? msg : null;
  }
}
