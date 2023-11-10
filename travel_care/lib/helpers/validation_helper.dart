  
  String? validateEmptyField(text) {
    if (text == null || text.isEmpty) {
      return "* Campo obrigatório";
    }
    return null;
  }

    String? validateCidade(cidade) {
    if (cidade == null) {
      return "* Campo obrigatório";
    }
    return null;
  }