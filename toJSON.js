/**
 * Converte os dados TXT para JSON
 * 
 * Fui julgado por não trabalhar com csv :(
 */

const fs = require('fs');
const args = process.argv;
const filePath = args[args.length - 1];

const data = fs.readFileSync('./' + filePath, 'utf-8');

const lines = data.split('\n');
const linesSeparated = lines.map(line => line.split(';'));

const keys = linesSeparated[0];
const obj = linesSeparated.reduce((ac, it, index) => {
    if (!index) return ac;

    const newObj = {};
    keys.forEach((k, i) => {
        const v = (it[i] || '');
        if (/([0-9]*(\.)*)+,[0-9]{2}/g.test(v)) {
            newObj[k] = Number(v.replace(/(\.|")/g, '').replace(',', '.'));
        } else {
            newObj[k] = v;
        }
    });

    ac.push(newObj);

    return ac;
}, []);

fs.writeFileSync(
    filePath + '.json',
    JSON.stringify(obj, null, 2)
);