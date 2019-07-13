  def initialize #list 
    @json =  { "operacao": {
                  "tipo": "list",
                  "objeto": "subscription"
                },
               "assinatura": {
                  "assinatura_id": "sub_VdWEX2OCpfAGN32k",
                },
               "cliente": {
                  "cliente_id": "cus_wpjEBoBfGktyp3qB"
                }
             }
  end

  def initialize #card update
    @json =  { "operacao": {
                  "tipo": "update"
                },
                "cliente": {
                  "cliente_id": "cus_Eb7MnpAcpuexKv1W"
                },
                "cartao": {
                  "expiracao_mes": 2,
                  "expiracao_ano": 2027,
                  "cartao_id": "card_Yk7LPB57FzCeEwoe",
                  # "endereco_id": "addr_RjnL4ERtjsaBZzoW"
                },
                "endereco": {
                  "rua": "Rua Victor",
                  "numero": "479",
                  "bairro": "Jardim Maralina",
                  "cep": "06704-505",
                  "cidade": "Cotia",
                  "estado": "SP",
                  "pais": "BR"
                }
              }
  end

  def initialize #destroy subscription
    @json =  { "operacao": {
                  "tipo": "destroy",
                  "objeto": "subscription"
                },
                "assinatura": {
                  "assinatura_id": "sub_l2pVEJz6cnI1EvLz",
                }
             }
  end

  def initialize #destroy card
    @json =  { "operacao": {
                  "tipo": "destroy",
                  "objeto": "card"
                },
                "cliente": {
                  "cliente_id": "cus_Q2PLB9AF3U1OWg5G"
                },
                "cartao": {
                  "cartao_id": "card_Vd6JoJeuOuk5DwPp",
                }
             }
  end





  def initialize #create
    @json =  { "operacao": {
                "tipo": "create"
                }, 
              "cliente": {
                # "cliente_id": "cus_2MA0kweCQTxB0lPW",
                "nome": "A. Mariangela Santos",
                "email": "Amariangela@gmail.com"
              },
              "cartao": {
                  "numero": "4000000000000010",
                  "expiracao_mes": 12,
                  "expiracao_ano": 2024,
                  "cvv": "351",
                  # "endereco_id": "addr_dBYmZReMU2UKv1p4"
                },
              "produtos": [
                  {
                      "tipo": "plano 2020",
                      "plano_id": "plan_27JVjOvtQBf6xMgm",
                      "nome": "plano Teste 2020",
                      "descricao": "Assinatura Bianual",
                      "info_extrato": "Cobranca Bianual",
                      "metodo_pagamento": "credit_card",
                      "parcelas": 1,
                      "moeda": "BRL",
                      "tipo_intervalo": "year",
                      "intervalo": 2,
                      "tipo_cobranca": "prepaid",
                      "valor": 254000,
                      "periodo_teste": 14,
                      "quantidade": 1
                    }
                ],
              "endereco": {
                    "rua": "Rua Victor Hugo",
                    "numero": "479",
                    "bairro": "Jardim Maralina",
                    "cep": "06704-505",
                    "cidade": "Cotia",
                    "estado": "SP",
                    "pais": "BR"
                  }
          }
  end
