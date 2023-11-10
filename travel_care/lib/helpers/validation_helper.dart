  
  String? validateEmptyField(text) {
    if (text == null || text.isEmpty) {
      return "* Campo obrigatório";
    }
    return null;
  }

    String? validateNotNull(cidade) {
    if (cidade == null) {
      return "* Campo obrigatório";
    }
    return null;
  }