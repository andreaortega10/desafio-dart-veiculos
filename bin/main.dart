import 'package:crud_supabase/conexao.dart';
import 'package:crud_supabase/veiculos.dart';

main() async {
  final cliente = conectar();
  try {
    final novo = await cadastrarVeiculo(cliente, 'Chevrolet', 'Onix', 2022, 65000.00, 35000);
    print(novo);
    print(await listarVeiculos(cliente));
    final id = novo['id'] as int;
    print(await atualizarVeiculo(cliente, id, 'Chevrolet', 'Onix LT', 2022, 63000.00, 35200));
    print(await excluirVeiculo(cliente, id));
    print(await excluirVeiculo(cliente, id)); // já excluído: deve imprimir null
  } catch (erro) {
    print('Erro: $erro');
  } finally {
    await cliente.dispose();
  }
}