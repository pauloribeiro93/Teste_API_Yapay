require "httparty"

class Pagamento
  include HTTParty
  base_uri "https://api.intermediador.sandbox.yapay.com.br"

  def boleto(payload)
    return self.class.post(
             "/api/v3/transactions/payment",
             body: payload.to_json,
             headers: {
               "Content-Type": "application/json",
             },
           )
  end
end
