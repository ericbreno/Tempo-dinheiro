const dadosParalisadasAtrasadas = require('./dados/atrasadas-paralisadas');

const sumarizacao = {
    totalObras: 0,
    totalPago: 0,
    pctsConcluidos: [],
    atrasoPorTipo: [],
    obrasPorFaixa: {
        '0-25': 0,
        '26-50': 0,
        '51-75': 0,
        '76-100': 0
    }
};

const atrasoPorTipo = {};

dadosParalisadasAtrasadas.forEach(e => {
    sumarizacao.totalObras += e.valor_inicial_contrato;
    sumarizacao.totalPago += e.valor_total_pago;

    const pct = Math.round((e.valor_total_pago / e.valor_inicial_contrato) * 100) / 100;
    sumarizacao.pctsConcluidos.push(pct);

    if (pct <= 25) {
        sumarizacao.obrasPorFaixa['0-25']++;
    } else if (pct <= 25) {
        sumarizacao.obrasPorFaixa['26-50']++;
    } else if (pct <= 25) {
        sumarizacao.obrasPorFaixa['51-75']++;
    } else {
        sumarizacao.obrasPorFaixa['76-100']++;
    }

    atrasoPorTipo[e.classificacao] = atrasoPorTipo[e.classificacao] || { tipo: e.classificacao, qtd: 0 };
    atrasoPorTipo[e.classificacao].qtd++;
});

atr

require('fs').writeFileSync(
    'dados-extraidos/sumarizados.json',
    JSON.stringify(sumarizacao, null, 2)
);

