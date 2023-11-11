  String getFirstName(String? nomeCompleto) {
    if (nomeCompleto != null) {
      return nomeCompleto.split(" ").first;
    }
    return "Prezado Usuário";
  }