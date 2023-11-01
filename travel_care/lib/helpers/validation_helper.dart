  
  String? validateEmptyField(text) {
    if (text == null || text.isEmpty) {
      return "* Campo obrigatório";
    }
    return null;
  }