import 'package:supabase/supabase.dart';

// CADASTRAR veículo
cadastrarVeiculo(
  SupabaseClient cliente,
  String marca,
  String modelo,
  int ano,
  double valor,
  int quilometragem,
) async {
  final veiculo = await cliente
      // seleciona a tabela
      .from("veiculos")
      // inserir dados na tabela
      .insert({
        "marca": marca,
        "modelo": modelo,
        "ano": ano,
        "valor": valor,
        "quilometragem": quilometragem,
      })
      // retorna o registro
      .select()
      // registro único
      .single();

  return veiculo;
}

// LISTAR veículos
listarVeiculos(SupabaseClient cliente) async {
  final veiculos = await cliente
      // definir a tabela que iremos consultar
      .from("veiculos")
      // consultar os dados
      .select("id, marca, modelo, ano, valor, quilometragem")
      // ordenação ID
      .order("id");

  return veiculos;
}

// ATUALIZAR veículo
atualizarVeiculo(
  SupabaseClient cliente,
  int id,
  String marca,
  String modelo,
  int ano,
  double valor,
  int quilometragem,
) async {
  final veiculos = await cliente
      // informar a tabela
      .from("veiculos")
      // método para atualizar
      .update({
        "marca": marca,
        "modelo": modelo,
        "ano": ano,
        "valor": valor,
        "quilometragem": quilometragem,
      })
      // identificador
      .eq("id", id)
      // retornar os valores atualizados
      .select();

  // nenhum registro afetado
  if (veiculos.isEmpty) {
    return null;
  }

  return veiculos.first;
}

// EXCLUIR veículo
excluirVeiculo(SupabaseClient cliente, int id) async {
  final veiculos = await cliente
      // informa a tabela
      .from("veiculos")
      // método para exclusão
      .delete()
      // informar o id
      .eq("id", id)
      // retorna o veículo excluído
      .select();

  // nenhum registro afetado
  if (veiculos.isEmpty) {
    return null;
  }

  return veiculos.first;
}