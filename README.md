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
 
- Veja exemplos de chamadas no arquivo sample/initializers_to_teste.txt, aqui você encontrará os parâmetros necessários para cada tipo de operação.
 
- Todas as operações seguem o que está documentado em https://docs.mundipagg.com/reference

- Para acessar sua Secret_test_api faça login em https://id.mundipagg.com/signin, selecione 'Ir para o modo de teste', depois no menu 'Conta' -> 'Configurações -> 'Chaves' - aqui você encontrará suas chaves('api_keys').

- Você também pode chamar o arquivo sample/mundipagg.html para executar as chamadas. Neste caso primeiro edite o arquivo sample/script.js, remova o comentário e adicione sua Secret_test_key da mundipagg.

- Todas as chamadas devem começar com o corpo abaixo:
  
  operacao: {
      tipo: 'list',
      objeto: 'customer',
      api_key: 'sk_test_Your_Secret_Key' 
    }
  
  tipo: define o tipo da operação -> list, create, update, destroy
  objeto: define onde será realizada a operação, nem todas as funções foram implementadas, uma vez que isto é apenas um MVP.
  
  list -> customer, card, subscription
  create -> customer, card, address, product, subscription
  update -> card
  destroy -> card
  
  A operação abaixo por exemplo, irá listar os cartões do cliente:

  "operacao": {
              "tipo": "list",
              "objeto": "card"
              },
              "cliente": {
                "cliente_id": "cus_wpjEBoBfGktyp3qB"
              }
          
 Card -> Update - pode atualizar dados do cartão, mas não permite mudar o número do cartão e nem o CVV. Caso isso seja necessário crie um cartão novo e destrua o antigo.
 

Qualquer dúvida entre em contato - escobar@br.systems
