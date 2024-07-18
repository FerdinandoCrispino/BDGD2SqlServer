# Visão Geral

O DBGD2SqlServer é extrator de dados oriundos do Banco de Dados Geográfico da Distribuidora (BDGD) e inserção 
na base de dados SQLSERVER definida pela ANEEL no progGeoPerdas.

Implementa duas soluções, a primenira utiliza dados da BDGD no formato DBF, que podem ser obtidas atraves de 
aplicativo com Qgis, e uma segunda solução que implementa a extração dos dados diretamente do BDGD obtido no 
site da ANEEL.

Para execução deve-se alter os parametros de configuração no arquivo config_database.yml com as informações 
de conexão com o banco de dados SQLServer e os paramentros de dados da BDGD.

A execução da solução com arquivos DBF deve-se executar a programa DBF2SQL.py e para a solução com o arquivo
da BDGD no formato *.gdb deve-se excutar o programa BDGD2SQLSERVER.py.

Para a execução correta do extrator, deve-se verificar se as etapas de preparação da base de dados SQLServer disponivel no roteiro.txt foram realizadas.

## Uso
Dbf2sql.py -- para extrair dados de arquivos dbf oriundo de arquivos da BDGD para a base de dados SQLServer com modelo de dados do programa progGeoPerdas.

Bdgd2SQL_V2.py -- para a extração direta dos arquivos da BDGD no formado GBD para a base de dados SQLServer com modelo de dados do programa progGeoPerdas.

Network_analysis.py -- para a verificação da conectividade elétrica dos dados da base de dados SQLServer com modelo de dados do programa progGeoPerdas.

Electric_data.py -- para a geração dos arquivos DSS para uma determinada subestação.
Os arquivos são gerados na pasta do usuário do PC, sendo criado uma pasta chamada DSS e subpasta com o ID da subestação em análise. Nestas subpastas são escritos os arquivos gerados para o DSS.
## Contribuições
