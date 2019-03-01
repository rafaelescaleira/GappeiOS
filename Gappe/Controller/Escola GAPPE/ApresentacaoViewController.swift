//
//  ApresentacaoViewController.swift
//  Gappe
//
//  Created by Rafael Escaleira on 01/03/19.
//  Copyright © 2019 Catwork. All rights reserved.
//

import UIKit

class ApresentacaoViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewFlowLayout: UICollectionViewFlowLayout!
    
    let pages = [
        Apresentacao(imageName: "Apresentacao0", title: "", textPresentation: "  A Escola GAPPE, desde 1994, desenvolve um Projeto Educativo para alunos da Educação Infantil e Ensino Fundamental, cuja meta principal é oportunizar aos alunos a construção do conhecimento, integrando as várias áreas de estudo de maneira significativa.\nMISSÃO\nContribuir para o desenvolvimento de cidadãos conscientes, críticos e sensíveis, que sejam capazes de pensar e criar situações para que o mundo se torne mais justo e humano. "),
        Apresentacao(imageName: "Apresentacao1", title: "Proposta Pedagógica",  textPresentation: " Os alunos da Escola GAPPE vão se apropriando dos conhecimentos e construindo valores que contribuirão com sua formação com base nas observações, nas experimentações, nas perguntas e nos desafios lançados.\nO contato com a realidade estudada em sala de aula é proporcionada através de aulas-passeio, viagens, experimentos e vivências, e os estudos realizados pelos alunos são socializados com a comunidade. Ainda é oportunizado momentos aos alunos para que desenvolvam a criatividade, a expressão e o movimento, por meio de atividades significativas e desafiadoras."),
        Apresentacao(imageName: "Apresentacao2", title: "Níveis de Ensino Oferecidos",  textPresentation: "A Escola GAPPE oferece:\n\nEducação Infantil:\n- Nível 1 (para crianças que farão 2 anos)\n- Nível 2 (para crianças que farão 3 anos)\n- Nível 3 (para crianças que farão 4 anos)\n- Nível 4 (para crianças que farão 5 anos)\n\nEnsino Fundamental:\n- 1º ao 9º ano\n\nPeríodo Integral ou estendido;\nClube de Astronomia;\nClube de Robótica;\nClube Olímpico de Matemática;\nAulas extras de futsal e ballet;"),
        Apresentacao(imageName: "Apresentacao3", title: "Diferencial da Escola",  textPresentation: "Uma escola...\n... com uma proposta pedagógica consolidada,\n... que desenvolve o raciocínio,\n... que estimula a elaboração de diferentes estratégias,\n... que forma futuros Empreendedores e Líderes,\n... que amplia a visão de mundo de seus alunos,\n... que favorece a vivência da Educação Científica,\n... que proporciona uma Educação Bilíngue,\n... que forma pessoas que sabem expor suas ideias e falar em público,\n... que valoriza a cultura e a arte,\n... que estimula escritores competentes e leitores informados,\n... que resgata valores como respeito, solidariedade, autonomia e outros,\n... que contribui para o sucesso de seus alunos no Ensino Médio, ENEM, em Feiras Científicas e Tecnológicas e em Olimpíadas de Matemática, Astronomia, Robótica, entre outras."),
        Apresentacao(imageName: "Apresentacao4", title: "Eixos Fundamentais",  textPresentation: " A Educação Empreendedora e Financeira incentiva os alunos a buscarem o autoconhecimento, propiciando a quebra de paradigmas e o desenvolvimento das habilidades e dos comportamentos empreendedores, através do desenvolvimento da autonomia e do protagonismo. Por meio de atividades lúdicas, o ambiente da aprendizagem sensibiliza os alunos a assumirem riscos calculados, a tomares decisões, a terem um olhar observador para que possam identificar ao seu redor, oportunidades de inovações, mesmo em situações desafiadoras e a serem capazes de fazer o melhor uso possível do dinheiro.\n A Educação Bilíngue utiliza a interdisciplinaridade como base de seu programa, em que os conteúdos escolares são integrados à língua inglesa de modo a contribuir para o desenvolvimento da língua estrangeira até atingir a fluência naturalmente. Baseia-se nas abordagens CLIL (Content and Language Integrated Learning) e CBTEFL (Content-Based Teaching of English as a Foreign Language) em que a língua inglesa é utilizada como meio de comunicação e instrução, que contribuirá para o desenvolvimento da língua estrangeira em seus diversos aspectos: vocabulário, gramática, compreensão e produção, tanto oral, quanto escrita.\n A Iniciação Científica da Escola GAPPE busca despertar a vocação científica e incentivar talentos potenciais entre os alunos e tem como objetivo formar pessoas capazes de buscar conhecimentos e saber utilizá-los, fazendo com que elas não sejam, apenas, usuários e sim produtores de conhecimentos. Através da pesquisa, buscam respostas para problemas e se aprofundam em temas que lhes interessam, além de participarem de atividades de pesquisa científica ou tecnológica, orientadas por professores qualificados."),
        Apresentacao(imageName: "Apresentacao5", title: "Time Pedagógico",  textPresentation: " A Equipe de Professores é formada por pessoas qualificadas e comprometidas com o trabalho educativo, que participam de Formação Continuada, através de reuniões de estudo semanais, em que se discutem teorias que fundamentam a prática de modo a tornar o processo de ensino-aprendizagem significativo.\n  A atualização frequente dos educadores se dá, também, pela participação em cursos, seminários, e assessorias, que subsidiam a prática pedagógica, transformando-os em referência para outros profissionais interessados na proposta pedagógica que a Escola GAPPE desenvolve.")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView?.register(ApresentacaoCollectionViewCell.self, forCellWithReuseIdentifier: "ApresentacaoCollectionViewCell")
        collectionView?.isPagingEnabled = true
    }
    
}

extension ApresentacaoViewController {
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        coordinator.animate(alongsideTransition: { (_) in
            self.collectionViewFlowLayout.invalidateLayout()
            
            if self.pageControl.currentPage == 0 {
                self.collectionView?.contentOffset = .zero
            } else {
                let indexPath = IndexPath(item: self.pageControl.currentPage, section: 0)
                self.collectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            }
            
        }) { (_) in
            
        }
    }
}

extension ApresentacaoViewController {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pages.count
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let x = targetContentOffset.pointee.x
        
        pageControl.currentPage = Int(x / view.frame.width)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ApresentacaoCollectionViewCell", for: indexPath) as! ApresentacaoCollectionViewCell
        
        let page = pages[indexPath.item]
        cell.apresentacao = page
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
}
