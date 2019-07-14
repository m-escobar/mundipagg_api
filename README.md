# mundipagg_api

Este é um teste do SDK do MundiPagg (meio de pagamento), desenvolvido em Ruby on Rails e apenas para demonstração.

Através desta API você poderá testar algumas funcionalidades do MundiPagg, veja abaixo as instruções para uso.

1 - Uso através de chamadas por JSON.

Preparação:
- Você precisará da sua Secret_Teste_key para acesso ao site da MundiPagg, caso precise criar "planos" para uso nesta demonstração será necessário você informar a Secret_Teste_key nas chamadas abaixo.

- Para criar alguns planos para demonstração:
  mundipagg_api.herokuapp.com/create_plans?Secret_Teste_key
  
- Para listar os planos existentes
  mundipagg_api.herokuapp.com/get_plans?Secret_Teste_key

- Endpoint para chamada da API:
  mundipagg_api.herokuapp.com/customers


2 - Uso através do Ruby on Rails.

Preparação (considerando que você já possui o Ruby instalado):  
  - Clone este repositório para sua máquina
    https://github.com/m-escobar/mundipagg_api.git
  - cd Pasta_do_repositorio
  - 'bundle install'
  
  Você precisará da sua Secret_key fornecida pelo MundiPagg para executar as chamadas da API, para isso você pode criar um arquivo .env com a chave abaixo ou passar a informação pela chamada do json.
  - Crie o arquivo .env na pasta do repositório e inclua o texto abaixo:
    Mundi_API = "Your_Secret_test_Key_from_mundipagg"

  Caso esteja rodando na aws, heroku, etc configure a secret_key como:
  key = Mundi_API
  value = Your_Secret_test_Key_from_mundipagg


 - Execute 'Rails s' e acesse pelo browser localhost:3000 e veja o index da API ou faça uma chamada ao endpoint
  
