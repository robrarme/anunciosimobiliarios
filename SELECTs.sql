USE AnunciosImobiliarios;

-- Valor do m² dos imóveis vendidos ordenados em ordem decrescente
SELECT TituloAnuncio, 
	ROUND(AVG(AreaUtilM2),1) as 'Área Útil (m²)', 
	CONCAT('R$ ', FORMAT(MIN(ValorVenda), 0, 'de_DE')) as 'Valor de Venda', 
    CONCAT('R$ ', FORMAT(AVG(ValorCondominio), 0, 'de_DE')) as 'Valor da Taxa de Condomínio', 
    CONCAT('R$ ', FORMAT(AVG(ValorIPTU), 0, 'de_DE')) as 'Custo de IPTU',
	CONCAT('R$ ', FORMAT(MIN(ValorVenda)/AVG(AreaUtilM2), 0, 'de_DE')) as 'Valor do M²'
FROM Imoveis a, Anuncios b, HistoricoPrecos c
WHERE a.idImovel = b.idImovel
	AND b.idAnuncio = c.idAnuncio
    AND StatusAnuncio = 'Vendido'
GROUP BY 1
ORDER BY MIN(ValorVenda)/AVG(AreaUtilM2) DESC;

-- Valor total de imóveis e m² por anunciante
SELECT NomeAnunciante,
	COUNT(idImovel) as 'Qtde. Imóveis', 
    FORMAT(SUM(ValorVenda), 0, 'de_DE') as 'Valor Total de Vendas', 
    FORMAT(SUM(ValorAluguel),0, 'de_DE') as 'Valor Total de Aluguéis', 
    FORMAT(SUM(AreaUtil),0, 'de_DE') as 'Área Útil Total (m²)'
FROM Anunciantes e
LEFT JOIN 
(SELECT a.idImovel, 
	b.idAnunciante,
	ROUND(MIN(ValorVenda),0) as 'ValorVenda', 
    ROUND(MIN(ValorAluguel)) as 'ValorAluguel', 
    ROUND(AVG(AreaUtilM2),2) as 'AreaUtil'
FROM Imoveis a, Anuncios b, HistoricoPrecos c
WHERE a.idImovel = b.idImovel
	AND b.idAnuncio = c.idAnuncio
GROUP BY 1, 2) f 
ON e.idAnunciante = f.idAnunciante
GROUP BY 1
ORDER BY 3 DESC;

-- Valor e m² total de imóveis por cidade, por venda e por aluguel, ordenado por Valor de Venda do m²
SELECT Cidade,
	COUNT(idImovel) as 'Qtde. Imóveis', 
    FORMAT(SUM(ValorVenda), 0, 'de_DE') as 'Valor Total de Vendas', 
    FORMAT(SUM(ValorAluguel),0, 'de_DE') as 'Valor Total de Aluguéis', 
    FORMAT(SUM(AreaUtil),0, 'de_DE') as 'Área Útil Total (m²)',
    FORMAT(SUM(ValorVenda)/SUM(AreaUtil), 2, 'de_DE') as 'Valor de Venda do M²'
FROM LocalizacaoImoveis e
LEFT JOIN 
(SELECT a.idImovel, 
	a.idLocalizacaoImoveis,
	ROUND(MIN(ValorVenda),0) as 'ValorVenda', 
    ROUND(MIN(ValorAluguel)) as 'ValorAluguel', 
    ROUND(AVG(AreaUtilM2),2) as 'AreaUtil'
FROM Imoveis a, Anuncios b, HistoricoPrecos c
WHERE a.idImovel = b.idImovel
	AND b.idAnuncio = c.idAnuncio
GROUP BY 1, 2) f 
ON e.idLocalizacaoImoveis = f.idLocalizacaoImoveis
GROUP BY 1
ORDER BY SUM(ValorVenda)/SUM(AreaUtil) DESC;