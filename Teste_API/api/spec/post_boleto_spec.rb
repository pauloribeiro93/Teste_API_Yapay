describe "POST / boleto " do
  context "Todos os dados válidos" do
    before(:all) do
      @name = Faker::Name.name
      @cpf = Faker::IDNumber.brazilian_citizen_number
      @email = Faker::Internet.email
      @price_unit = Faker::Commerce.price
      @shipping_price = Faker::Commerce.price
      @description = Faker::Commerce.product_name
      payload = { token_account: "3f35bb4dc40f28b",
                 customer: {
        contacts: [
          {
            type_contact: "H",
            number_contact: "1133221122",
          },
          {
            type_contact: "M",
            number_contact: "11999999999",
          },
        ],
        addresses: [
          {
            type_address: "B",
            postal_code: "17000-000",
            street: "Av Esmeralda",
            number: "1002",
            completion: "A",
            neighborhood: "Jd Esmeralda",
            city: "Marilia",
            state: "SP",
          },
        ],
        name: @name,
        birth_date: "21/05/1945",
        cpf: @cpf,
        email: @email,
      },
                 transaction_product: [
        {
          description: @description,
          quantity: "1",
          price_unit: @price_unit,
          code: "1",
          sku_code: "0001",
          extra: "Informação Extra",
        },
      ],
                 transaction: {
        available_payment_methods: "2,3,4,5,6,7,14,15,16,18,19,21,22,23",
        customer_ip: "127.0.0.1",
        shipping_type: "Sedex",
        shipping_price: @shipping_price,
        price_discount: "",
        url_notification: "http://www.loja.com.br/notificacao",
        free: "Campo Livre",
      },
                 payment: {
        payment_method_id: "6",
      } }
      @result = Pagamento.new.boleto(payload)
    end

    it ("Valida status code") do
      expect(@result.code).to eql(201)
      puts "Status code : #{@result.code}"
    end

    it "Valor informado é o mesmo retornado" do
      valor_informado = ((@price_unit + @shipping_price).round(2)).to_s

      valor_retornado = (JSON.parse(@result.body)["data_response"]["transaction"]["payment"]["price_payment"]).to_s
      expect(valor_retornado).to eql (valor_informado)
    end

    it "Dados do cliente são iguais ao enviado" do
      expect(@result.parsed_response["data_response"]["transaction"]["customer"]["name"]).to eql (@name)

      expect(@result.parsed_response["data_response"]["transaction"]["customer"]["cpf"]).to eql (@cpf)
    end

    it "Valida retorno da URL" do
      expect(@result.parsed_response["data_response"]["transaction"]["payment"]["url_payment"]).to include("orders/billet")
    end

    it "Valida retorno da TID" do
      expect(@result.parsed_response["data_response"]["transaction"]["payment"]["tid"].length).to eql 11
    end

    it "Valida retorno da linha digitavel" do
      expect(@result.parsed_response["data_response"]["transaction"]["payment"]["linha_digitavel"].length).to eql 58
    end
  end

  ####Dados Invalidos#############
  context "Dados inválidos CPF E-mail" do
    before(:all) do
      payload = { token_account: "3f35bb4dc40f28b",
                 customer: {
        name: "Lucas Strange",
        birth_date: "21/05/1945",
        cpf: "906680878",
        email: "lucas.strange@avengers",
      } }
      @result = Pagamento.new.boleto(payload)
    end
    it "Valida status code" do
      expect(@result.code).to eql(422)
      puts "Status code : #{@result.code}"
    end
    it "CPF inválido" do
      cpf_invalido = (JSON.parse(@result.body)["error_response"]["validation_errors"]).to_s
      expect(cpf_invalido).to include("CPF não é válido")
    end
    it "E-mail inválido" do
      email_invalido = (JSON.parse(@result.body)["error_response"]["validation_errors"]).to_s
      expect(email_invalido).to include("E-mail não é válido")
    end
  end

  context "Valor do produto igual a 0" do
    before(:all) do
      payload = { token_account: "3f35bb4dc40f28b",
                 customer: {
        contacts: [
          {
            type_contact: "H",
            number_contact: "1133221122",
          },
          {
            type_contact: "M",
            number_contact: "11999999999",
          },
        ],
        addresses: [
          {
            type_address: "B",
            postal_code: "17000-000",
            street: "Av Esmeralda",
            number: "1002",
            completion: "A",
            neighborhood: "Jd Esmeralda",
            city: "Marilia",
            state: "SP",
          },
        ],
        name: "Maju Strange",
        birth_date: "21/05/1946",
        cpf: "73992084841",
        email: "Maju.strange@avengers.com",
      },
                 transaction_product: [
        {
          description: "Camiseta Tony Stark",
          quantity: "1",
          price_unit: "0",
          code: "1",
          sku_code: "0001",
          extra: "Informação Extra",
        },
      ] }
      @result = Pagamento.new.boleto(payload)
    end
    it "Valida status code" do
      expect(@result.code).to eql(422)
      puts "Status code : #{@result.code}"
    end
    it "Valor do produto igual a 0" do
      valor_igual_0 = (JSON.parse(@result.body)["error_response"]["validation_errors"]).to_s
      expect(valor_igual_0).to include("Valor loja deve ser maior do que 0")
    end
  end

  context "Produto com o valor negativo" do
    before(:all) do
      payload = { token_account: "3f35bb4dc40f28b",
                 customer: {
        contacts: [
          {
            type_contact: "H",
            number_contact: "1133221122",
          },
          {
            type_contact: "M",
            number_contact: "11999999999",
          },
        ],
        addresses: [
          {
            type_address: "B",
            postal_code: "17000-000",
            street: "Av Esmeralda",
            number: "1002",
            completion: "A",
            neighborhood: "Jd Esmeralda",
            city: "Marilia",
            state: "SP",
          },
        ],
        name: "Lucao Strange",
        birth_date: "21/05/1947",
        cpf: "12409870805",
        email: "caslu.strange@avengers.com",
      },
                 transaction_product: [
        {
          description: "Camiseta Tony Stark",
          quantity: "1",
          price_unit: "-130",
          code: "1",
          sku_code: "0001",
          extra: "Informação Extra",
        },
      ] }
      @result = Pagamento.new.boleto(payload)
    end
    it "Valida status code" do
      expect(@result.code).to eql(422)
      puts "Status code : #{@result.code}"
    end
    it "Valor do produto negativo" do
      produto_valor_negativo = (JSON.parse(@result.body)["error_response"]["validation_errors"]).to_s
      expect(produto_valor_negativo).to include("Valor loja deve ser maior do que 0")

      produto_valor_negativo = (JSON.parse(@result.body)["error_response"]["validation_errors"]).to_s
      expect(produto_valor_negativo).to include("Valor Unitário deve ser maior ou igual a 0")
    end
  end
  context "ID da forma de pagamento inválida" do
    before(:all) do
      @name = Faker::Name.name
      @cpf = Faker::IDNumber.brazilian_citizen_number
      @email = Faker::Internet.email
      @price_unit = Faker::Commerce.price
      @shipping_price = Faker::Commerce.price
      @description = Faker::Commerce.product_name
      payload = { token_account: "3f35bb4dc40f28b",
                 customer: {
        contacts: [
          {
            type_contact: "H",
            number_contact: "1133221122",
          },
          {
            type_contact: "M",
            number_contact: "11999999999",
          },
        ],
        addresses: [
          {
            type_address: "B",
            postal_code: "17000-000",
            street: "Av Esmeralda",
            number: "1002",
            completion: "A",
            neighborhood: "Jd Esmeralda",
            city: "Marilia",
            state: "SP",
          },
        ],
        name: @name,
        birth_date: "21/05/1945",
        cpf: @cpf,
        email: @email,
      },
                 transaction_product: [
        {
          description: @description,
          quantity: "1",
          price_unit: @price_unit,
          code: "1",
          sku_code: "0001",
          extra: "Informação Extra",
        },
      ],
                 payment: {
        payment_method_id: "-38",
      } }

      @result = Pagamento.new.boleto(payload)
    end
    it "Valida status code" do
      expect(@result.code).to eql(422)
      puts "Status code : #{@result.code}"
    end
    it "ID incorreto" do
      id_error = (JSON.parse(@result.body)["error_response"]).to_s
      expect(id_error).to include("Forma de pagamento inválida")
    end
  end

  context "Dados sem o nó de pagamento" do
    before(:all) do
      @name = Faker::Name.name
      @cpf = Faker::IDNumber.brazilian_citizen_number
      @email = Faker::Internet.email
      @price_unit = Faker::Commerce.price
      @shipping_price = Faker::Commerce.price
      @description = Faker::Commerce.product_name
      payload = { token_account: "3f35bb4dc40f28b",
                 customer: {
        contacts: [
          {
            type_contact: "H",
            number_contact: "1133221122",
          },
          {
            type_contact: "M",
            number_contact: "11999999999",
          },
        ],
        addresses: [
          {
            type_address: "B",
            postal_code: "17000-000",
            street: "Av Esmeralda",
            number: "1002",
            completion: "A",
            neighborhood: "Jd Esmeralda",
            city: "Marilia",
            state: "SP",
          },
        ],
        name: @name,
        birth_date: "21/05/1954",
        cpf: @cpf,
        email: @email,
      },
                 transaction_product: [
        {
          description: @description,
          quantity: "1",
          price_unit: @price_unit,
          code: "1",
          sku_code: "0001",
          extra: "Informação Extra",
        },
      ] }

      @result = Pagamento.new.boleto(payload)
    end
    it "Valida status code" do
      expect(@result.code).to eql(422)
      puts "Status code : #{@result.code}"
    end
    it "Sem nó de pagamento" do
      id_error = (JSON.parse(@result.body)["error_response"]).to_s
      expect(id_error).to include("Forma de pagamento inválida")
    end
  end

  context "Todos os dados em branco" do
    before(:all) do
      payload = { token_account: "3f35bb4dc40f28b",
                 customer: {
        contacts: [
          {
            type_contact: "",
            number_contact: "",
          },
          {
            type_contact: "",
            number_contact: "",
          },
        ],
        addresses: [
          {
            type_address: "",
            postal_code: "",
            street: "",
            number: "",
            completion: "",
            neighborhood: "",
            city: "",
            state: "",
          },
        ],
        name: "",
        birth_date: "",
        cpf: "",
        email: "",
      } }

      @result = Pagamento.new.boleto(payload)
    end

    it "Valida status code" do
      expect(@result.code).to eql(422)
      puts "Status code : #{@result.code}"
    end
    it "Dados em branco" do
      dados_em_branco = (JSON.parse(@result.body)["error_response"]).to_s
      expect(dados_em_branco).to include("É necessário informar o CPF para realizar uma transação com essa loja.")
    end
  end
end
