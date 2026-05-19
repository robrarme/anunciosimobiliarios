 

# 🏢 Dados de Anúncios de Imóveis 

Este repositório contém o **Projeto de Banco de Dados Relacional**, um exercício simples de desenvolvimento que estrutura e analisa dados de mercado imobiliário. 

---## 📐 Arquitetura do Esquema Lógico
O modelo é composto por **5 tabelas centrais interligadas** com regras estritas de integridade referencial:


                                [ Condominios ]
                                       |
                                       | (0:N)
                                       v                        (1:N)
       [ LocalizacaoImoveis ] --> [ Imoveis ] <--- [ Anuncios ] <--- [ HistoricoPrecos ]
                            (1:N)             (1:N)      ^
                                                         | (1:N)
                                                         |
                                                  [ Anunciantes ]

---

## 🗂️ Estrutura das Tabelas e Regras de Negócio

### 1. Núcleo de Infraestrutura Física
*   **`LocalizacaoImoveis`**: Centraliza os dados geográficos extraídos. Armazena atomicamente o **CEP** e aceita coordenadas de Latitude e Longitude para viabilizar análises de mapas de calor e cálculo de raio de proximidade urbana.
*   **`Condominios`**: Armazena dados de edifícios residenciais ou comerciais. A coluna `Infraestrutura` indexa em formato textual as comodidades adicionais oferecidas (ex: *Portaria 24h, Piscina, Academia*), permitindo filtros de busca baseados em palavras-chave.
*   **`Imoveis`**: Entidade física do objeto de estudo. Suporta relacionamento opcional com `Condominios` (para mapear casas de rua ou terrenos que não fazem parte de condomínio). Controla métricas estruturais como área útil, ano de construção, quartos, suítes, banheiros e vagas de garagem.

### 2. Camada Digital
*   **`Anunciantes`**: Mapeia a origem da publicação através de `ENUM`, diferenciando corporações imobiliárias, corretores autônomos ou proprietários diretos. Aplica restrição opcional ao registro profissional (**CRECI**) quando o anunciante é o proprietário.
*   **`Anuncios`**: Armazena metadados críticos como o link original para conferir a fonte do anúncio, o código identificador do portal, o título do anúncio e tempo de exposição através das colunas `DataPublicacao` e `DataDesativacao`.
*   **`HistoricoPrecos`**:  Cada alteração gera um novo registro temporal nesta tabela. Ela aceita fluxos híbridos (valores de venda ou aluguel) e monitora taxas associadas (Condomínio e IPTU).

---

## 📊 Volume de Dados

O repositório acompanha *scripts* de população, totalizando **mais de 180 linhas de dados interligados**:

*   **`LocalizacaoImoveis`**: 10 Regiões estratégicas mapeadas entre São Paulo, Rio de Janeiro, Belo Horizonte, Curitiba e Fortaleza.
*   **`Condominios`**: 10 Empreendimentos.
*   **`Anunciantes`**: 20 Contas simuladas divididas entre empresas e proprietários civis.
*   **`Anuncios`**: 49 Publicações de imóveis.
*   **`HistoricoPrecos`**: 97 Registros cronológicos que emulam a flutuação de preços do mercado imobiliário.
*   **`Imoveis`**: 39 Imóveis que refletem a heterogeneidade real dos portais de anúncios brasileiros.

---

*Projeto desenvolvido como parte dos estudos práticos do curso "Construindo seu Primeiro Projeto Lógico de Banco de Dados" do DIO (https://web.dio.me).*
