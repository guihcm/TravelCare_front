import 'package:travel_care/models/cidade.dart';
import 'package:travel_care/models/pessoa.dart';

class ProfileModel {
  final Pessoa? pessoa;
  final List<Cidade>? cidades;

  ProfileModel(this.pessoa, this.cidades);
}
