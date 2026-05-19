DROP DATABASE AnunciosImobiliarios;
CREATE DATABASE AnunciosImobiliarios;
USE AnunciosImobiliarios;

CREATE TABLE IF NOT EXISTS Condominios (
  idCondominio INT NOT NULL,
  NomeCondominio VARCHAR(45) NOT NULL,
  Infraestrutura VARCHAR(256) NOT NULL,
  PRIMARY KEY (idCondominio)
  );
  
CREATE TABLE IF NOT EXISTS Anunciantes (
  idAnunciante INT NOT NULL AUTO_INCREMENT,
  NomeAnunciante VARCHAR(45) NOT NULL,
  TipoAnunciante ENUM('Imobiliária', 'Corretor Autônomo', 'Proprietário Direto') NOT NULL,
  CRECI VARCHAR(16),
  PRIMARY KEY (idAnunciante),
  UNIQUE INDEX idAnunciante_UNIQUE (idAnunciante ASC) VISIBLE);
  
  CREATE TABLE IF NOT EXISTS LocalizacaoImoveis (
  idLocalizacaoImoveis INT AUTO_INCREMENT PRIMARY KEY,
  CEP VARCHAR(8) NOT NULL,
  Logradouro VARCHAR(64),
  Bairro VARCHAR(45) NOT NULL,
  Cidade VARCHAR(45) NOT NULL,
  Estado VARCHAR(45) NOT NULL,
  LatitudeAproximada DECIMAL(9,6),
  LongitudeAproximada DECIMAL(10,6)
  );

CREATE TABLE IF NOT EXISTS Imoveis (
  idImovel INT AUTO_INCREMENT PRIMARY KEY,
  idLocalizacaoImoveis INT NOT NULL,
  idCondominio INT NULL,
  TipoImovel VARCHAR(45) NOT NULL,
  AreaUtilM2 DECIMAL(10,2) NOT NULL,
  AnoConstrucao DECIMAL(4,0),
  QtdQuartos DECIMAL(2,0),
  QtdSuites DECIMAL(2,0),
  QtdBanheiros DECIMAL(2,0),
  QtdVagas DECIMAL(2,0),
  Mobiliado BOOL,
  Varanda BOOL,
  CaracteristicasInternas VARCHAR(45) COMMENT 'Atributo multivalorado/Lista: Piscina privativa, Ar-condicionado...)',
  CONSTRAINT fk_Imoveis_LocalizacaoImoveis
    FOREIGN KEY (idLocalizacaoImoveis)
    REFERENCES LocalizacaoImoveis (idLocalizacaoImoveis),
  CONSTRAINT fk_Imoveis_Condominio
    FOREIGN KEY (idCondominio)
    REFERENCES Condominios (idCondominio)
    );

CREATE TABLE IF NOT EXISTS Anuncios (
  idAnuncio INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  idImovel INT NOT NULL,
  idAnunciante INT NOT NULL,
  CodigoReferenciaPortal VARCHAR(45) NULL COMMENT 'O ID ou SKU que o site de anúncios usa na URL',
  URL VARCHAR(45) NOT NULL,
  TituloAnuncio VARCHAR(64) NOT NULL,
  DescricaoTexto VARCHAR(256) NULL COMMENT 'O texto livre escrito pelo anunciante para análise de sentimento/NLP',
  DataPublicacao DATE NOT NULL,
  DataDesativacao DATE,
  StatusAnuncio ENUM('Ativo', 'Pausado', 'Vendido', 'Excluído'),
  CONSTRAINT fk_Anuncios_Imoveis
    FOREIGN KEY (idImovel)
    REFERENCES Imoveis (idImovel),
  CONSTRAINT fk_Anuncios_Anunciantes
    FOREIGN KEY (idAnunciante)
    REFERENCES Anunciantes (idAnunciante)
);

CREATE TABLE IF NOT EXISTS HistoricoPrecos (
  idHistoricoPreco INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  idAnuncio INT NOT NULL,
  ValorVenda DECIMAL(9,2),
  ValorAluguel DECIMAL(6,2),
  ValorCondominio DECIMAL(6,2),
  ValorIPTU DECIMAL(6,2),
  DataRegistro DATE,
  CONSTRAINT fk_HistoricoPrecos_Anuncios
    FOREIGN KEY (idAnuncio)
    REFERENCES Anuncios (idAnuncio)
);