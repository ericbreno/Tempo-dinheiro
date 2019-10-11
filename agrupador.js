const dadosParalisadasAtrasadas = require('./dados-extraidos/atrasadas-paralisadas.csv');

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
    sumarizacao.totalObras += Number(e.valor_inicial_contrato) || 0;
    sumarizacao.totalPago += Number(e.valor_total_pago) || 0;

    const pct = Math.round((e.valor_total_pago / e.valor_inicial_contrato) * 10000) / 100;
    sumarizacao.pctsConcluidos.push({
        pct,
        contratada: e.contratada,
        classificacao: e.classificacao,
        municipio_nome: e.municipio_nome
    });

    if (pct <= 25) {
        sumarizacao.obrasPorFaixa['0-25']++;
    } else if (pct <= 50) {
        sumarizacao.obrasPorFaixa['26-50']++;
    } else if (pct <= 75) {
        sumarizacao.obrasPorFaixa['51-75']++;
    } else {
        sumarizacao.obrasPorFaixa['76-100']++;
    }

    atrasoPorTipo[e.classificacao] = atrasoPorTipo[e.classificacao] || { tipo: e.classificacao, qtd: 0 };
    atrasoPorTipo[e.classificacao].qtd++;
});

const pares = Object.values(atrasoPorTipo).sort((a, b) => - a.qtd + b.qtd);

sumarizacao.atrasoPorTipo = pares;
sumarizacao.pctsConcluidos = sumarizacao.pctsConcluidos.sort((a, b) => - a.pct + b.pct);
sumarizacao.pctsConcluidos.forEach(e => {
    e.pct = e.pct.toFixed(2) + '%';
});

sumarizacao.totalObras = 'R$ ' + sumarizacao.totalObras.toFixed(2).replace('.', ',');
sumarizacao.totalPago = 'R$ ' + sumarizacao.totalPago.toFixed(2).replace('.', ',');

require('fs').writeFileSync(
    'dados-extraidos/sumarizados.json',
    JSON.stringify(sumarizacao, null, 2)
);

