# Teste_API_Yapay
 
 Implementação de testes da API de pagamento utilizando a forma de pagamento “Boleto” .


### 🛠️ Ferramentas Utilizadas

Visual Studio Code 1.54 
<br>Ruby 2.7
<br>Cmder 1.3
<br>Insomnia 2021.1.1

### :gem:Gems (Disponíveis em:  "https://rubygems.org")
<br>gem "rspec", "3.10"
<br>gem "httparty", "0.18.1"
<br>gem "coderay", " 1.1"
<br>gem 'faker', '2.17'


### :computer: Preparando o Ambiente

##### Clone o projeto do GitHub em um diretório:

```
cd "seu diretorio"
git clone https://github.com/pauloribeiro93/Teste_API_Yapay.git

```

##### Execute o seguinte comando para instalar as dependências do Gemfile

```
bundle install
```

### :microscope: Cenários de Testes

##### Após criada a massa de testes, foram criados os seguintes cenários:

```
- Todos os dados válidos
- E-mail inválido
- CPF Inválido
- Valor do produto igual a 0
- Valor do produto negativo
- ID da forma de pagamento inválida
- Dados sem o nó de pagamento
- Todos os dados em branco
 
```
##### Validações aplicadas no retorno:
 
```
- Http Status Code
- Retorno da URL do boleto, linha digitável e tid
- Dados do cliente são iguais ao enviado
- Valor informado é o mesmo retornado
- Validação dos erros retornados quando houver
```


## ⚙️ Executando os testes

##### Utilize o seguinte comando para executar todos os cenários de teste: 

```
rspec
``````
##### Visualização no console:

  <img src="https://raw.githubusercontent.com/pauloribeiro93/Teste_API_Yapay/main/gif/Rspec_Cenarios.gif" width="700" height="500" />


## ✒️ Autor


## Paulo Ribeiro

[![Linkedin Badge](https://img.shields.io/badge/-Paulo-blue?style=flat-square&logo=Linkedin&logoColor=white&link=https://www.linkedin.com/in/ribeiro-paulo/)](https://www.linkedin.com/in/ribeiro-paulo/) 
[![Outlook Badge](https://img.shields.io/badge/-Paulo_Ribeiro-0078d4?style=flat-square&logo=microsoft-outlook&logoColor=white&link=mailto:pauloribeiro93@hotmail.com)](mailto:pauloribeiro93@hotmail.com)
