// Classe principal de Utilizador
public abstract class Utilizador {
    private String nome;
    private String email;
    private String senha;
    private TipoUtilizador tipo;
}

// Enum para tipos de utilizador
public enum TipoUtilizador {
    ADMINISTRADOR, 
    COORDENADOR
}

// Classe para representar o Semestre
public class Semestre {
    private LocalDate dataInicio;
    private LocalDate dataFim;
    private List<EpocaExame> epocasExame;
}

// Enum para tipos de épocas de exame
public enum TipoEpocaExame {
    NORMAL, 
    RECURSO, 
    ESPECIAL
}

// Classe para representar Época de Exame
public class EpocaExame {
    private TipoEpocaExame tipo;
    private LocalDate dataInicio;
    private LocalDate dataFim;
}

// Classe para representar Curso
public class Curso {
    private String nome;
    private List<UnidadeCurricular> unidadesCurriculares;
}

// Classe para representar Unidade Curricular
public class UnidadeCurricular {
    private String nome;
    private TipoAvaliacao tipoAvaliacao;
    private List<ElementoAvaliacao> elementosAvaliacao;
}

// Enum para tipos de avaliação
public enum TipoAvaliacao {
    MISTA,    // Obrigatório 2 momentos, um em época de exames
    CONTINUA  // Obrigatório pelo menos 3 momentos
}

// Classe para representar Elemento de Avaliação
public class ElementoAvaliacao {
    private TipoElementoAvaliacao tipo;
    private double ponderacao;
    private LocalDateTime dataHora;
    private Sala sala;
    private boolean necessitaComputador;
    private LocalDateTime dataLimiteEntrega;
}

// Enum para tipos de elementos de avaliação
public enum TipoElementoAvaliacao {
    TESTE,
    TESTE_FINAL,
    TRABALHO,
    ENTREGA_TRABALHO,
    ENTREGA_TRABALHO_GRUPO,
    APRESENTACAO_TRABALHO,
    APRESENTACAO_TRABALHO_GRUPO,
    MONOGRAFIA,
    EXERCICIO_PRATICO,
    PITCH,
    EXAME_FINAL,
    PROVA_ORAL
}

// Classe para representar Sala
public class Sala {
    private String codigo;
    private int capacidade;
    private int computadores;
    private boolean disponivel;
}

// Classe de Serviço para Alocação de Salas
public class ServicoAlocacaoSalas {
    public Sala alocarSala(int numeroAlunos, boolean necessitaComputador) {
        // Lógica de alocação de salas
    }
}