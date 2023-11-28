
  
  String? validateEmptyField(text) {
     if (text == null || text.isEmpty) {
       return "* Campo obrigatório";
     }

    return null;
  }

    String? validateNotNull(object) {
    if (object == null) {
      return "* Campo obrigatório";
    }
    return null;
  }


  
