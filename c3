// Autenticação
@Entity
public class Usuario {
    @Id
    private Long id;
    private String username;
    private String senha;
    private TipoUtilizador tipo;
    
    // Método de autenticação
    public boolean autenticar(String senhaDigitada) {
        return BCrypt.checkpw(senhaDigitada, this.senha);
    }
}

public class ServicoAutenticacao {
    private static final int MAX_TENTATIVAS = 3;
    
    public Usuario login(String username, String senha) throws AuthenticationException {
        Usuario usuario = repositorioUsuario.findByUsername(username);
        
        if (usuario == null) {
            throw new AuthenticationException("Usuário não encontrado");
        }
        
        if (usuario.getTentativasLogin() >= MAX_TENTATIVAS) {
            throw new AuthenticationException("Conta bloqueada");
        }
        
        if (usuario.autenticar(senha)) {
            // Reset tentativas
            usuario.resetTentativasLogin();
            return usuario;
        } else {
            usuario.incrementarTentativasLogin();
            throw new AuthenticationException("Credenciais inválidas");
        }
    }
}

// Logging
public class LoggerConfig {
    private static final Logger logger = LoggerFactory.getLogger(LoggerConfig.class);
    
    public void registrarEventoAvaliacao(ElementoAvaliacao avaliacao, TipoEvento tipoEvento) {
        switch(tipoEvento) {
            case CRIACAO:
                logger.info("Avaliação criada: {} para curso {}", 
                    avaliacao.getTipo(), 
                    avaliacao.getUnidadeCurricular().getCurso().getNome());
                break;
            case MODIFICACAO:
                logger.warn("Avaliação modificada: {}", avaliacao.getId());
                break;
            case ERRO:
                logger.error("Erro na avaliação: {}", avaliacao.getId());
                break;
        }
    }
}

// Relatórios
public class RelatorioAvaliacao {
    public void gerarRelatorioSemestral(Curso curso, Semestre semestre) {
        List<ElementoAvaliacao> avaliacoes = repositorio.buscarAvaliacoesPorCursoESemestre(curso, semestre);
        
        // Geração de relatório em PDF
        Document document = new Document();
        PdfWriter.getInstance(document, new FileOutputStream("relatorio.pdf"));
        document.open();
        
        // Cabeçalho
        document.add(new Paragraph("Relatório de Avaliações"));
        document.add(new Paragraph("Curso: " + curso.getNome()));
        document.add(new Paragraph("Semestre: " + semestre.toString()));
        
        // Tabela de avaliações
        PdfPTable tabela = new PdfPTable(4);
        tabela.addCell("Unidade Curricular");
        tabela.addCell("Tipo Avaliação");
        tabela.addCell("Data");
        tabela.addCell("Ponderação");
        
        for (ElementoAvaliacao av : avaliacoes) {
            tabela.addCell(av.getUnidadeCurricular().getNome());
            tabela.addCell(av.getTipo().toString());
            tabela.addCell(av.getDataHora().toString());
            tabela.addCell(String.valueOf(av.getPonderacao()));
        }
        
        document.add(tabela);
        document.close();
    }
    
    public Map<String, Double> calcularEstatisticasAvaliacao(Curso curso) {
        List<ElementoAvaliacao> avaliacoes = repositorio.buscarAvaliacoesPorCurso(curso);
        
        Map<String, Double> estatisticas = new HashMap<>();
        estatisticas.put("totalAvaliacoes", (double) avaliacoes.size());
        estatisticas.put("mediaAvaliacoesPorUC", 
            avaliacoes.stream()
                .collect(Collectors.groupingBy(
                    a -> a.getUnidadeCurricular().getNome(), 
                    Collectors.counting()))
                .values().stream()
                .mapToDouble(Long::doubleValue)
                .average()
                .orElse(0.0)
        );
        
        return estatisticas;
    }
}

// Enum para tipos de eventos de log
public enum TipoEvento {
    CRIACAO,
    MODIFICACAO,
    ERRO
}
