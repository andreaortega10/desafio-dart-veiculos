import 'dart:io';
import 'package:supabase/supabase.dart';
import '../lib/conexao.dart';
import '../lib/veiculos.dart';

main() async {
  // conexão com supabase
  final supabase = conectar();

  // espera o usuário ler o resultado antes de mostrar o menu de novo
  void pausar() {
    stdout.write("\nPressione Enter para voltar ao menu...");
    stdin.readLineSync();
  }

  try {
    var opcao = "";

    while (opcao != "0") {
      print("\n-------------------------------------");
      print("CADASTRO DE VEÍCULOS");
      print("1 - Cadastrar veículo");
      print("2 - Listar veículos");
      print("3 - Atualizar veículo");
      print("4 - Excluir veículo");
      print("0 - Sair");
      print("-------------------------------------");
      stdout.write("O que deseja fazer? ");

      // se a entrada acabar (null), encerra o programa
      opcao = (stdin.readLineSync() ?? "0").trim();

      try {
        switch (opcao) {
          case "1":
            await cadastrar(supabase);
          case "2":
            await listar(supabase);
          case "3":
            await atualizar(supabase);
          case "4":
            await excluir(supabase);
          case "0":
            print("Sistema encerrado.");
          default:
            print("Opção inválida. Tente novamente.");
        }
      } catch (erro) {
        print("Ocorreu o seguinte erro: $erro");
      }

      // pausa depois de qualquer resultado, menos ao sair
      if (opcao != "0") {
        pausar();
      }
    }
  } finally {
    // encerra a conexão
    await supabase.dispose();
  }
}

// 1: cadastrar
cadastrar(SupabaseClient supabase) async {
  
  final marca = lerTexto("Marca", 50);
  if (marca == null) return;

  final modelo = lerTexto("Modelo", 100);
  if (modelo == null) return;

  final ano = lerAno("Ano");
  if (ano == null) return;

  final valor = lerValor("Valor");
  if (valor == null) return;

  final quilometragem = lerQuilometragem("Quilometragem");
  if (quilometragem == null) return;

  final veiculo = await cadastrarVeiculo(
    supabase,
    marca,
    modelo,
    ano,
    valor,
    quilometragem,
  );
  print("*********************");
  print("Veículo cadastrado!");
  print("*********************");
  print(formatarVeiculo(veiculo));
}


// 2: listar

listar(SupabaseClient supabase) async {
  final veiculos = await listarVeiculos(supabase);

  if (veiculos.isEmpty) {
    print("Nenhum veículo cadastrado.");
    return;
  }

  for (final veiculo in veiculos) {
    final valor = (veiculo["valor"] as num).toStringAsFixed(2);

    print(
      "ID: ${veiculo["id"]} | Marca: ${veiculo["marca"]} | Modelo: ${veiculo["modelo"]}",
    );
    print("Ano: ${veiculo["ano"]} | Valor: R\$ $valor");
    print("Quilometragem: ${veiculo["quilometragem"]} km");
    print("");
  }
}


// 3: atualizar

atualizar(SupabaseClient supabase) async {
  final id = lerId("ID do veículo");
  if (id == null) return;

  
  final veiculoAtual = await buscarVeiculo(supabase, id);
  if (veiculoAtual == null) {
    print("Nenhum veículo encontrado com o ID $id.");
    return;
  }

  // o usuário digita novamente todos os dados (o ID não muda)
  final marca = lerTexto("Nova marca", 50, atual: "${veiculoAtual["marca"]}");
  if (marca == null) return;

  final modelo = lerTexto(
    "Novo modelo",
    100,
    atual: "${veiculoAtual["modelo"]}",
  );
  if (modelo == null) return;

  final ano = lerAno("Novo ano", atual: "${veiculoAtual["ano"]}");
  if (ano == null) return;

  final valorAtual = (veiculoAtual["valor"] as num).toStringAsFixed(2);
  final valor = lerValor("Novo valor", atual: "R\$ $valorAtual");
  if (valor == null) return;

  final quilometragem = lerQuilometragem(
    "Nova quilometragem",
    atual: "${veiculoAtual["quilometragem"]} km",
  );
  if (quilometragem == null) return;

  final veiculo = await atualizarVeiculo(
    supabase,
    id,
    marca,
    modelo,
    ano,
    valor,
    quilometragem,
  );

  // proteção extra: o registro pode ter sumido entre a busca e a atualização
  if (veiculo == null) {
    print("Nenhum veículo foi atualizado.");
    return;
  }

  print("*********************");
  print("Veículo atualizado!");
  print("*********************");
  print(formatarVeiculo(veiculo));
}


// 4: excluir

excluir(SupabaseClient supabase) async {
  final id = lerId("ID do veículo");
  if (id == null) return;

  
  final veiculoAtual = await buscarVeiculo(supabase, id);
  if (veiculoAtual == null) {
    print("Nenhum veículo encontrado com o ID $id.");
    return;
  }

  print("Veículo: ${veiculoAtual["marca"]} ${veiculoAtual["modelo"]}");
  final confirmacao = lerEntrada("Confirma a exclusão? S/N");

  // N ou n cancela
  if (confirmacao == "N" || confirmacao == "n") {
    print("Exclusão cancelada.");
    return;
  }

  // qualquer resposta diferente de S, s, N, n é rejeitada sem excluir
  if (confirmacao != "S" && confirmacao != "s") {
    print("Resposta inválida. Digite S ou N. Nada foi excluído.");
    return;
  }

  final veiculo = await excluirVeiculo(supabase, id);

  if (veiculo == null) {
    print("Nenhum veículo foi excluído.");
    return;
  }

  print("*********************");
  print("Veículo excluído!");
  print("*********************");
  print("ID: ${veiculo["id"]} | ${veiculo["marca"]} ${veiculo["modelo"]}");
}


// formatar

String formatarVeiculo(Map veiculo) {
  // o valor volta do banco como número (int ou double)
  final valor = (veiculo["valor"] as num).toStringAsFixed(2);

  return "ID: ${veiculo["id"]} | ${veiculo["marca"]} ${veiculo["modelo"]} | "
      "Ano: ${veiculo["ano"]} | Valor: R\$ $valor | "
      "Quilometragem: ${veiculo["quilometragem"]} km";
}

// leitura e validação

String lerEntrada(String nome, {String? atual}) {
  if (atual != null) {
    stdout.write("$nome (atual: $atual): ");
  } else {
    stdout.write("$nome: ");
  }
  return (stdin.readLineSync() ?? "").trim();
}


String? lerTexto(String nome, int limite, {String? atual}) {
  final texto = lerEntrada(nome, atual: atual);

  if (texto.isEmpty) {
    print("$nome é obrigatório.");
    return null;
  }

  if (texto.length > limite) {
    print("$nome deve ter no máximo $limite caracteres.");
    return null;
  }

  return texto;
}

// ANO: inteiro entre 1900 e o ano atual + 1
int? lerAno(String nome, {String? atual}) {
  final anoMaximo = DateTime.now().year + 1;
  final ano = int.tryParse(lerEntrada(nome, atual: atual));

  if (ano == null) {
    print("$nome deve ser um número inteiro.");
    return null;
  }

  if (ano < 1900 || ano > anoMaximo) {
    print("$nome deve estar entre 1900 e $anoMaximo.");
    return null;
  }

  return ano;
}

// VALOR: maior que zero, até 2 casas decimais, vírgula ou ponto, sem milhar
double? lerValor(String nome, {String? atual}) {
  final texto = lerEntrada(nome, atual: atual);

  // só dígitos, com no máximo 2 casas depois do separador decimal
  if (!RegExp(r'^\d+([.,]\d{1,2})?$').hasMatch(texto)) {
    print(
      "$nome inválido. Use só números, com vírgula ou ponto e até 2 casas decimais (ex.: 65000,00).",
    );
    return null;
  }

  // troca a vírgula por ponto para o Dart converter
  final valor = double.parse(texto.replaceAll(",", "."));

  if (valor <= 0) {
    print("$nome deve ser maior que zero.");
    return null;
  }

  if (valor >= 10000000000) {
    print("$nome deve ser menor que 10000000000.");
    return null;
  }

  return valor;
}

// QUILOMETRAGEM: inteiro maior ou igual a zero
int? lerQuilometragem(String nome, {String? atual}) {
  final km = int.tryParse(lerEntrada(nome, atual: atual));

  if (km == null) {
    print("$nome deve ser um número inteiro.");
    return null;
  }

  if (km < 0) {
    print("$nome não pode ser negativa.");
    return null;
  }

  return km;
}

// ID: inteiro positivo
int? lerId(String nome) {
  final id = int.tryParse(lerEntrada(nome));

  if (id == null) {
    print("$nome deve ser um número inteiro.");
    return null;
  }

  if (id <= 0) {
    print("$nome deve ser um número positivo.");
    return null;
  }

  return id;
}