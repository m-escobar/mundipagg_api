# mundipagg_api

Este é um teste do SDK do MundiPagg (meio de pagamento), desenvolvido em Ruby on Rails e apenas para demonstração.

Através desta API você poderá testar algumas funcionalidades do MundiPagg, veja abaixo as instruções para uso.

1 - Preparando o server do Ruby on Rails.

- Preparação (considerando que você já possui o Ruby instalado):  
  - Clone este repositório para sua máquina
    https://github.com/m-escobar/mundipagg_api.git
  - cd Pasta_do_repositorio
  - 'bundle install'
  
- Você precisará da sua Secret_key fornecida pelo MundiPagg para executar as chamadas da API, para isso você pode criar um arquivo .env com a chave abaixo ou passar a informação pela chamada do json.
  - Crie o arquivo .env na pasta do repositório e inclua o texto abaixo:
    Mundi_API = "Your_Secret_test_Key_from_mundipagg"

- Caso esteja rodando na aws, heroku, etc configure a secret_key como:
  key = Mundi_API
  value = Your_Secret_test_Key_from_mundipagg

- Execute 'Rails s' e acesse pelo browser localhost:3000 e veja o index da API ou faça uma chamada ao endpoint:
 localhost:3000/customers passando os parâmetros no body da chamada.
 
- Veja exemplos de chamadas no aquivo sample/initializers_to_teste.txt
  
- Você também pode chamar o arquivo sample/mundipagg.html para executar as chamadas. Neste caso primeiro edite o arquivo sample/script.js, remova o comentário e adicione sua Secret_test_key da mundipagg.
  
  Segue a lista de possíveis parâmetros:
  
  
  
