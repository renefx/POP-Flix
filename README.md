# POP-Flix
iOS 12 Swift Catálogo de filmes.

Um simples App de catálogo de filmes que permite busca e favoritos. Os dados do filme vem da [The Movie Database API](https://developers.themoviedb.org).

![](https://github.com/renefx/POP-Flix/src/master/popflix.png)

## Compatibilidade
Esse projeto é escrito em Swift 4.2 e necessita de um Xcode Xcode 10.1+ e Cocoapods 1.6.0

## Getting Started
No terminal, navegue até o diretório do projeto e execute pod install. Então abra o arquivo POP Flix/POP Flix.xcworkspace e execute o projeto.
```sh
cd POP Flix
pod install
```

## Features
* Exibe os filmes em cartaz
* Exibe os detalhes dos filmes assim como também seu poster
* No detalhe do filme são exibidos os filmes relacionados àquele filme 
* Pesquisar pelo nome do filme
* Favoritar filmes e verificar sua listagem
* Compartilhamento do filme 

## Projeto
Esse projeto foi criado utilizando a arquitetura MVP a qual utiliza de protocolos para comunição entre as camadas. 
O banco de dados utilizado foi o Realm.
Para conexão com o servidor foi utilizado o Alamofire. 
Para o parsing dos objetos foi utilizada a biblioteca Swift Codable.
Para extrair as cores das imagens dos posteres dos filmes foi utilizado a biblioteca UIImageColors
Para as animações foi utilizado a biblioteca CoreGraphics e animação UIView.animate

## Testes
O projeto de testes compreende de algumas validações simples.
A bibliotace Fakery foi utilizada para dinamizar o processo de teste.
Não foram realizados testes de integração.

## Contato
renefx@gmail.com
