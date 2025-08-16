document.addEventListener("DOMContentLoaded", () => {
    const sourceEl = document.getElementById("source");
    const estadoEl = document.getElementById("estado");
    const anoEl = document.getElementById("ano");
    const mesEl = document.getElementById("mes");

    async function postJSON(url, data) {
        const response = await fetch(url, {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify(data)
        });
        return response.json();
    }

    function populateSelect(selectEl, values) {
        selectEl.innerHTML = "";
        values.forEach(v => {
            const option = document.createElement("option");
            option.value = v;
            option.textContent = v;
            selectEl.appendChild(option);
        });

        // Seleciona o primeiro valor por padrão, se existir
        if (values.length > 0) {
            selectEl.value = values[0];
        }
    }

    async function updateDateOptions() {
        const ano = parseInt(anoEl.value) || new Date().getFullYear();
        const data = await postJSON("/get_date_options", { ano: ano });
        populateSelect(mesEl, data.meses);
        await loadCharts(); // encadeia carregamento de gráficos
    }


    async function loadCharts() {
        document.body.style.cursor = 'wait';  // Cursor de espera
        const source = sourceEl.value;
        const estado = estadoEl.value;
        const ano = parseInt(anoEl.value) || new Date().getFullYear();
        const mes = parseInt(mesEl.value) || 'All';

        const payload = { source, estado, ano, mes };
        console.log(source);
        const charts = await postJSON("/get_data", payload);

        let subtitle = '';
        if (mes != 'All'){
            subtitle += ' - ' + mes;
        }

        if (estado != 'All'){
            subtitle += ' - ' + estado;
        }
        const title_chart = ['Curtailed Generation by Power Plant', 'Curtailment Ratio Global by Power Plant',
        'Curtailed Generation by State', 'Curtailed Generation by Month',
        'Curtailed Generation by Day', 'Curtailed Generation by Hour', '', '', ''];

        const group_name = ['Curtail', 'CFN', 'ENE', 'REL', '', '', '', '', ''];
        const xaxis_title = ['Power Plant', 'Power Plant', 'State', 'Month', 'Day of Week', 'Hour of the Day', '', '', ''];
        const yaxis_title = ['Energy (MWh)', 'Curtailment Ratio %', 'Energy (MWh)', 'Energy (MWh)', 'Energy (MWh)', 'Energy (MWh)', '', '', ''];

        if (charts === undefined ) {

            document.body.style.cursor = 'default';  // Cursor normal
            return;
        }
        console.log(charts);
        charts.forEach((chart, i) => {
            var layout = {
                barmode: 'stack',
                title: { text: source + ' ' + title_chart[i] +'<br><span style="font-size: 12px;">' + ano + subtitle + '</span>',
                         font: { size: 14, color: 'black' }
                },
                xaxis: {
                    title: {
                        text: xaxis_title[i],
                        font: {size: 12, color: 'Black' },

                    },
                    automargin: true,
                    tickfont: {
                        size: 9 // Set the desired font size here
                    }

                },
                yaxis: {
                    title: {
                        text: yaxis_title[i],
                        font: { size: 12, color: 'black' }
                    },
                    automargin: true,
                    tickfont: {
                        size: 9 // Set the desired font size here
                    }
                    //tickformat: '.1%', // Formats as percentage with no decimal places
                }
            };

            switch (i) {
                case 1:
                    var trace1 = {
                        x: chart.y1,
                        y: chart.x,
                        name:  group_name[0],
                        type: 'bar',
                        orientation: 'h'
                    };
                    var data = [trace1];
                    layout.xaxis.title.text = yaxis_title[i];
                    layout.yaxis.title.text = xaxis_title[i];
                    break; // Important to prevent "fall-through" to subsequent cases
                default:
                    var trace1 = {
                        x: chart.x,
                        y: chart.y1,
                        name:  group_name[1],
                        type: 'bar'
                    };
                    var trace2 = {
                      x: chart.x,
                      y: chart.y2,
                      name: group_name[2],
                      type: 'bar'
                    };
                    var trace3 = {
                      x: chart.x,
                      y: chart.y3,
                      name:  group_name[3],
                      type: 'bar'
                    };
                    var data = [trace1, trace2, trace3];
            };
            Plotly.newPlot(`chart${i}`, data, layout);

        });
        document.body.style.cursor = 'default';  // Cursor normal
    }

    // Eventos
    sourceEl.addEventListener("change", loadCharts);
    estadoEl.addEventListener("change", updateDateOptions);
    anoEl.addEventListener("change", updateDateOptions);
    mesEl.addEventListener("change", loadCharts);

    // Inicialização com valores seguros
    updateDateOptions();
});



// Objeto para guardar o estado de cada div
const divEstados = new WeakMap();

// Seleciona todos os divs com a classe "curt_painel => dashcurtailment.html"
const divs = document.querySelectorAll(".curt_painel");
divs.forEach(div => {
    div.addEventListener("dblclick", () => {
        const estadoAtual = divEstados.get(div) || {
            isMaximized: false,
            width: div.offsetWidth + "px",
            height: div.offsetHeight + "px",
            top: div.offsetTop + "px",
            left: div.offsetLeft + "px",
            position: getComputedStyle(div).position
        };

        if (!estadoAtual.isMaximized) {
            // Maximiza o painel
            div.style.position = "fixed";
            div.style.top = "0";
            div.style.left = "0";
            div.style.width = "100vw";
            div.style.height = "100vh";
            div.style.zIndex = "9999";

            divEstados.set(div, { ...estadoAtual, isMaximized: true });

        } else {
            // Restaura para o tamanho original
            div.style.position = estadoAtual.position;
            div.style.top = estadoAtual.top;
            div.style.left = estadoAtual.left;
            div.style.width = estadoAtual.width;
            div.style.height = estadoAtual.height;
            div.style.zIndex = "";

            divEstados.set(div, { ...estadoAtual, isMaximized: false });
        }
        Plotly.Plots.resize(div);
    });
});

