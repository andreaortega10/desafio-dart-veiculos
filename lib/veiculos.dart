import 'package:supabase/supabase.dart';

// cadastrar
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

// listar
listarVeiculos(SupabaseClient cliente) async {
  final veiculos = await cliente
    // seleciona a tabela
    .from("veiculos")
    // consultar os dados
    .select("id, marca, modelo, ano, valor, quilometragem")
    // ordenação ID
    .order("id");

  return veiculos;
}

// atualizar
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
      // seleciona a tabela
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
      // selecionar a tabela
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

// buscar por id
buscarVeiculo(SupabaseClient cliente, int id) async {
  final veiculos = await cliente
      // informa a tabela
      .from("veiculos")
      // consultar os dados
      .select("id, marca, modelo, ano, valor, quilometragem")
      // identificador
      .eq("id", id);

  // nenhum registro encontrado
  if (veiculos.isEmpty) {
    return null;
  }

  return veiculos.first;
}