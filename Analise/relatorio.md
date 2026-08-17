# Relatorio Tecnico Executivo - Pipeline CI com SonarQube

Desafio: Integracao Continua com GitHub Actions e SonarQube

Projeto: pipeline-ci-com-sonarqube

Data de geracao: 07/08/2026

Status geral: VERDE - estrutura, aplicacao, testes, workflow e configuracao SonarQube preparados; testes locais passaram com 100% de cobertura e checks do PR passaram no GitHub Actions/SonarCloud.

## 1. Analises Previas da Resposta ao Desafio

| Analise | Ponto avaliado | Decisao tomada |
| --- | --- | --- |
| 1 | O desafio exige PR aberto com checks obrigatorios. | A solucao inclui workflow em Pull Request e orientacao objetiva para Branch Protection Rules. |
| 2 | O avaliador precisa ver checks do CI e do SonarQube como Required. | O workflow separa os jobs `tests` e `sonarqube`, facilitando marcar ambos como required status checks. |
| 3 | O repositorio deve ser publico e conter estrutura obrigatoria. | A estrutura foi criada com `.github/workflows/ci.yaml`, `src`, `tests`, `sonar-project.properties`, `README.md` e `Analise`. |

## 2. Revisoes de Qualidade da Solucao

| Revisao | Verificacao | Resultado |
| --- | --- | --- |
| 1 | Validacao da aplicacao Node.js. | Codigo simples, deterministico e coberto por testes unitarios. |
| 2 | Validacao da pipeline. | Pipeline instala dependencias, executa Jest com cobertura e roda SonarQube. |
| 3 | Validacao do Quality Gate. | `sonar.qualitygate.wait=true` foi configurado para reprovar a analise quando o Quality Gate falhar. |

## 3. Sumario Executivo

Foi criada uma aplicacao Node.js simples com uma calculadora e mensagem de execucao. A suite de testes usa Jest com cobertura em formato LCOV. A pipeline do GitHub Actions executa automaticamente em Pull Requests contra a branch `main`, instala dependencias, executa testes unitarios e aciona a analise do SonarQube.

| Item | Evidencia | Status |
| --- | --- | --- |
| Aplicacao Node.js | `src/calculator.js` e `src/index.js` | VERDE - OK |
| Testes unitarios | `tests/calculator.test.js` e `tests/index.test.js` | VERDE - OK |
| Pipeline CI | `.github/workflows/ci.yaml` | VERDE - OK |
| SonarQube | `sonar-project.properties` | VERDE - OK |
| Quality Gate | `sonar.qualitygate.wait=true` | VERDE - OK |
| Evidencia local | `Analise/npm-test-resultado.txt` | VERDE - OK |
| Pull Request aberto | `https://github.com/fredjml/fc-pipeline-CI-sonarqube/pull/1` | VERDE - OK |
| Branch Protection | Checks `tests`, `sonarqube` e `SonarCloud Code Analysis` configurados como obrigatorios | VERDE - OK |

## 4. Tech Stack e Padroes

| Area | Tecnologia/Padrao | Uso no desafio |
| --- | --- | --- |
| Linguagem | Node.js / JavaScript | Aplicacao simples e testavel. |
| Testes | Jest | Testes unitarios e relatorio de cobertura. |
| CI | GitHub Actions | Execucao automatica a cada Pull Request. |
| Qualidade | SonarQube | Analise estatica e Quality Gate. |
| Governanca | Branch Protection Rules | Bloqueio de merge sem checks verdes. |

## 5. Aplicacao

A aplicacao implementa operacoes basicas de calculadora e uma funcao `hello` que demonstra a execucao.

```js
const { add } = require("./calculator");

function hello() {
  return `Hello CI with SonarQube: 2 + 3 = ${add(2, 3)}`;
}
```

## 6. Testes Unitarios

Os testes cobrem soma, subtracao, multiplicacao, divisao, divisao por zero e a mensagem principal da aplicacao.

Comando:

```bash
npm test
```

Resultado esperado:

```text
Test Suites: 2 passed, 2 total
Tests: 6 passed, 6 total
Coverage: 100% statements, branches, functions and lines
```

Evidencia salva em `Analise/npm-test-resultado.txt`.

## 7. Pipeline de CI

Arquivo: `.github/workflows/ci.yaml`

O workflow roda em Pull Requests contra `main` e possui dois jobs principais:

| Job | Responsabilidade | Deve ser Required |
| --- | --- | --- |
| `tests` | Instalar dependencias e executar Jest com cobertura. | Sim |
| `sonarqube` | Executar testes com cobertura e enviar analise ao SonarQube. | Sim |

## 8. SonarQube e Quality Gate

Arquivo: `sonar-project.properties`

Configuracoes principais:

```properties
sonar.sources=src
sonar.tests=tests
sonar.javascript.lcov.reportPaths=coverage/lcov.info
sonar.qualitygate.wait=true
```

Secrets necessarios no GitHub:

| Secret | Uso |
| --- | --- |
| `SONAR_TOKEN` | Token de autenticacao no SonarQube. |
| `SONAR_HOST_URL` | URL do servidor SonarQube. |

## 9. Regra de Ouro - Status Checks

Para atender ao criterio de aceite, configurar a protecao da branch `main`:

1. Acessar `Settings > Branches`.
2. Criar ou editar uma regra para `main`.
3. Ativar `Require status checks to pass before merging`.
4. Selecionar os checks `tests` e `sonarqube`.
5. Abrir um Pull Request e nao realizar merge.

Evidencia esperada no PR:

| Check | Resultado esperado | Etiqueta |
| --- | --- | --- |
| `tests` | Verde | Required |
| `sonarqube` | Verde | Required |

## 10. Entregavel

Pull Request aberto:

```text
https://github.com/fredjml/fc-pipeline-CI-sonarqube/pull/1
```

Checks validados no PR:

| Check | Resultado |
| --- | --- |
| `tests` | Verde - passou |
| `sonarqube` | Verde - passou |
| `SonarCloud Code Analysis` | Verde - passou |

Required status checks configurados na branch `main`:

| Required check | Origem |
| --- | --- |
| `tests` | GitHub Actions |
| `sonarqube` | GitHub Actions |
| `SonarCloud Code Analysis` | SonarCloud |

O entregavel final deve manter o Pull Request aberto, com os checks `tests`, `sonarqube` e `SonarCloud Code Analysis` verdes e marcados como `Required`.

Importante: o merge nao deve ser realizado antes da avaliacao.

## 11. Conclusao

O desafio foi preparado com a estrutura obrigatoria, aplicacao Node.js, testes unitarios, workflow de CI, configuracao do SonarQube e orientacao de Branch Protection Rules. A etapa que depende do ambiente externo e a publicacao no GitHub, cadastro dos secrets, configuracao da branch `main` e abertura do Pull Request.
